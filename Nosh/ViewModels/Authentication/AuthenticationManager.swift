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

    /// Runs the Google sign-in flow and returns a Firebase credential.
    /// Shared by first sign-in and by re-authentication before destructive actions.
    @MainActor
    func googleCredential() async throws -> AuthCredential {
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
                ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first
        else {
            throw AuthError.noWindowScene
        }

        guard let rootViewController = windowScene.windows
                .first(where: { $0.isKeyWindow })?.rootViewController
        else {
            throw AuthError.noRootViewController
        }

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.noClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.noIDToken
        }

        return GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
    }

    @MainActor
    func signInWithGoogle() async throws -> AuthDataResult {
        let credential = try await googleCredential()
        let result = try await Auth.auth().signIn(with: credential)

        // Google accounts skip the sign-up form, so this is where their profile
        // document gets created.
        try await AccountService.shared.provisionUserDocument(for: result.user)

        return result
    }

    // MARK: - Sign Out

    /// The single sign-out path. Clears the Google session as well as Firebase —
    /// signing out of Firebase alone leaves the Google account silently selected
    /// for the next sign-in.
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
