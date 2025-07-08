import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                MainTabView()
            } else {
                ZStack {
                    //background color to the whole screen
                    Color("logoBackground")
                        .ignoresSafeArea()
                    //Logo for Nosh with the whle name written
                    Image("noshBannerFinal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 232, height: 129)
                }
            }
        }
        .onAppear {
            // Splash delay (actual delay + 0.7 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
