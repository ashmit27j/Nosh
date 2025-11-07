import Swift
import FirebaseAuth
import Foundation

//final means that we will not inherit from this class 
final class UserSignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var errorMessage: String? = nil
    @Published var showInvalidCredentialsError = false


    var isInvalidEmailOrPassword: Bool {
        errorMessage == "Invalid email or password"
    }

    var isEmailInvalid: Bool {
        errorMessage == "Please enter a valid email."
    }

    var isPasswordInvalid: Bool {
        errorMessage == "Password cannot be empty."
    }

    func signInUser() async {
        // Reset visibility each time
        await MainActor.run {
            showInvalidCredentialsError = false
        }

        guard isValidEmail(email), !password.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Invalid email or password"
                self.showInvalidCredentialsError = true
            }
            return
        }

        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.errorMessage = nil
                self.showInvalidCredentialsError = false
            }
        } catch let error as NSError {
            let authCode = AuthErrorCode(rawValue: error.code)
            await MainActor.run {
                switch authCode {
                case .userNotFound, .wrongPassword:
                    self.errorMessage = "Invalid email or password"
                    self.showInvalidCredentialsError = true
                default:
                    self.errorMessage = error.localizedDescription
                    self.showInvalidCredentialsError = true
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
