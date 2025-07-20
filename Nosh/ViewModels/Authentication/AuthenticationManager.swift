import Foundation
import FirebaseAuth

// MARK: - Auth Data Result Model
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

// MARK: - Authentication Manager
//final class AuthenticationManager {
//    static let shared = AuthenticationManager()
//    private init() { }
//
//    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
//        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        return AuthDataResultModel(user: authDataResult.user)
//    }
//}

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    static let shared = AuthenticationManager()

    private init() {}

    func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }
}
