import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var accessibilityEnv: AccessibilityEnvironment
    

    var body: some View {
        Group {
            if appState.showSplash {
                SplashScreen()
            } else {
                if appState.isUserSignedIn {
                    MainTabView()
                        .environmentObject(appState)
                } else {
                    AuthFlowView()
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
}
