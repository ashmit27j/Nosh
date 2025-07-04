
import SwiftUI

struct Home: View {
    //home button vars
    @State private var showRandomDish = false
    @State private var randomMeal: MealItem? = nil

    //other vars
    @State private var searchText = ""
    @State private var showCollapsedTitle = false
    @State private var isEditing = false
    @State private var selectedCategory: String? = ""
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"
    let viewModel: MealPlannerViewModel

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

                        HomeButtons(showRandomDish: $showRandomDish)
                            

                        Rectangle()
                            .fill(Color("secondaryBackground"))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(100)
                            .padding(.horizontal, 16)

                        UpcomingMealsSection()
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }

                VStack(spacing: 8) {
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
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
            }
            .navigationTitle(showCollapsedTitle ? "Home" : "Welcome User")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showRandomDish) {
                if let meal = randomMeal {
                    RandomDishSheet(meal: meal) {
                        randomMeal = viewModel.generateRandomMeal()
                    }
                }
            }
            .onChange(of: showRandomDish) { show in
                if show {
                    randomMeal = viewModel.generateRandomMeal()
                }
            }
        }
        .id(showCollapsedTitle)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
