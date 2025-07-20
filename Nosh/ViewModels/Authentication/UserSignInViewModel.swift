import FirebaseAuth
import Foundation

final class UserSignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    // Sign in logic
    func signInUser() async {
        guard isValidEmail(email) else {
            print("Invalid email format")
            return
        }
        do {
            let returnedUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
            print("Signed in successfully")
            print(returnedUserData)
        } catch {
            print("Error signing in: \(error.localizedDescription)")
        }
    }


    // Optional helper
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}

