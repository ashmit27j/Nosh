import Foundation
import FirebaseFirestore
import Combine

class NoshViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func searchMeals(
        category: String?,
        portionSize: Int,
        maxTimeToCook: Int,
        difficulty: String?,
        foodPreference: String?
    ) {
        isLoading = true
        errorMessage = nil
        meals = []
        
        print("🔍 Starting search with:")
        print("   Category: \(category ?? "All")")
        print("   Portion Size: \(portionSize)")
        print("   Max Time: \(maxTimeToCook)")
        print("   Difficulty: \(difficulty ?? "Any")")
        print("   Food Preference: \(foodPreference ?? "Both")")
        
        // Get ALL recipes (no index needed)
        db.collection("recipes").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    print("❌ Error: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("❌ No documents")
                    return
                }
                
                print("📦 Got \(documents.count) total documents")
                
                // Parse all meals
                let parsedMeals = documents.compactMap { Meal(from: $0.data()) }
                print("✅ Parsed \(parsedMeals.count) meals")
                
                // Filter in memory
                var filteredMeals = parsedMeals
                
                // ✅ Filter by time (0 to maxTimeToCook)
                filteredMeals = filteredMeals.filter { $0.timeToCook <= maxTimeToCook }
                print("⏱️ After time filter (0-\(maxTimeToCook)): \(filteredMeals.count) meals")
                
                // ✅ Filter by category (exact match)
                if let category = category, !category.isEmpty, category != "All" {
                    let categoryId = self.mapCategoryToId(category)
                    filteredMeals = filteredMeals.filter { $0.categoryId == categoryId }
                    print("📁 After category filter (\(category) only): \(filteredMeals.count) meals")
                }
                
                // ✅ Filter by serving size
                filteredMeals = filteredMeals.filter { $0.servingSize >= portionSize }
                print("🍽️ After serving size filter (>= \(portionSize)): \(filteredMeals.count) meals")
                
                // ✅ Filter by difficulty (inclusive - selected level and below)
                if let difficulty = difficulty, !difficulty.isEmpty {
                    let maxDifficultyInt = self.mapDifficultyToInt(difficulty)
                    filteredMeals = filteredMeals.filter {
                        self.mapDifficultyEnumToInt($0.difficulty) <= maxDifficultyInt
                    }
                    print("🎯 After difficulty filter (<= \(difficulty)): \(filteredMeals.count) meals")
                }
                
                // ✅ Filter by food preference (Both = show all, Veg = 0 only, Non-Veg = 1 only)
                if let preference = foodPreference {
                    if preference == "Veg" {
                        // Only veg (0)
                        filteredMeals = filteredMeals.filter { $0.preferences == 0 }
                        print("🥗 After veg filter (0 only): \(filteredMeals.count) meals")
                    } else if preference == "Non-Veg" {
                        // Only non-veg (1)
                        filteredMeals = filteredMeals.filter { $0.preferences == 1 }
                        print("🍗 After non-veg filter (1 only): \(filteredMeals.count) meals")
                    }
                    // "Both" = don't filter, show all (0 and 1)
                }
                
                self.meals = filteredMeals
                print("✅ FINAL RESULT: \(self.meals.count) meals")
                
                if self.meals.isEmpty {
                    print("⚠️ No meals found. Try relaxing filters.")
                } else {
                    print("📋 Meal names:")
                    self.meals.forEach { print("   - \($0.name) (difficulty: \($0.difficulty.rawValue), preference: \($0.preferences))") }
                }
            }
        }
    }
    
    // MARK: - Helper Mappings
    private func mapCategoryToId(_ category: String) -> Int {
        switch category {
        case "Snack": return 1
        case "Drinks": return 2
        case "Appetizer": return 3
        case "Full Meal": return 4
        default: return 4
        }
    }
    
    private func mapDifficultyToInt(_ difficulty: String) -> Int {
        switch difficulty {
        case "Beginner": return 1
        case "Novice": return 2
        case "Intermediate": return 3
        case "Professional": return 4
        default: return 1
        }
    }
    
    private func mapDifficultyEnumToInt(_ difficulty: Meal.Difficulty) -> Int {
        switch difficulty {
        case .easy: return 1
        case .novice: return 2
        case .intermediate: return 3
        case .professional: return 4
        }
    }
}
