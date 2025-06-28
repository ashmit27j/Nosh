import SwiftUI

struct CookNowButton: View {
    var body: some View {
        Button(action: {
            // TODO: Handle Cook Now action
        }) {
            Text("Cook Now")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("primaryAccent"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
}
