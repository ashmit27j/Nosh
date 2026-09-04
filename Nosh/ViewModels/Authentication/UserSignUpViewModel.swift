import Foundation
import FirebaseAuth

@MainActor
class UserSignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessages: [String: String] = [:]
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var isSigningUp = false

    func signUpUser() {
        // Clear previous errors
        errorMessages.removeAll()

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validate email
        if trimmedEmail.isEmpty {
            errorMessages["email"] = "Email cannot be empty"
        } else if !isValidEmail(trimmedEmail) {
            errorMessages["email"] = "Please enter a valid email address"
        }

        // Validate username
        if trimmedUsername.isEmpty {
            errorMessages["username"] = "Username cannot be empty"
        } else if trimmedUsername.count < 3 {
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
        guard errorMessages.isEmpty else { return }

        isSigningUp = true

        Task {
            defer { isSigningUp = false }
            do {
                let result = try await AuthenticationManager.shared.signUp(
                    email: trimmedEmail,
                    password: password
                )

                // Without this the app has an auth user but no users/{uid}
                // document, which leaves the profile, meal times and pantry
                // initialization with nowhere to read or write.
                try await AccountService.shared.provisionUserDocument(
                    for: result.user,
                    username: trimmedUsername
                )
            } catch {
                errorMessages["general"] = error.localizedDescription
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
