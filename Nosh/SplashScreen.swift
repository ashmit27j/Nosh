import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                MainTabView() // 👈 Replace with your actual entry point
            } else {
                ZStack {
                    Color("logoBackground") // ⬅️ Matches storyboard background
                        .ignoresSafeArea()

                    Image("noshBannerFinal") // ⬅️ Same asset used in Launch Screen
                        .resizable()
                        .scaledToFit()
                        .frame(width: 232, height: 129) // ⬅️ Exact storyboard size
                }
            }
        }
        .onAppear {
            // Splash delay (adjust as needed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
