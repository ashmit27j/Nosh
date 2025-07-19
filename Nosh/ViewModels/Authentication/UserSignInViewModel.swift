import FirebaseAuth
import Foundation

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    // Sign in logic
    func signInUser() {
        guard isValidEmail(email) else {
            print("Invalid email format")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
            } else {
                print("User signed in successfully.")
                // Navigate to main app screen if needed
            }
        }
    }

    // Optional helper
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}

