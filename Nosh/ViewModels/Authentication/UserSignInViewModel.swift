import Swift
import FirebaseAuth
import Foundation
final class UserSignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var errorMessage: String?

    var isEmailInvalid: Bool {
        errorMessage == "Please enter a valid email."
    }

    var isPasswordInvalid: Bool {
        errorMessage == "Password cannot be empty."
    }

    func signInUser() async {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty."
            return
        }

        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
