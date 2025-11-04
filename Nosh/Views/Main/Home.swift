import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Home: View {
    @State private var showRandomDish = false
    @State private var randomMeal: Meal? = nil
    @State private var isLoadingMeal = false
    @State private var selectedMealForCooking: Meal? = nil
    @State private var searchText = ""
    @State private var showCollapsedTitle = false
    @State private var isEditing = false
    @State private var selectedCategory: String? = ""

    let viewModel: MealPlannerViewModel
    let onSwitchToMealPlanner: () -> Void
    @Binding var isAiChefActive: Bool  // ADD THIS

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("primaryBackground")
                    .ignoresSafeArea()

                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)

                    VStack(spacing: 20) {
                        AiChefSection(isAiChefActive: $isAiChefActive)  // PASS BINDING
                            .padding()

                        QuickBitesSection(selectedCategory: $selectedCategory)
                            .padding(.horizontal, 16)

                        HomeButtons(showRandomDish: Binding(
                            get: { showRandomDish },
                            set: { newValue in
                                if newValue {
                                    isLoadingMeal = true
                                    showRandomDish = true
                                    viewModel.fetchRandomMeal { meal in
                                        randomMeal = meal
                                        isLoadingMeal = false
                                    }
                                } else {
                                    showRandomDish = false
                                }
                            }
                        ))

                        Rectangle()
                            .fill(Color("secondaryBackground"))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(100)
                            .padding(.horizontal, 16)

                        UpcomingMealsSection(onViewAllTapped: onSwitchToMealPlanner)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 146)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }

                HomeHeader
                    .zIndex(1)
            }
            .sheet(isPresented: $showRandomDish, onDismiss: {
                if selectedMealForCooking != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    }
                }
            }) {
                RandomDishSheet(
                    meal: randomMeal,
                    isLoading: isLoadingMeal,
                    onRollAgain: {
                        isLoadingMeal = true
                        viewModel.fetchRandomMeal { meal in
                            randomMeal = meal
                            isLoadingMeal = false
                        }
                    },
                    onCookNowTapped: { meal in
                        selectedMealForCooking = meal
                        showRandomDish = false
                    }
                )
            }
            .sheet(item: $selectedMealForCooking) { meal in
                RecipeView(meal: meal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAiChefActive = false  // RESET WHEN RETURNING TO HOME
        }
    }

    private var HomeHeader: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("Home")
                    .font(.largeTitle.bold())

                Spacer()

                Button {
                    print("Add tapped")
                } label: {
                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color("secondaryButton"))
                        .cornerRadius(16)
                }
            }

            HStack(spacing: 8) {
                SearchBar(text: $searchText, isEditing: $isEditing)

                if isEditing {
                    Button("Cancel") {
                        searchText = ""
                        isEditing = false
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil, from: nil, for: nil
                        )
                    }
                    .foregroundColor(.accentColor)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isEditing)
        }
        .padding()
        .background(Color("primaryCard"))
    }
}
