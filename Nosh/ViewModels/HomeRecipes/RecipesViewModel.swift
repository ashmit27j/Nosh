import SwiftUI
import FirebaseFirestore

class RecipesViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    
    func fetchMeals(categories: [String]) {
        let categoryIds = Array(Set(categories.map { CategoryHelper.nameToId($0) }))
        guard !categoryIds.isEmpty else {
            meals = []
            isLoading = false
            return
        }

        isLoading = true

        let db = Firestore.firestore()
        
        db.collection("recipes")
            .whereField("category_id", in: categoryIds)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        Log.recipes.error("Failed to fetch meals: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        Log.recipes.error("Recipe query returned no documents")
                        self?.meals = []
                        return
                    }
                    
                    
                    // Meal(document:) stamps the document ID as the recipe's
                    // identity; data(as:) alone leaves it empty.
                    self?.meals = documents.compactMap { Meal(document: $0) }
                }
            }
    }
}
