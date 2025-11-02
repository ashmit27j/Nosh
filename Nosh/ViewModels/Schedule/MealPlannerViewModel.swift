import Foundation
import FirebaseFirestore

class MealPlannerViewModel: ObservableObject {
    @Published var tabs: [String]
    @Published var items: [String: [String: [Meal]]] = [:]
    
    private let db = Firestore.firestore()

    init(tabs: [String]) {
        self.tabs = tabs
        for tab in tabs {
            items[tab] = [
                "breakfast": [],
                "lunch": [],
                "dinner": []
            ]
        }
    }

    func addMeal(to day: String, type: String, meal: Meal) {
        items[day]?[type]?.append(meal)
    }

    func removeMeal(from day: String, type: String, meal: Meal) {
        items[day]?[type]?.removeAll { $0.id == meal.id }
    }

    func getAllMeals() -> [Meal] {
        return items.values.flatMap { $0.values.flatMap { $0 } }
    }

    func fetchRandomMeal(completion: @escaping (Meal?) -> Void) {
        db.collection("recipes")  // Changed from "meals" to "recipes"
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching meals: \(error)")
                    completion(nil)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("⚠️ No meals found in database")
                    completion(nil)
                    return
                }
                
                // Pick random document
                let randomDoc = documents.randomElement()
                guard let doc = randomDoc else {
                    completion(nil)
                    return
                }
                
                do {
                    let meal = try doc.data(as: Meal.self)
                    completion(meal)
                } catch {
                    print("❌ Error decoding meal: \(error)")
                    completion(nil)
                }
            }
    }

}
