import SwiftUI

struct MealListView: View {
    @ObservedObject var viewModel: MealPlannerViewModel
    let selectedTab: String

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            GeometryReader { geo in
                Color.clear
                    .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
            }
            .frame(height: 0)

            VStack(spacing: 24) {
                if let mealsByType = viewModel.items[selectedTab] {
                    // Section 1
                    MealSectionView(
                        title: "Breakfast",
                        meals: mealsByType["breakfast"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            viewModel.addMeal(to: selectedTab, type: "breakfast", meal: sampleMeal())
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "breakfast", meal: meal)
                        },
                        isEditing: isEditing
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)

                    // Section 2
                    MealSectionView(
                        title: "Lunch",
                        meals: mealsByType["lunch"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            viewModel.addMeal(to: selectedTab, type: "lunch", meal: sampleMeal())
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "lunch", meal: meal)
                        },
                        isEditing: isEditing
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)

                    // Section 3
                    MealSectionView(
                        title: "Dinner",
                        meals: mealsByType["dinner"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            viewModel.addMeal(to: selectedTab, type: "dinner", meal: sampleMeal())
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "dinner", meal: meal)
                        },
                        isEditing: isEditing
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .coordinateSpace(name: "scroll")
    }
}
