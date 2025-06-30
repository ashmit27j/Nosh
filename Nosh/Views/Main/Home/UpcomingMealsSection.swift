import SwiftUI

struct UpcomingMealsSection: View {
    @State private var currentIndex = 0

    let meals: [UpcomingMeal] = [
        UpcomingMeal(imageName: "pancakes", name: "Pancakes"),
        UpcomingMeal(imageName: "pasta", name: "Creamy Pasta"),
        UpcomingMeal(imageName: "wrap", name: "Veggie Wrap"),
        UpcomingMeal(imageName: "biryani", name: "Veg Biryani"),
        UpcomingMeal(imageName: "salad", name: "Fresh Salad")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Upcoming meals")
                    .font(.title2.bold())

                Spacer()

                NavigationLink(destination: MealPlanner(viewModel: MealPlannerViewModel(tabs: [
                    "All", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
                ]))) {
                    Text("See schedule")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }

            TabView(selection: $currentIndex) {
                ForEach(meals.indices, id: \.self) { index in
                    UpcomingMealCard(meal: meals[index])
//                        .padding(.horizontal, 12)
                        .tag(index)
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

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
