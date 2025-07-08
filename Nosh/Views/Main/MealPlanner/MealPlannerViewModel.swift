
import Foundation

class MealPlannerViewModel: ObservableObject {
    @Published var tabs: [String] // e.g., ["Mon", "Tue", "Wed"]
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

//         ✅ TEMP: Add sample meals for testing
        let sampleMeal = MealItem(
            name: "Test Pasta",
            imageName: "pastaImage", // <-- ensure this exists in Assets.xcassets
            cookTime: 30,
            servingSize: 2,
            isAvailableInPantry: true
        )

        addMeal(to: tabs.first ?? "Mon", type: "breakfast", meal: sampleMeal)
        addMeal(to: tabs.first ?? "Mon", type: "lunch", meal: sampleMeal)
        addMeal(to: tabs.first ?? "Mon", type: "dinner", meal: sampleMeal)
    }

    func addMeal(to day: String, type: String, meal: MealItem) {
        items[day]?[type]?.append(meal)
    }

    func removeMeal(from day: String, type: String, meal: MealItem) {
        items[day]?[type]?.removeAll { $0.id == meal.id }
    }

    func getAllMeals() -> [MealItem] {
        return items.values.flatMap { $0.values.flatMap { $0 } }
    }

    func generateRandomMeal() -> MealItem? {
        let allMeals = getAllMeals()
        return allMeals.randomElement()
    }
}
