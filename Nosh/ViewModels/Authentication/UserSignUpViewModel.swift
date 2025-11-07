import Foundation
import FirebaseAuth

class UserSignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessages: [String: String] = [:]
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    
    func signUpUser() {
        // Clear previous errors
        errorMessages.removeAll()
        
        // Validate email
        if email.isEmpty {
            errorMessages["email"] = "Email cannot be empty"
        } else if !isValidEmail(email) {
            errorMessages["email"] = "Please enter a valid email address"
        }
        
        // Validate username
        if username.isEmpty {
            errorMessages["username"] = "Username cannot be empty"
        } else if username.count < 3 {
            errorMessages["username"] = "Username must be at least 3 characters"
        }
        
        // Validate password with PasswordValidator
        if password.isEmpty {
            errorMessages["password"] = "Password cannot be empty"
        } else if !PasswordValidator.isValid(password) {
            errorMessages["password"] = "Password does not meet requirements"
        }
        
        // Validate confirm password
        if confirmPassword.isEmpty {
            errorMessages["confirmPassword"] = "Please confirm your password"
        } else if password != confirmPassword {
            errorMessages["confirmPassword"] = "Passwords do not match"
        }
        
        // If there are errors, don't proceed
        guard errorMessages.isEmpty else {
            return
        }
        
        // Proceed with Firebase sign up
        Task {
            do {
                let result = try await AuthenticationManager.shared.signUp(email: email, password: password)
                print("Sign up successful: \(result.user.email ?? "")")
                // TODO: Save username to Firestore
            } catch {
                errorMessages["general"] = error.localizedDescription
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
