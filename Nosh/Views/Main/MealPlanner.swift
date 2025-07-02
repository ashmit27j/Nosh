import SwiftUI
import Foundation
struct MealPlanner: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "Mon"
    @State private var showCollapsedTitle = false

    @Namespace private var underlineNamespace
    @StateObject var viewModel: MealPlannerViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // MARK: - Scrollable Meal List
                MealListView(viewModel: viewModel, selectedTab: selectedTab)
                    .padding(.top, 128)
                    .padding(.bottom, 100)
                    .onPreferenceChange(ScrollOffsetKey.self) { offset in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showCollapsedTitle = offset < -20
                        }
                    }

                // MARK: - Sticky Header
                StickyHeaderView(
                    searchText: $searchText,
                    isEditing: $isEditing,
                    selectedTab: $selectedTab,
                    showCollapsedTitle: showCollapsedTitle,
                    tabs: viewModel.tabs,
                    underlineNamespace: underlineNamespace
                )
            }
            .navigationTitle("Meal Planner")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("primaryBackground"))
        }
    }
}

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


// ... existing imports and structs

struct MealSectionView: View {
    let title: String
    let meals: [MealItem]
    let onEditTapped: () -> Void
    let onAdd: () -> Void
    let onDelete: (MealItem) -> Void
    let isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                //breakfast lunch dinner titles are these
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("primaryText"))

                //to help with alignment
                Spacer()

                //edit button
                Button(action: onEditTapped) {
                    Text(!isEditing ? "Edit" : "Done")
                        .foregroundColor(Color("primaryAccent"))
                        .fontWeight(.medium)
                }
            }

            //line divider here
            Rectangle()
                .fill(Color("buttonSecondary"))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .cornerRadius(100)

            ForEach(meals) { meal in
                // show meal card with built-in edit/cook/delete logic
                MealCard(
                    meal: meal,
                    isEditing: isEditing,
                    onDelete: { onDelete(meal) } // pass delete handler
                )
            }

            //this is the part visible when editing
            if isEditing {
                Button(action: onAdd) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("primaryAccent"))
                        Text("Add \(title) Dish")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("secondaryText"))
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

// MARK: - Sticky Header Section
struct StickyHeaderView: View {
    @Binding var searchText: String
    @Binding var isEditing: Bool
    @Binding var selectedTab: String
    let showCollapsedTitle: Bool
    let tabs: [String]
    var underlineNamespace: Namespace.ID

    var body: some View {
        VStack(spacing: 8) {
            if showCollapsedTitle {
                Text("Pantry")
                    .font(.headline)
                    .transition(.opacity)
            }

            // MARK: - Search Bar
            HStack(spacing: 8) {
                SearchBar(text: $searchText, isEditing: $isEditing)

                if isEditing {
                    Button("Cancel") {
                        searchText = ""
                        isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(.accentColor)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isEditing)

            // MARK: - Tabs
            TabSelectorView(
                tabs: tabs,
                selectedTab: $selectedTab,
                underlineNamespace: underlineNamespace
            )
        }
        .padding()
        .background(Color("primaryCard"))
    }
}

// MARK: - Tab Selector
struct TabSelectorView: View {
    let tabs: [String]
    @Binding var selectedTab: String
    var underlineNamespace: Namespace.ID

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(tabs, id: \.self) { tab in
                    VStack(spacing: 2) {
                        Button(action: {
                            selectedTab = tab
                        }) {
                            Text(tab)
                                .fontWeight(selectedTab == tab ? .semibold : .regular)
                                .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                .padding(.top, 10)
                        }

                        Capsule()
                            .frame(height: 3)
                            .foregroundColor(selectedTab == tab ? Color("primaryAccent") : .clear)
                            .matchedGeometryEffect(id: "underline", in: underlineNamespace, isSource: selectedTab == tab)
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

func sampleMeal() -> MealItem {
    return MealItem(
        name: "Cheese Frankie",
        imageName: "frankieImage",  // Must exist in Assets
        cookTime: 20,
        servingSize: 2,
        isAvailableInPantry: true
//        isAvailableInPantry: false
    )
}



