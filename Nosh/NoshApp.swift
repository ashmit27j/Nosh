import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct NoshApp: App {
    // Register the custom AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}

// AppDelegate to configure Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
