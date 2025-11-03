import SwiftUI
import FirebaseFirestore

class RecipesViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    
    func fetchMeals(categories: [String]) {
        isLoading = true
        
        let categoryIds = categories.map { CategoryHelper.nameToId($0) }
        
        print("🔍 Fetching meals for categories: \(categories) (IDs: \(categoryIds))")
        
        let db = Firestore.firestore()
        
        db.collection("recipes")
            .whereField("category_id", in: categoryIds)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        print("❌ Error fetching meals: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("⚠️ No documents returned")
                        self?.meals = []
                        return
                    }
                    
                    print("📦 Got \(documents.count) documents")
                    
                    self?.meals = documents.compactMap { doc in
                        do {
                            let meal = try doc.data(as: Meal.self)
                            print("   ✓ \(meal.name) (categoryId: \(meal.categoryId))")
                            return meal
                        } catch {
                            print("   ✗ Failed to parse \(doc.documentID): \(error)")
                            return nil
                        }
                    }
                    
                    print("✅ Final count: \(self?.meals.count ?? 0) meals")
                }
            }
    }
}
