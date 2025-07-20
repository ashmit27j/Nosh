import FirebaseAuth
import FirebaseFirestore
import Foundation

final class UserSignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
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

        Task {
            do {
                // Create user
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let uid = authResult.user.uid

                // Store user data in Firestore
                let data: [String: Any] = [
                    "username": self.username,
                    "email": self.email
                ]

                try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .setData(data)

                print("User account created and data saved to Firestore.")
                // Navigate to main app screen if needed
            } catch {
                print("Error signing up: \(error.localizedDescription)")
            }
        }
    }

    // Optional helper
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
