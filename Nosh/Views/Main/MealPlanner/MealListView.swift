import SwiftUI

struct MealListView: View {
    @ObservedObject var viewModel: MealPlannerViewModel
    let selectedTab: String
    let onGotoPantry: () -> Void
    @State private var isEditing = false
    @State private var showMealSelector = false
    @State private var selectedMealType: String = ""

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) { //scrollbars nikala
            VStack(spacing: 20) {
                if let mealsByType = viewModel.items[selectedTab] {
                    // Section 1 - Breakfast
                    MealSectionView(
                        title: "Breakfast",
                        meals: mealsByType["breakfast"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            selectedMealType = "breakfast"
                            showMealSelector = true
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "breakfast", meal: meal)
                        },
                        isEditing: isEditing,
                        onGotoPantry: onGotoPantry
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)

                    // Section 2 - Lunch
                    MealSectionView(
                        title: "Lunch",
                        meals: mealsByType["lunch"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            selectedMealType = "lunch"
                            showMealSelector = true
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "lunch", meal: meal)
                        },
                        isEditing: isEditing,
                        onGotoPantry: onGotoPantry
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)

                    // Section 3 - Dinner
                    MealSectionView(
                        title: "Dinner",
                        meals: mealsByType["dinner"] ?? [],
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            selectedMealType = "dinner"
                            showMealSelector = true
                        },
                        onDelete: { meal in
                            viewModel.removeMeal(from: selectedTab, type: "dinner", meal: meal)
                        },
                        isEditing: isEditing,
                        onGotoPantry: onGotoPantry
                    )
                    .padding(16)
                    .background(Color("primaryCard"))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 80)
        }
        .coordinateSpace(name: "scroll")
        .sheet(isPresented: $showMealSelector) {
            MealSelectorSheet(
                selectedTab: selectedTab,
                mealType: selectedMealType,
                viewModel: viewModel
            )
        }
    }
}

