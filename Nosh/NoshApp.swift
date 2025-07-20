import SwiftUI
import Firebase

@main
struct NoshApp: App {
    init() {
        FirebaseApp.configure()
        print("configured Firebase")
    }
    var body: some Scene {
        WindowGroup {
//            SplashScreen()
            //temp for now
            AuthFlowView()
            
        }
    }
}


