import SwiftUI
import Firebase
import GoogleSignIn

@main
struct NoshApp: App {

    @StateObject private var appState = AppState()
    @StateObject private var accessibilityEnv = AccessibilityEnvironment.shared

    /// Retained so the notification centre delegate stays alive for the life of
    /// the app — it is installed in the object's initializer.
    @StateObject private var notificationDelegate = NotificationCenterDelegate()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(accessibilityEnv)
                // Applies the chosen accent to system controls app-wide.
                .tint(accessibilityEnv.accent)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
