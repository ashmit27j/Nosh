import SwiftUI

struct AuthFlowView: View {
    @State private var showSignIn = true
    
    var body: some View {
        if showSignIn {
            UserSignIn(switchToSignUp: { showSignIn = false })
        } else {
            UserSignUp(switchToSignIn: { showSignIn = true })
        }
    }
    
}
