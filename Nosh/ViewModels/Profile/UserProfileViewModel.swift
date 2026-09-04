import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var photoURL: URL?
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    init() {
        fetchUserProfile()
    }

    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else {
            username = "Not signed in"
            photoURL = nil
            return
        }

        // Show the Auth photo immediately (Google provides one), then let the
        // Firestore value override it if the user has uploaded their own.
        photoURL = user.photoURL
        username = user.displayName ?? ""

        isLoading = true

        Task { [weak self] in
            guard let self else { return }
            defer { self.isLoading = false }

            do {
                let document = try await db.collection("users")
                    .document(user.uid).getDocument()
                guard let data = document.data() else { return }

                if let name = data["username"] as? String, !name.isEmpty {
                    self.username = name
                } else if self.username.isEmpty {
                    self.username = user.email?.components(separatedBy: "@").first ?? "Chef"
                }

                // This is the field editProfileView writes after an upload.
                // Reading only Auth's photoURL meant an uploaded photo never
                // appeared, which looked like the upload itself had failed.
                if let stored = data["photoURL"] as? String,
                   let url = URL(string: stored) {
                    self.photoURL = url
                }
            } catch {
                if self.username.isEmpty { self.username = "Chef" }
            }
        }
    }
}
