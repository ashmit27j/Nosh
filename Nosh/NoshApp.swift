import SwiftUI
import Firebase

@main
struct NoshApp: App {
    
    @StateObject var appState = AppState()
    @StateObject var accessibilityEnv = AccessibilityEnvironment.shared

    init() {
        FirebaseApp.configure()
        print("configured Firebase")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(accessibilityEnv) 
        }
    }
}
