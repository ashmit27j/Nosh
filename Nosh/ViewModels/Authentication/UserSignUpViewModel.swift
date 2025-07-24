import FirebaseAuth
import FirebaseFirestore
import Foundation
final class UserSignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var errorMessages: [String: String] = [:]

    func signUpUser() {
        errorMessages = [:]

        if !isValidEmail(email) {
            errorMessages["email"] = "Please enter a valid email."
        }

        if username.count < 3 {
            errorMessages["username"] = "Username must be at least 3 characters."
        }

        if password.count < 6 {
            errorMessages["password"] = "Password must be at least 6 characters."
        }

        if password != confirmPassword {
            errorMessages["confirmPassword"] = "Passwords do not match."
        }

        guard errorMessages.isEmpty else { return }

        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let uid = authResult.user.uid

                let data: [String: Any] = [
                    "username": username,
                    "email": email
                ]

                try await Firestore.firestore().collection("users").document(uid).setData(data)

                print("User signed up and data saved.")
            } catch {
                errorMessages["firebase"] = error.localizedDescription
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
