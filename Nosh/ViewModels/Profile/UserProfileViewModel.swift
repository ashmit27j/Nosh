import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserProfileViewModel: ObservableObject {
    @Published var username: String = "Loading..."
    @Published var photoURL: URL?

    init() {
        fetchUserProfile()
    }

    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else {
            self.username = "Not signed in"
            return
        }

        self.photoURL = user.photoURL

        let uid = user.uid
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.username = data["username"] as? String ?? "User"
                }
            } else {
                print("Failed to load username: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
}
