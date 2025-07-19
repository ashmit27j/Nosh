import FirebaseAuth
import Foundation

final class UserSignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    // Sign up logic
    func signUpUser() {
        guard isValidEmail(email) else {
            print("Invalid email format")
            return
        }

        guard password == confirmPassword else {
            print("Passwords do not match")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("User account created successfully.")
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
