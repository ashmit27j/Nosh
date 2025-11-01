import SwiftUI

struct UpcomingMealCard: View {
    let meal: UpcomingMeal

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipped() // Removed corner radius

            VStack(alignment: .leading, spacing: 8) {
                Text(meal.name)
                    .font(.headline)

                Text("Ready in 30 min · Serves 2")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    // TODO: Handle cook action
                }) {
                    HStack {
                        Text("Cook Now")
                            .foregroundColor(Color("primaryButtonText"))
                        Image("triangleIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(Color("primaryButtonText"))
                    }
                    .font(.subheadline.bold())
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color("primaryAccent"))
                    .cornerRadius(10)
                }
            }
            .padding(20)
            .background(Color("primaryCard"))
        }
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
}
