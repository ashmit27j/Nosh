import SwiftUI

struct Nosh: View {
    @StateObject private var viewModel = NoshViewModel()
    @State private var selectedCategories: Set<String> = ["Full Meal"]
    @State private var selectedPreference: String? = "Both"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 60
    @State private var selectedDifficulty: String? = "Professional"  // Changed default
    @State private var showResults: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Color.clear.frame(height: 72)

                        CategorySelector(
                            selectedCategories: $selectedCategories,
                            allowMultipleSelection: false
                        )
                        FoodPreferenceSelector(selectedPreference: $selectedPreference)
                        DifficultySelector(selectedDifficulty: $selectedDifficulty)
                        TimeToCookSlider(timeToCook: $timeToCook)
                        
                        Button(action: {
                            print("🔍 Find Recipes button tapped")
                            searchMeals()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Find Recipes")
                                    .font(.headline)
                                    .foregroundColor(Color("primaryButtonText"))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primaryAccent"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 56)
                }
                .background(Color("primaryBackground"))
                .ignoresSafeArea(edges: .top)
                
                NoshHeader
            }
            .sheet(isPresented: $showResults) {
                print("📋 Sheet opening with \(viewModel.meals.count) meals")
            } content: {
                MealResultsView(meals: viewModel.meals)
            }
        }
        .onChange(of: viewModel.showResults) { oldValue, newValue in
            if newValue {
                showResults = true
            }
        }
    }
    
    private func searchMeals() {
        print("🎯 searchMeals() called")
        
        // Convert String difficulty to Meal.Difficulty enum
        let difficultyEnum: Meal.Difficulty
        switch selectedDifficulty {
        case "Easy":
            difficultyEnum = .easy
        case "Novice":
            difficultyEnum = .novice
        case "Intermediate":
            difficultyEnum = .intermediate
        case "Professional":
            difficultyEnum = .professional
        default:
            difficultyEnum = .professional
        }
        
        viewModel.searchMeals(
            categories: Array(selectedCategories),
            portionSize: portionSize,
            maxTime: Int(timeToCook),
            difficulty: difficultyEnum,
            foodPreference: selectedPreference ?? "Both"
        )
    }
    
    private var NoshHeader: some View {
        HStack(alignment: .center) {
            Text("Nosh")
                .font(.largeTitle.bold())
                .transition(.opacity)

            Spacer()

            Button {
                print("AI Schedule generator tapped")
            } label: {
                HStack(spacing: 8) {
                    Image("cookIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color("secondaryAccent"))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color("primaryAccent"))
                .cornerRadius(16)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color("primaryCard"))
    }
}
