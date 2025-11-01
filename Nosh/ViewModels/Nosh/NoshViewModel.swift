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
        foodPreference: String? // "Veg", "Non-Veg", or "Both"
    ) {
        isLoading = true
        errorMessage = nil
        
        var query: Query = db.collection("recipes")
        
        // Filter by category
        if let category = category, !category.isEmpty {
            let categoryId = mapCategoryToId(category)
            query = query.whereField("category_id", isEqualTo: categoryId)
        }
        
        // Filter by time to cook (less than or equal to selected time)
        query = query.whereField("time_to_cook", isLessThanOrEqualTo: maxTimeToCook)
        
        // Filter by serving size (greater than or equal to portion size)
        query = query.whereField("serving_size", isGreaterThanOrEqualTo: portionSize)
        
        // Filter by difficulty
        if let difficulty = difficulty, !difficulty.isEmpty {
            let difficultyInt = mapDifficultyToInt(difficulty)
            query = query.whereField("difficulty", isEqualTo: difficultyInt)
        }
        
        // Filter by food preference
        if let preference = foodPreference, preference != "Both" {
            let preferenceInt = mapPreferenceToInt(preference)
            query = query.whereField("preferences", isEqualTo: preferenceInt)
        }
        
        // Execute query
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error fetching meals: \(error.localizedDescription)"
                    print("❌ Firestore error: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.meals = []
                    return
                }
                
                self.meals = documents.compactMap { doc -> Meal? in
                    return Meal(from: doc.data())
                }
                
                print("✅ Found \(self.meals.count) meals matching criteria")
            }
        }
    }
    
    // MARK: - Helper Mappings
    private func mapCategoryToId(_ category: String) -> Int {
        switch category {
        case "Snack": return 1
        case "Drinks": return 2
        case "Appetizer": return 5
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
    
    private func mapPreferenceToInt(_ preference: String) -> Int {
        switch preference {
        case "Veg": return 1
        case "Non-Veg": return 2
        case "Both": return 0
        default: return 0
        }
    }
}
