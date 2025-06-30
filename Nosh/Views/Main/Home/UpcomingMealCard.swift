import SwiftUI

struct UpcomingMealCard: View {
    let meal: UpcomingMeal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 10) {
                Text(meal.name)
                    .font(.headline)

                Button(action: {
                    // TODO: Handle action
                }) {
                    HStack {
                        Text("Cook Now")
                        Image(systemName: "arrow.right")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color("primaryAccent"))
                    .cornerRadius(10)
                }
            }
            .padding(20)
        }
        .background(Color("primaryCard"))
        
        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
    }
}
