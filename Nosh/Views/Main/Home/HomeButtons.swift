import SwiftUI
struct HomeButtons: View {
    @Binding var showRandomDish: Bool

    var body: some View {
        HStack(spacing: 20) {
            // Random button
            Button(action: {
                showRandomDish = true
            }) {
                HStack(spacing: 12) {
                    Image("diceIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color("secondaryAccent"))

                    Text("Random")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("secondaryAccent"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("primaryAccent"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            //MARK: Recipes NavigationLink 
            NavigationLink(destination: RecipesView()) {
                HStack(spacing: 12) {
                    Image("menuIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color("secondaryAccent"))

                    Text("Recipes")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("secondaryAccent"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("primaryAccent"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.horizontal, 16)
    }
}
