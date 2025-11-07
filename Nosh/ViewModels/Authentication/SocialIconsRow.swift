//
//  SocialIconsRow.swift
//  Nosh
//
//  Created by MacBook on 07/11/25.
//
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
                    // TODO: Implement Apple Sign In
                }
                SocialIconBox(systemImage: "phone.fill") {
                    // TODO: Implement Phone Sign In
                }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("primaryAccent")))
                    .padding(.top, 8)
            }
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private func handleGoogleSignIn() {
        isLoading = true
        showError = false
        errorMessage = ""
        
        Task {
            do {
                let result = try await AuthenticationManager.shared.signInWithGoogle()
                print("✅ Google Sign In successful: \(result.user.email ?? "")")
                
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
                    print("❌ Google Sign In failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
