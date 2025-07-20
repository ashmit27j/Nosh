import Foundation
import FirebaseAuth

class AppState: ObservableObject {
    @Published var isUserSignedIn: Bool = false
    @Published var showSplash: Bool = true

    init() {
        // Splash lasts for 0.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showSplash = false
        }

        // Monitor Firebase auth state
        Auth.auth().addStateDidChangeListener { _, user in
            self.isUserSignedIn = (user != nil)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        isUserSignedIn = false
    }
}
