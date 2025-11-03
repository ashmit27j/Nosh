import SwiftUI
import FirebaseFirestore

class NoshViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func searchMeals(
        categories: [String]?,
        portionSize: Int,
        maxTimeToCook: Int,
        difficulty: String?,
        foodPreference: String?
    ) {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Starting search with:")
        print("   Categories: \(categories ?? [])")
        print("   Portion Size: \(portionSize)")
        print("   Max Time: \(maxTimeToCook)")
        print("   Difficulty: \(difficulty ?? "nil")")
        print("   Food Preference: \(foodPreference ?? "nil")")
        
        let db = Firestore.firestore()
        
        db.collection("recipes").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch meals: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("❌ No documents found")
                    self.meals = []
                    return
                }
                
                print("📦 Got \(documents.count) total documents")
                
                // Parse all meals
                let allMeals = documents.compactMap { doc -> Meal? in
                    try? doc.data(as: Meal.self)
                }
                
                print("✅ Parsed \(allMeals.count) meals")
                
                var filteredMeals = allMeals
                
                // Filter by time
                filteredMeals = filteredMeals.filter { meal in
                    let timeInMinutes = self.parseTime(meal.timeToCook)
                    return timeInMinutes <= maxTimeToCook
                }
                print("⏱️ After time filter (0-\(maxTimeToCook)): \(filteredMeals.count) meals")
                
                // Filter by categories (using categoryId)
                if let categories = categories, !categories.isEmpty {
                    let categoryIds = categories.map { CategoryHelper.nameToId($0) }
                    print("📁 Filtering by category IDs: \(categoryIds) (from \(categories))")
                    filteredMeals = filteredMeals.filter { meal in
                        categoryIds.contains(meal.categoryId)
                    }
                    print("📁 After category filter: \(filteredMeals.count) meals")
                }
                
                // Filter by serving size
                filteredMeals = filteredMeals.filter { $0.servingSize >= portionSize }
                print("🍽️ After serving size filter (>= \(portionSize)): \(filteredMeals.count) meals")
                
                // Filter by difficulty
                if let difficultyStr = difficulty {
                    let maxDifficultyLevel = self.difficultyLevel(for: difficultyStr)
                    filteredMeals = filteredMeals.filter { meal in
                        self.difficultyLevel(for: meal.difficulty.rawValue) <= maxDifficultyLevel
                    }
                    print("🎯 After difficulty filter (<= \(difficultyStr)): \(filteredMeals.count) meals")
                }
                
                // Filter by food preference
                if let preference = foodPreference, preference != "Both" {
                    let preferenceValue = preference == "Vegetarian" ? 0 : 1
                    filteredMeals = filteredMeals.filter { $0.preferences == preferenceValue }
                    print("🥗 After food preference filter (\(preference)): \(filteredMeals.count) meals")
                }
                
                self.meals = filteredMeals
                
                print("✅ FINAL RESULT: \(self.meals.count) meals")
                print("📋 Meal names:")
                for meal in self.meals {
                    print("   - \(meal.name) (categoryId: \(meal.categoryId), difficulty: \(meal.difficulty.rawValue), preferences: \(meal.preferences))")
                }
            }
        }
    }
    
    private func parseTime(_ timeString: String) -> Int {
        let components = timeString.lowercased().components(separatedBy: CharacterSet.decimalDigits.inverted)
        let numbers = components.compactMap { Int($0) }
        
        if timeString.contains("hour") || timeString.contains("hr") {
            let hours = numbers.first ?? 0
            let minutes = numbers.count > 1 ? numbers[1] : 0
            return hours * 60 + minutes
        } else {
            return numbers.first ?? 0
        }
    }
    
    private func difficultyLevel(for difficulty: String) -> Int {
        switch difficulty {
        case "Easy": return 1
        case "Novice": return 2
        case "Intermediate": return 3
        case "Professional": return 4
        default: return 0
        }
    }
}
