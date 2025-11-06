//import SwiftUI
//import FirebaseFirestore
//
//struct MealSelectorSheet: View {
//    let selectedTab: String
//    let mealType: String
//    @ObservedObject var viewModel: MealPlannerViewModel
//    
//    @Environment(\.dismiss) var dismiss
//    @State private var searchText = ""
//    @State private var allRecipes: [Meal] = []
//    @State private var searchResults: [Meal] = []
//    @State private var isLoading = true
//    
//    var displayedRecipes: [Meal] {
//        searchText.isEmpty ? allRecipes : searchResults
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Darker background matching your app
//                Color("primaryBackground")
//                    .ignoresSafeArea()
//                
//                VStack(spacing: 0) {
//                    // Search Bar
//                    HStack {
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.gray)
//                            
//                            TextField("Search recipes...", text: $searchText)
//                                .textFieldStyle(PlainTextFieldStyle())
//                                .autocorrectionDisabled()
//                                .onChange(of: searchText) { newValue in
//                                    performSearch(query: newValue)
//                                }
//                            
//                            if !searchText.isEmpty {
//                                Button {
//                                    searchText = ""
//                                    searchResults = []
//                                } label: {
//                                    Image(systemName: "xmark.circle.fill")
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                        .padding(12)
//                        .background(Color("primaryCard"))
//                        .cornerRadius(12)
//                    }
//                    .padding()
//                    
//                    // Recipe List
//                    if isLoading {
//                        Spacer()
//                        ProgressView()
//                            .tint(Color("primaryAccent"))
//                        Spacer()
//                    } else if displayedRecipes.isEmpty {
//                        Spacer()
//                        VStack(spacing: 16) {
//                            Image(systemName: searchText.isEmpty ? "fork.knife" : "magnifyingglass")
//                                .font(.system(size: 48))
//                                .foregroundColor(.gray)
//                            Text(searchText.isEmpty ? "No recipes available" : "No recipes found")
//                                .font(.headline)
//                                .foregroundColor(.secondary)
//                            if !searchText.isEmpty {
//                                Text("Try searching with different keywords")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                        Spacer()
//                    } else {
//                        ScrollView {
//                            LazyVStack(spacing: 12) {
//                                ForEach(displayedRecipes) { meal in
//                                    CompactMealCardView(
//                                        meal: meal,
//                                        showAddButton: true,
//                                        onAdd: {
//                                            addMealToSchedule(meal)
//                                        }
//                                    )
//                                }
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Add \(mealType.capitalized)")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            loadAllRecipes()
//        }
//    }
//    
//    // MARK: - Load All Recipes
//    private func loadAllRecipes() {
//        isLoading = true
//        
//        Task {
//            do {
//                // Load all recipes from Firestore
//                let snapshot = try await Firestore.firestore()
//                    .collection("recipes")
//                    .limit(to: 100)
//                    .getDocuments()
//                
//                let recipes = snapshot.documents.compactMap { doc -> Meal? in
//                    try? doc.data(as: Meal.self)
//                }
//                
//                await MainActor.run {
//                    allRecipes = recipes
//                    isLoading = false
//                }
//            } catch {
//                print("Error loading recipes: \(error)")
//                await MainActor.run {
//                    isLoading = false
//                }
//            }
//        }
//    }
//    
//    // MARK: - Search Function
//    private func performSearch(query: String) {
//        guard !query.isEmpty else {
//            searchResults = []
//            return
//        }
//        
//        Task {
//            do {
//                let results = try await viewModel.searchMeals(query: query)
//                await MainActor.run {
//                    searchResults = results
//                }
//            } catch {
//                print("Search error: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - Add Meal Function
//    private func addMealToSchedule(_ meal: Meal) {
//        print("🍽️ Adding meal: \(meal.name) to \(selectedTab) - \(mealType)")
//        viewModel.addMeal(to: selectedTab, type: mealType, meal: meal)
//        
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            dismiss()
//        }
//    }
//}

import SwiftUI
import FirebaseFirestore

struct MealSelectorSheet: View {
    let selectedTab: String
    let mealType: String
    @ObservedObject var viewModel: MealPlannerViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var allRecipes: [Meal] = []
    @State private var searchResults: [Meal] = []
    @State private var isLoading = true
    @State private var isAddingMeal = false  // NEW: Track if we're currently adding
    
    var displayedRecipes: [Meal] {
        searchText.isEmpty ? allRecipes : searchResults
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("primaryBackground")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search recipes...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .autocorrectionDisabled()
                                .onChange(of: searchText) { newValue in
                                    performSearch(query: newValue)
                                }
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    searchResults = []
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color("primaryCard"))
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    // Recipe List
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .tint(Color("primaryAccent"))
                        Spacer()
                    } else if displayedRecipes.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: searchText.isEmpty ? "fork.knife" : "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text(searchText.isEmpty ? "No recipes available" : "No recipes found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            if !searchText.isEmpty {
                                Text("Try searching with different keywords")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(displayedRecipes) { meal in
                                    CompactMealCardView(
                                        meal: meal,
                                        showAddButton: true,
                                        onAdd: {
                                            addMealToSchedule(meal)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                // Loading overlay when adding meal
                if isAddingMeal {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
            .navigationTitle("Add \(mealType.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isAddingMeal)  // Disable cancel while adding
                }
            }
        }
        .onAppear {
            loadAllRecipes()
        }
        .interactiveDismissDisabled(isAddingMeal)  // Prevent dismiss while adding
    }
    
    // MARK: - Load All Recipes
    private func loadAllRecipes() {
        isLoading = true
        
        Task {
            do {
                let snapshot = try await Firestore.firestore()
                    .collection("recipes")
                    .limit(to: 100)
                    .getDocuments()
                
                let recipes = snapshot.documents.compactMap { doc -> Meal? in
                    try? doc.data(as: Meal.self)
                }
                
                await MainActor.run {
                    allRecipes = recipes
                    isLoading = false
                }
            } catch {
                print("Error loading recipes: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    // MARK: - Search Function
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            do {
                let results = try await viewModel.searchMeals(query: query)
                await MainActor.run {
                    searchResults = results
                }
            } catch {
                print("Search error: \(error)")
            }
        }
    }
    
    // MARK: - Add Meal Function (FIXED)
    private func addMealToSchedule(_ meal: Meal) {
        // Prevent multiple taps
        guard !isAddingMeal else {
            print("⚠️ Already adding a meal, ignoring tap")
            return
        }
        
        isAddingMeal = true
        
        print("🍽️ Starting to add meal: \(meal.name) to \(selectedTab) - \(mealType)")
        
        // Add the meal
        viewModel.addMeal(to: selectedTab, type: mealType, meal: meal)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Wait a bit longer for Firestore to complete, then dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isAddingMeal = false
            dismiss()
        }
    }
}
