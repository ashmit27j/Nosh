import SwiftUI
// MARK: - Upcoming Meal Card
struct UpcomingMealCard: View {
    var imageName: String
    var title: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text("Breakfast\n330 kCalories\nMaterials: available\nCook at 3:30")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Text("Cook Now")
                        Image(systemName: "arrow.right")
                    }
                    .font(.footnote.bold())
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(maxHeight: 100)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
