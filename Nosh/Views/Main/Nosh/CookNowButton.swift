import SwiftUI
//may reuse this in ohter pages
struct CookNowButton: View {
    var body: some View {
        Button(action: {
            // TODO: Handle Cook Now action (havent reached yet)
        }) {
            Text("Cook Now")
                .font(.headline)
                .foregroundColor(Color("primaryText"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("primaryAccent"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
}
