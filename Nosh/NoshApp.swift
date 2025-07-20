import SwiftUI
import Firebase

@main
struct NoshApp: App {
    @StateObject var appState = AppState()

    init() {
        FirebaseApp.configure()
        print("configured Firebase")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
