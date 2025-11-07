import SwiftUI

struct AuthFlowView: View {
    @State private var showSignIn = true
    @EnvironmentObject var appState: AppState  
    
    var body: some View {
        if showSignIn {
            UserSignIn(switchToSignUp: { showSignIn = false })
                .environmentObject(appState)
        } else {
            UserSignUp(switchToSignIn: { showSignIn = true })
                .environmentObject(appState)
        }
    }
}
