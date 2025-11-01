import SwiftUI

struct UpcomingMealsSection: View {
    @State private var currentIndex = 0
    @State private var cardHeight: CGFloat = 380 // Default height
    let onViewAllTapped: () -> Void

    let meals: [Meal] = [
        Meal(
            id: "1",
            name: "Veggie Wrap",
            imageName: "frankieImage",
            timeToCook: 30,
            servingSize: 2,
            difficulty: .easy
        ),
        Meal(
            id: "2",
            name: "Spicy Pasta",
            imageName: "frankieImage",
            timeToCook: 45,
            servingSize: 3,
            difficulty: .novice
        ),
        Meal(
            id: "3",
            name: "Gourmet Pizza",
            imageName: "frankieImage",
            timeToCook: 60,
            servingSize: 4,
            difficulty: .intermediate
        ),
        Meal(
            id: "4",
            name: "Fancy Biryani",
            imageName: "frankieImage",
            timeToCook: 90,
            servingSize: 4,
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
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: CardHeightKey.self, value: geo.size.height)
                            }
                        )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: cardHeight)
            .onPreferenceChange(CardHeightKey.self) { height in
                if height > 0 {
                    cardHeight = height
                }
            }

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

// MARK: - PreferenceKey for Card Height
struct CardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 380
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
