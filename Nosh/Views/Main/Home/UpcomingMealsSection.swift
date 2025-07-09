import SwiftUI

struct UpcomingMealsSection: View {
    @State private var currentIndex = 0
    let onViewAllTapped: () -> Void

    let meals: [UpcomingMeal] = [
        UpcomingMeal(imageName: "pancakeImage", name: "Pancakes"),
        UpcomingMeal(imageName: "pastaImage", name: "Creamy Pasta"),
        UpcomingMeal(imageName: "frankieImage", name: "Veggie Wrap"),
        UpcomingMeal(imageName: "biryaniImage", name: "Veg Biryani"),
        UpcomingMeal(imageName: "saladImage", name: "Fresh Salad")
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
                    UpcomingMealCard(meal: meals[index])
                        .tag(index)
                        .transition(.opacity)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 380)


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
