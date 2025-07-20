import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var profileImageURL: URL?

    init() {
        fetchUserProfile()
    }

    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else { return }

        let uid = user.uid
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.username = data["username"] as? String ?? "Anonymous"
            }
        }

        // For Google profile image (if signed in with Google)
        if let url = user.photoURL {
            self.profileImageURL = url
        }
    }
}
