import SwiftUI

struct UpcomingMealsSection: View {
    @State private var currentIndex = 0
    let onViewAllTapped: () -> Void

    let meals: [MealCard] = [
        MealCard(
            id: "1",
            image: "frankieImage",
            name: "Veggie Wrap",
            timeToCook: 30,
            difficulty: .easy
        ),
        MealCard(
            id: "2",
            image: "frankieImage",
            name: "Spicy Pasta",
            timeToCook: 45,
            difficulty: .novice
        ),
        MealCard(
            id: "3",
            image: "frankieImage",
            name: "Gourmet Pizza",
            timeToCook: 60,
            difficulty: .intermediate
        ),
        MealCard(
            id: "4",
            image: "frankieImage",
            name: "Fancy Biryani",
            timeToCook: 90,
            difficulty: .professional
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Header
            HStack {
                Text("Upcoming meals")
                    .font(.title2.bold())

                Spacer()

                Button(action: onViewAllTapped) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundColor(Color("primaryAccent"))

                        Image("triangleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(Color("primaryButtonText"))
                    }
                }
            }

            // Carousel
            TabView(selection: $currentIndex) {
                ForEach(meals.indices, id: \.self) { index in
                    MealCardView(meal: meals[index])
                        .padding(.horizontal, 4)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 280)

            // Dot indicators
            HStack(spacing: 6) {
                ForEach(0..<meals.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.primary : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
