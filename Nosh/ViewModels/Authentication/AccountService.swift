import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

/// Account lifecycle work that touches more than one system: creating the user
/// document at sign-up, and tearing down every trace of a user at deletion.
///
/// Firestore does not cascade deletes, so removing `users/{uid}` leaves its
/// subcollections orphaned. Everything under the user is enumerated and deleted
/// explicitly here before the profile document and the auth record go.
final class AccountService {
    static let shared = AccountService()

    private init() {}

    private var db: Firestore { Firestore.firestore() }

    // MARK: - Provisioning

    /// Creates or completes `users/{uid}`. Safe to call on every sign-in:
    /// `merge: true` means an existing profile keeps the values it already has,
    /// and `username` is only written when the document does not yet exist.
    func provisionUserDocument(
        for user: User,
        username: String? = nil
    ) async throws {
        let ref = db.collection("users").document(user.uid)
        let existing = try? await ref.getDocument()

        var data: [String: Any] = [
            "email": user.email ?? ""
        ]

        if existing?.exists != true {
            let defaults = MealTimes.default
            data["username"] = username
                ?? user.displayName
                ?? user.email?.components(separatedBy: "@").first
                ?? "Chef"
            data["createdAt"] = Timestamp(date: Date())
            data["breakfastTime"] = Timestamp(date: defaults.breakfastTime)
            data["lunchTime"] = Timestamp(date: defaults.lunchTime)
            data["dinnerTime"] = Timestamp(date: defaults.dinnerTime)
            if let photo = user.photoURL?.absoluteString {
                data["photoURL"] = photo
            }
        } else if let username, !username.isEmpty {
            data["username"] = username
        }

        try await ref.setData(data, merge: true)
    }

    // MARK: - Deletion

    enum DeletionError: LocalizedError {
        case notSignedIn
        case reauthenticationRequired

        var errorDescription: String? {
            switch self {
            case .notSignedIn:
                return "No user is currently signed in."
            case .reauthenticationRequired:
                return "For your security, please confirm your identity to delete your account."
            }
        }
    }

    /// Which credential the signed-in user would need to supply to re-authenticate.
    enum ReauthMethod {
        case password
        case google
        case unknown
    }

    func reauthMethod(for user: User) -> ReauthMethod {
        let providers = user.providerData.map(\.providerID)
        if providers.contains(GoogleAuthProviderID) { return .google }
        if providers.contains(EmailAuthProviderID) { return .password }
        return .unknown
    }

    /// Re-authenticates using the provider the account was created with.
    /// `password` is required for email/password accounts and ignored for Google.
    @MainActor
    func reauthenticate(password: String?) async throws {
        guard let user = Auth.auth().currentUser else { throw DeletionError.notSignedIn }

        switch reauthMethod(for: user) {
        case .google:
            let result = try await AuthenticationManager.shared.googleCredential()
            try await user.reauthenticate(with: result)

        case .password:
            guard let email = user.email, let password, !password.isEmpty else {
                throw DeletionError.reauthenticationRequired
            }
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            try await user.reauthenticate(with: credential)

        case .unknown:
            throw DeletionError.reauthenticationRequired
        }
    }

    /// Deletes all Firestore data for the user, then the auth record itself.
    ///
    /// Order matters: the Firestore writes need the user's credentials to satisfy
    /// the security rules, so they must happen while the auth record still exists.
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { throw DeletionError.notSignedIn }
        let uid = user.uid

        try await deleteUserData(uid: uid)

        do {
            try await user.delete()
        } catch let error as NSError where AuthErrorCode(rawValue: error.code) == .requiresRecentLogin {
            throw DeletionError.reauthenticationRequired
        }

        GIDSignIn.sharedInstance.signOut()
    }

    /// Removes every document beneath `users/{uid}`, then the profile document.
    private func deleteUserData(uid: String) async throws {
        let userRef = db.collection("users").document(uid)

        // Subcollections are fixed and known, so they can be enumerated directly.
        // `listCollections` is Admin-SDK only and unavailable on iOS.
        for name in ["pantry", "mealPlanner"] {
            try await deleteAllDocuments(in: userRef.collection(name))
        }

        try await userRef.delete()
    }

    /// Deletes a collection in batches. Firestore caps a write batch at 500 ops.
    private func deleteAllDocuments(in collection: CollectionReference) async throws {
        while true {
            let snapshot = try await collection.limit(to: 400).getDocuments()
            guard !snapshot.documents.isEmpty else { return }

            let batch = db.batch()
            for document in snapshot.documents {
                batch.deleteDocument(document.reference)
            }
            try await batch.commit()

            // A short page means that was the last one.
            if snapshot.documents.count < 400 { return }
        }
    }
}
