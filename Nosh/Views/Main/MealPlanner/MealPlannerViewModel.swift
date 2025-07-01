import Foundation
class MealPlannerViewModel: ObservableObject {
    @Published var tabs: [String] // e.g., ["Mon", "Tue", "Wed"]
    
    // Structure: [Day: [MealType: [MealItem]]]
    @Published var items: [String: [String: [MealItem]]] = [:]

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

    func addMeal(to day: String, type: String, meal: MealItem) {
        items[day]?[type]?.append(meal)
    }

    func removeMeal(from day: String, type: String, meal: MealItem) {
        items[day]?[type]?.removeAll { $0.id == meal.id }
    }
}
