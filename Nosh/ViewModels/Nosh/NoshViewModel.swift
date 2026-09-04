import SwiftUI
import FirebaseFirestore

class NoshViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    @Published var showResults = false
    
    private let db = Firestore.firestore()
    
    func searchMeals(
        categories: [String],
        portionSize: Int,
        maxTime: Int,
        difficulty: Meal.Difficulty,
        foodPreference: String
    ) {
        // Firestore raises FIRInvalidArgumentException for an empty `in` array,
        // which is an ObjC exception and terminates the app rather than surfacing
        // as a Swift error. Deselecting the only category chip gets us here.
        let categoryIds = Array(Set(categories.map { CategoryHelper.nameToId($0) }))
        guard !categoryIds.isEmpty else {
            meals = []
            isLoading = false
            showResults = true
            return
        }

        isLoading = true
        showResults = false

        db.collection("recipes")
            .whereField("category_id", in: categoryIds)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        Log.recipes.error("Recipe search failed: \(error.localizedDescription)")
                        self?.meals = []
                        self?.showResults = true
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        Log.recipes.error("Recipe search returned no documents")
                        self?.meals = []
                        self?.showResults = true
                        return
                    }
                    
                    let allMeals = documents.compactMap { Meal(document: $0) }
                    
                    let filtered = allMeals.filter { meal in
                        let meetsTime = meal.timeInMinutes <= maxTime
                        
                        let meetsDifficulty: Bool
                        switch difficulty {
                        case .easy: meetsDifficulty = meal.difficulty == .easy
                        case .novice: meetsDifficulty = meal.difficulty == .easy || meal.difficulty == .novice
                        case .intermediate: meetsDifficulty = meal.difficulty == .easy || meal.difficulty == .novice || meal.difficulty == .intermediate
                        case .professional: meetsDifficulty = true
                        }
                        
                        let meetsPreference: Bool
                        switch foodPreference {
                        case "Vegetarian": meetsPreference = meal.preferences == 0
                        case "Non-Vegetarian": meetsPreference = meal.preferences == 1
                        case "Both": meetsPreference = true
                        default: meetsPreference = true
                        }
                        
                        let meetsPortion = meal.servingSize >= portionSize
                        
                        return meetsTime && meetsDifficulty && meetsPreference && meetsPortion
                    }
                    self?.meals = filtered
                    self?.showResults = true
                }
            }
    }
}
