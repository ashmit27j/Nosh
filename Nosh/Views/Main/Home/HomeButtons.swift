import SwiftUI

// MARK: - Home Buttons Section
struct HomeButtons: View {
    var body: some View {
        HStack(spacing: 20) {
            // Ask Chef button
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image("cookIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)

                    Text("Ask Chef")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color("primaryAccent"))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            // Dice (Recipes) button
            Button(action: {}) {
                Image("diceIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .padding(12)
                    .background(Color("primaryAccent"))
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Spacer() // Pushes buttons to the left
        }
        .padding(.horizontal, 0) // Keep outer padding minimal, Home view handles it
    }
}
