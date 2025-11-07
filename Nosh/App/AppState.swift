import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AppState: ObservableObject {
    @Published var mealTimes: MealTimes = .default
    @Published var isUserSignedIn: Bool = false
    @Published var showSplash: Bool = true
    @Published var user: UserProfile? = nil

    init() {
        // Splash lasts for 0.5s here -> not neessary to do this, i added so firebase loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showSplash = false
        }

        // Monitor Firebase auth state
        Auth.auth().addStateDidChangeListener { _, user in
            Task {
                self.isUserSignedIn = (user != nil)
                if let user = user {
                    await self.loadUserProfile(uid: user.uid)
                } else {
                    self.user = nil
                }
            }
        }
    }

    //handle signout
    func signOut() {
        //try to signout: if dont then set isUserSigned in to false so that the view updates to the SignIn View and set user as nil to get rid of user
        try? Auth.auth().signOut()
        isUserSignedIn = false
        user = nil
    }

    func loadUserProfile(uid: String) async {
        do {
            let document = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            if let data = document.data(),
               let username = data["username"] as? String,
               let email = data["email"] as? String {
                self.user = UserProfile(uid: uid, username: username, email: email)
            } else {
                print("User document missing required fields.")
            }
        } catch {
            print("Error loading user profile: \(error.localizedDescription)")
        }
    }
}
