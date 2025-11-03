import SwiftUI

struct RecipesView: View {
    @State private var selectedCategories: Set<String> = []
    @StateObject private var viewModel = RecipesViewModel()
    @State private var selectedMealForCooking: Meal? = nil

    var body: some View {
        // REMOVED NavigationStack - already in Home
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CategorySelector(
                    selectedCategories: $selectedCategories,
                    allowMultipleSelection: true
                )
                
                // Show results when categories selected
                if !selectedCategories.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Found \(viewModel.meals.count) recipes")
                                .font(.title3.bold())
                                .foregroundColor(Color("primaryText"))
                            
                            Spacer()
                            
                            // Selected categories chips
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Array(selectedCategories), id: \.self) { cat in
                                        Text(cat)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color("primaryAccent").opacity(0.2))
                                            .foregroundColor(Color("primaryAccent"))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            VStack(spacing: 16) {
                                ProgressView()
                                Text("Loading recipes...")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 60)
                        } else if viewModel.meals.isEmpty {
                            // No results state
                            VStack(spacing: 20) {
                                Image(systemName: "fork.knife.circle")
                                    .font(.system(size: 70))
                                    .foregroundColor(Color.gray.opacity(0.4))
                                
                                VStack(spacing: 8) {
                                    Text("No recipes found")
                                        .font(.title2.bold())
                                        .foregroundColor(Color.gray.opacity(0.8))
                                    
                                    Text("Try selecting different categories")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray.opacity(0.6))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(viewModel.meals) { meal in
                                    MealCardView(
                                        meal: meal,
                                        onCookNowTapped: { selectedMeal in
                                            print("🔥 Meal tapped: \(selectedMeal.name)")
                                            selectedMealForCooking = selectedMeal
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                } else {
                    // Empty state - no categories selected
                    VStack(spacing: 16) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("Select categories to view recipes")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                }
            }
            .padding(.top)
            .padding(.bottom, 100)
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.large)
        .background(Color("primaryBackground"))
        .onChange(of: selectedCategories) { newCategories in
            print("📁 Categories changed: \(newCategories)")
            if !newCategories.isEmpty {
                viewModel.fetchMeals(categories: Array(newCategories))
            } else {
                viewModel.meals = []
            }
        }
        .sheet(item: $selectedMealForCooking) { meal in
            RecipeView(meal: meal)
        }
    }
}
