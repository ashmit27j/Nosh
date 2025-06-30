import SwiftUI

// MARK: - Home Buttons Section
struct HomeButtons: View {
    var body: some View {
        HStack(spacing: 20) {
            // Random button
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image("diceIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)

                    Text("Random")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("primaryAccent"))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            // Recipe button
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image("menuIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)

                    Text("Recipes")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("primaryAccent"))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
