import SwiftUI
//list of meals in mealplanner page
struct MealListView: View {
    @ObservedObject var viewModel: MealPlannerViewModel
    /// Firestore day key (yyyy-MM-dd) for the day being shown.
    let selectedTab: String
    let onGotoPantry: () -> Void
    @State private var isEditing = false
    @State private var showMealSelector = false
    @State private var selectedMealType: MealType = .breakfast

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) { //scrollbars nikala
            VStack(spacing: 20) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    MealSectionView(
                        title: mealType.rawValue,
                        meals: viewModel.meals(for: selectedTab, type: mealType),
                        mealTimes: viewModel.mealTimes,
                        onEditTapped: { isEditing.toggle() },
                        onAdd: {
                            selectedMealType = mealType
                            showMealSelector = true
                        },
                        onDelete: { meal in
                            Task { await viewModel.removeMeal(from: selectedTab, type: mealType, meal: meal) }
                        },
                        onUpdateMealTime: { newTime in
                            viewModel.updateMealTime(newTime, for: mealType)
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

