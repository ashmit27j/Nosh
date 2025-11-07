import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit

final class AuthenticationManager {
    static let shared = AuthenticationManager()

    private init() {}

    func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    // MARK: - Google Sign In
    @MainActor
    func signInWithGoogle() async throws -> AuthDataResult {
        // Get the root view controller from your app's window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw AuthError.noWindowScene
        }
        
        guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            throw AuthError.noRootViewController
        }
        
        // Get Firebase client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.noClientID
        }
        
        // Create Google Sign In configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow - this will present Google's sign-in UI
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        // Get the ID token and access token from Google
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.noIDToken
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        // Create Firebase credential from Google tokens
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        
        // Sign in to Firebase with the credential
        return try await Auth.auth().signIn(with: credential)
    }
    
    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    // Custom errors for better error handling
    enum AuthError: LocalizedError {
        case noWindowScene
        case noRootViewController
        case noClientID
        case noIDToken
        
        var errorDescription: String? {
            switch self {
            case .noWindowScene:
                return "Unable to find window scene"
            case .noRootViewController:
                return "Unable to find root view controller"
            case .noClientID:
                return "No Firebase client ID found"
            case .noIDToken:
                return "Failed to get ID token from Google"
            }
        }
    }
}
