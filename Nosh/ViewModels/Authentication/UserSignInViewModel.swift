//import Swift
//import FirebaseAuth
//import Foundation
//final class UserSignInViewModel: ObservableObject {
//    @Published var email = ""
//    @Published var password = ""
//    @Published var showPassword = false
//    @Published var errorMessage: String? = nil
////    @Published var isEmailDoesNotExist: Bool = false
////    @Published var isPasswordInvalidAuth: Bool = false
//
//    
//    var isInvalidEmailOrPassword: Bool {
//        errorMessage == "Invalid email or password"
//    }
//    
//    var isEmailInvalid: Bool {
//        errorMessage == "Please enter a valid email."
//    }
//
//    var isPasswordInvalid: Bool {
//        errorMessage == "Password cannot be empty."
//    }
//
////    func signInUser() async {
////        self.errorMessage = "Email does not exist"
////        // or
////        self.errorMessage = "Invalid password"
////
////        guard isValidEmail(email) else {
////            errorMessage = "Please enter a valid email."
////            return
////        }
////
////        guard !password.isEmpty else {
////            errorMessage = "Password cannot be empty."
////            return
////        }
////
////        do {
////            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
////            errorMessage = nil
////        } catch let error as NSError {
////            switch AuthErrorCode(rawValue: error.code) {
////            case .userNotFound:
////                errorMessage = "Email does not exist"
////            case .wrongPassword:
////                errorMessage = "Invalid password"
////            default:
////                errorMessage = error.localizedDescription
////            }
////        }
////    }
////    func signInUser() async {
////        // Clear previous error first
////        errorMessage = nil
////
////        // Local validation
////        guard isValidEmail(email) else {
////            errorMessage = "Please enter a valid email."
////            return
////        }
////
////        guard !password.isEmpty else {
////            errorMessage = "Password cannot be empty."
////            return
////        }
////
////        do {
////            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
////            errorMessage = nil
////        } catch let error as NSError {
////            let errorCode = AuthErrorCode(rawValue: error.code)
////
////            if errorCode == .userNotFound || errorCode == .wrongPassword {
////                errorMessage = "Invalid email or password"
////            } else {
////                errorMessage = error.localizedDescription
////            }
////        }
////    }
//    func signInUser() async {
//        guard isValidEmail(email) else {
//            errorMessage = "Invalid email or password"
//            return
//        }
//
//        guard !password.isEmpty else {
//            errorMessage = "Invalid email or password"
//            return
//        }
//
//        do {
//            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
//            DispatchQueue.main.async {
//                self.errorMessage = nil
//            }
//        } catch let error as NSError {
//            let code = AuthErrorCode.Code(rawValue: error.code)
//            DispatchQueue.main.async {
//                switch code {
//                case .userNotFound, .wrongPassword:
//                    self.errorMessage = "Invalid email or password"
//                default:
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//
//
//
//
//    private func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
//    }
//}
import Swift
import FirebaseAuth
import Foundation

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
