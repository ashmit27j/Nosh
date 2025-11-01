import SwiftUI

struct Nosh: View {
    @StateObject private var viewModel = NoshViewModel()
    @State private var selectedCategory: String? = "Full Meal"
    @State private var selectedPreference: String? = "Both"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 60  // ← Start at 60 mins
    @State private var selectedDifficulty: String? = "Beginner"
    @State private var showResults: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Color.clear.frame(height: 72)

                        CategorySelector(selectedCategory: $selectedCategory)
                        FoodPreferenceSelector(selectedPreference: $selectedPreference)
                        PortionSizeSelector(portionSize: $portionSize)
                        TimeToCookSlider(timeToCook: $timeToCook)
                        DifficultySelector(selectedDifficulty: $selectedDifficulty)
                        
                        // Cook Now Button
                        Button(action: {
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
                        
                        // Results Section
                        if showResults {
                            ResultsSection
                        }
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 56)
                }
                .background(Color("primaryBackground"))
                .ignoresSafeArea(edges: .top)
                
                NoshHeader
            }
            .sheet(isPresented: $showResults) {
                MealResultsView(meals: viewModel.meals)
            }
        }
    }
    
    private var ResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.meals.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No recipes found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Try adjusting your filters")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                Text("Found \(viewModel.meals.count) recipes")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.meals) { meal in
                            MealCardView(meal: meal)
                                .frame(width: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private func searchMeals() {
        viewModel.searchMeals(
            category: selectedCategory,
            portionSize: portionSize,
            maxTimeToCook: Int(timeToCook),
            difficulty: selectedDifficulty,
            foodPreference: selectedPreference
        )
        showResults = true
    }
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
