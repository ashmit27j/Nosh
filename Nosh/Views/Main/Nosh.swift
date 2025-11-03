import SwiftUI

struct Nosh: View {
    @StateObject private var viewModel = NoshViewModel()
    @State private var selectedCategories: Set<String> = ["Full Meal"]  // Changed to Set
    @State private var selectedPreference: String? = "Both"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 60
    @State private var selectedDifficulty: String? = "Beginner"
    @State private var showResults: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Color.clear.frame(height: 72)

                        CategorySelector(
                            selectedCategories: $selectedCategories,
                            allowMultipleSelection: false  // Single-select for Nosh
                        )
                        FoodPreferenceSelector(selectedPreference: $selectedPreference)
                        DifficultySelector(selectedDifficulty: $selectedDifficulty)
                        TimeToCookSlider(timeToCook: $timeToCook)
                        
                        // Find Recipes Button
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
    }
    
    private func searchMeals() {
        print("🎯 searchMeals() called")
        viewModel.searchMeals(
            categories: Array(selectedCategories),  // Convert Set to Array
            portionSize: portionSize,
            maxTimeToCook: Int(timeToCook),
            difficulty: selectedDifficulty,
            foodPreference: selectedPreference
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🍽️ Setting showResults = true with \(viewModel.meals.count) meals")
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
}
