import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AppState: ObservableObject {
    @Published var mealTimes: MealTimes = .default
    @Published var isUserSignedIn: Bool = false
    @Published var showSplash: Bool = true
    @Published var user: UserProfile? = nil

    /// Retained so the listener can be detached — it was previously registered
    /// and never removed, capturing self for the lifetime of the process.
    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        Task { @MainActor in
            // Brief splash while Firebase warms up.
            try? await Task.sleep(nanoseconds: 500_000_000)
            showSplash = false
        }

        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // The listener is not actor-isolated, so hop explicitly rather than
            // relying on Firebase's choice of callback queue.
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.isUserSignedIn = (user != nil)
                if let user {
                    await self.loadUserProfile(uid: user.uid)
                } else {
                    self.user = nil
                    self.mealTimes = .default
                }
            }
        }
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    func signOut() {
        do {
            // Routed through AuthenticationManager so the Google session is
            // cleared as well as the Firebase one.
            try AuthenticationManager.shared.signOut()
        } catch {
            // The listener still reports the change if Firebase did sign out.
        }
        isUserSignedIn = false
        user = nil
    }

    func loadUserProfile(uid: String) async {
        do {
            let document = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            guard let data = document.data() else {
                user = nil
                return
            }

            // Tolerant of a partially-written document: an account created
            // before sign-up provisioned a profile still gets a usable state.
            let email = data["email"] as? String
                ?? Auth.auth().currentUser?.email
                ?? ""
            let username = data["username"] as? String
                ?? email.components(separatedBy: "@").first
                ?? "Chef"

            user = UserProfile(uid: uid, username: username, email: email)

            if let breakfast = data["breakfastTime"] as? Timestamp,
               let lunch = data["lunchTime"] as? Timestamp,
               let dinner = data["dinnerTime"] as? Timestamp {
                mealTimes = MealTimes(
                    breakfastTime: breakfast.dateValue(),
                    lunchTime: lunch.dateValue(),
                    dinnerTime: dinner.dateValue()
                )
            }
        } catch {
            user = nil
        }
    }
}
