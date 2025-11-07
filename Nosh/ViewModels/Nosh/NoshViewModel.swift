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
        print("🎯 searchMeals() called")
        isLoading = true
        showResults = false
        
        let categoryIds = categories.map { CategoryHelper.nameToId($0) }
        
        db.collection("recipes")
            .whereField("category_id", in: categoryIds)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        print(" XXX Error: \(error.localizedDescription)")
                        self?.meals = []
                        self?.showResults = true
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print(" XXX No documents")
                        self?.meals = []
                        self?.showResults = true
                        return
                    }
                    
                    let allMeals = documents.compactMap { doc -> Meal? in
                        try? doc.data(as: Meal.self)
                    }
                    
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
