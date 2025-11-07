import SwiftUI
import Firebase
import GoogleSignIn  // Add this import

@main
struct NoshApp: App {
    
    @StateObject var appState = AppState()
    @StateObject var accessibilityEnv = AccessibilityEnvironment.shared
    @StateObject private var notificationDelegate = NotificationCenterDelegate()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(accessibilityEnv)
                .onOpenURL { url in
                    // Handle Google Sign-In callback URL
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
