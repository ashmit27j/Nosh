import SwiftUI

struct SocialIconsRow: View {
    @EnvironmentObject var appState: AppState  
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                SocialIconBox(assetImage: "googleIcon") {
                    handleGoogleSignIn()
                }
                SocialIconBox(systemImage: "apple.logo") {
                    // TODO: Implement Apple Sign In -> too expensive to buy an account
                }
                SocialIconBox(systemImage: "phone.fill") {
                    // TODO: Implement Phone Sign In -> didnt do yet
                }
            }
            
            //so that user knows that its loading still
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("primaryAccent")))
                    .padding(.top, 8)
            }
            
            //if error encountered show error as text
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    //handles google sign in
    private func handleGoogleSignIn() {
        isLoading = true
        showError = false
        errorMessage = ""
        
        Task {
            do {
                _ = try await AuthenticationManager.shared.signInWithGoogle()
                
                // Update your app state to reflect signed-in status
                await MainActor.run {
                    appState.isUserSignedIn = true
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                    Log.auth.error("Google sign-in failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
