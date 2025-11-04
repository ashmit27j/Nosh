//import SwiftUI
//
//struct RecipesView: View {
//    @State private var selectedCategories: Set<String> = []
//    @StateObject private var viewModel = RecipesViewModel()
//    @State private var selectedMealForCooking: Meal? = nil
//
//    var body: some View {
//        // REMOVED NavigationStack - already in Home
//        ScrollView(showsIndicators: false) {
//            VStack(spacing: 20) {
//                CategorySelector(
//                    selectedCategories: $selectedCategories,
//                    allowMultipleSelection: true
//                )
//                
//                // Show results when categories selected
//                if !selectedCategories.isEmpty {
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Text("Found \(viewModel.meals.count) recipes")
//                                .font(.title3.bold())
//                                .foregroundColor(Color("primaryText"))
//                            
//                            Spacer()
//                            
//                            // Selected categories chips
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: 8) {
//                                    ForEach(Array(selectedCategories), id: \.self) { cat in
//                                        Text(cat)
//                                            .font(.caption)
//                                            .padding(.horizontal, 8)
//                                            .padding(.vertical, 4)
//                                            .background(Color("primaryAccent").opacity(0.2))
//                                            .foregroundColor(Color("primaryAccent"))
//                                            .cornerRadius(8)
//                                    }
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                        
//                        if viewModel.isLoading {
//                            VStack(spacing: 16) {
//                                ProgressView()
//                                Text("Loading recipes...")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .padding(.top, 60)
//                        } else if viewModel.meals.isEmpty {
//                            // No results state
//                            VStack(spacing: 20) {
//                                Image(systemName: "fork.knife.circle")
//                                    .font(.system(size: 70))
//                                    .foregroundColor(Color.gray.opacity(0.4))
//                                
//                                VStack(spacing: 8) {
//                                    Text("No recipes found")
//                                        .font(.title2.bold())
//                                        .foregroundColor(Color.gray.opacity(0.8))
//                                    
//                                    Text("Try selecting different categories")
//                                        .font(.subheadline)
//                                        .foregroundColor(Color.gray.opacity(0.6))
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding(.top, 60)
//                        } else {
//                            VStack(spacing: 20) {
//                                ForEach(viewModel.meals) { meal in
//                                    MealCardView(
//                                        meal: meal,
//                                        onCookNowTapped: { selectedMeal in
//                                            print("🔥 Meal tapped: \(selectedMeal.name)")
//                                            selectedMealForCooking = selectedMeal
//                                        }
//                                    )
//                                    .padding(.horizontal)
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    // Empty state - no categories selected
//                    VStack(spacing: 16) {
//                        Image(systemName: "square.grid.2x2")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray.opacity(0.5))
//                        Text("Select categories to view recipes")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.top, 100)
//                }
//            }
//            .padding(.top)
//            .padding(.bottom, 100)
//        }
//        .navigationTitle("Recipes")
//        .navigationBarTitleDisplayMode(.large)
//        .background(Color("primaryBackground"))
//        .onChange(of: selectedCategories) { newCategories in
//            print("📁 Categories changed: \(newCategories)")
//            if !newCategories.isEmpty {
//                viewModel.fetchMeals(categories: Array(newCategories))
//            } else {
//                viewModel.meals = []
//            }
//        }
//        .sheet(item: $selectedMealForCooking) { meal in
//            RecipeView(meal: meal)
//        }
//    }
//}


import SwiftUI

struct RecipesView: View {
    @State private var selectedCategories: Set<String> = []
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @StateObject private var viewModel = RecipesViewModel()
    @State private var selectedMealForCooking: Meal? = nil
    
    // All available categories
    private let allCategories = ["Quick Meals", "Full Meal", "Snacks", "Desserts", "Beverages"]
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return viewModel.meals
        } else {
            return viewModel.meals.filter { meal in
                meal.name.localizedCaseInsensitiveContains(searchText) ||
                meal.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ✅ HEADER SECTION (Title, Search, Categories)
            VStack(spacing: 16) {
                // Title Row with Search Button
                HStack {
                    Text("Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryText"))
                    
                    Spacer()
                    
                    // Search Button
                    Button(action: {
                        withAnimation {
                            isSearching.toggle()
                            if !isSearching {
                                searchText = ""
                            }
                        }
                    }) {
                        Image(systemName: isSearching ? "xmark.circle.fill" : "magnifyingglass")
                            .font(.system(size: 24))
                            .foregroundColor(Color("primaryAccent"))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Search Bar (appears when isSearching is true)
                if isSearching {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("secondaryText"))
                        
                        TextField("Search recipes...", text: $searchText)
                            .font(.body)
                            .foregroundColor(Color("primaryText"))
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color("secondaryText"))
                            }
                        }
                    }
                    .padding()
                    .background(Color("primaryCard"))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Category Selector
                CategorySelector(
                    selectedCategories: $selectedCategories,
                    allowMultipleSelection: true
                )
            }
            .padding(.bottom, 16)
            .background(Color("primaryBackground"))
            
            Divider()
                .background(Color("secondaryButton").opacity(0.3))
            
            // ✅ CONTENT SECTION (Results)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading recipes...")
                                .font(.subheadline)
                                .foregroundColor(Color("secondaryText"))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 60)
                    } else if filteredMeals.isEmpty {
                        // No results state
                        VStack(spacing: 20) {
                            Image(systemName: searchText.isEmpty ? "fork.knife.circle" : "magnifyingglass")
                                .font(.system(size: 70))
                                .foregroundColor(Color.gray.opacity(0.4))
                            
                            VStack(spacing: 8) {
                                Text(searchText.isEmpty ? "No recipes found" : "No results for '\(searchText)'")
                                    .font(.title2.bold())
                                    .foregroundColor(Color.gray.opacity(0.8))
                                
                                Text(searchText.isEmpty ? "Try selecting different categories" : "Try a different search term")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray.opacity(0.6))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        // Results header
                        HStack {
                            Text("Found \(filteredMeals.count) recipe\(filteredMeals.count == 1 ? "" : "s")")
                                .font(.headline)
                                .foregroundColor(Color("primaryText"))
                            
                            Spacer()
                            
                            // Selected categories chips
                            if !selectedCategories.isEmpty && selectedCategories.count < allCategories.count {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(Array(selectedCategories).sorted(), id: \.self) { cat in
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
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Recipe Cards
                        VStack(spacing: 20) {
                            ForEach(filteredMeals) { meal in
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
                .padding(.bottom, 100)
            }
        }
        .background(Color("primaryBackground"))
        .onAppear {
            // ✅ Initialize with all categories selected
            if selectedCategories.isEmpty {
                selectedCategories = Set(allCategories)
                print("📁 Initialized with all categories: \(selectedCategories)")
                viewModel.fetchMeals(categories: allCategories)
            }
        }
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
