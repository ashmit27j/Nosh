import SwiftUI

struct Home: View {
    // Home button vars
    @State private var showRandomDish = false
    @State private var randomMeal: MealItem? = nil

    // Other vars
    @State private var searchText = ""
    @State private var showCollapsedTitle = false
    @State private var isEditing = false
    @State private var selectedCategory: String? = ""
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"

    let viewModel: MealPlannerViewModel
    let onSwitchToMealPlanner: () -> Void

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
                        AiChefSection()
                            .padding(.horizontal, 16)

                        QuickBitesSection(selectedCategory: $selectedCategory)
                            .padding(.horizontal, 16)

                        HomeButtons(showRandomDish: Binding(
                            get: { showRandomDish },
                            set: { newValue in
                                if newValue {
                                    randomMeal = viewModel.generateRandomMeal()
                                    showRandomDish = true
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
                    #warning("this is the thing that pushes all content down by 100 pixels")
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
            .sheet(isPresented: $showRandomDish) {
                if let meal = randomMeal {
                    RandomDishSheet(meal: meal) {
                        randomMeal = viewModel.generateRandomMeal()
                    }
                } else {
                    ProgressView("Loading...")
                        .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
//                        .foregroundColor(Color("secondaryAccent"))
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

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
