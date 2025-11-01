import Foundation

class MealPlannerViewModel: ObservableObject {
    @Published var tabs: [String] // e.g., ["Mon", "Tue", "Wed"]
    @Published var items: [String: [String: [Meal]]] = [:] // Changed to Meal

    init(tabs: [String]) {
        self.tabs = tabs
        for tab in tabs {
            items[tab] = [
                "breakfast": [],
                "lunch": [],
                "dinner": []
            ]
        }

        let sampleMeal = Meal(
            name: "Test Pasta",
            imageName: "pastaImage", // <-- ensure this exists in Assets.xcassets
            timeToCook: 30, // Changed from cookTime
            servingSize: 2,
            difficulty: .easy, // Added required parameter
            isAvailableInPantry: true
        )

//        addMeal(to: tabs.first ?? "Mon", type: "breakfast", meal: sampleMeal)
//        addMeal(to: tabs.first ?? "Mon", type: "lunch", meal: sampleMeal)
//        addMeal(to: tabs.first ?? "Mon", type: "dinner", meal: sampleMeal)
    }

    func addMeal(to day: String, type: String, meal: Meal) { // Changed to Meal
        items[day]?[type]?.append(meal)
    }

    func removeMeal(from day: String, type: String, meal: Meal) { // Changed to Meal
        items[day]?[type]?.removeAll { $0.id == meal.id }
    }

    func getAllMeals() -> [Meal] { // Changed to Meal
        return items.values.flatMap { $0.values.flatMap { $0 } }
    }

    func generateRandomMeal() -> Meal { // Changed to Meal (non-optional)
        // Generate a random meal instead of picking from existing meals
        let names = ["Pancakes", "Creamy Pasta", "Margherita Pizza", "Caesar Salad", "Tomato Soup", "Club Sandwich", "Veggie Wrap", "Chicken Biryani", "Tacos", "Ramen"]
        let images = ["pastaImage", "frankieImage"] // Add more image names as you create them
        let difficulties: [Meal.Difficulty] = [.easy, .novice, .intermediate, .professional]
        
        return Meal(
            name: names.randomElement() ?? "Mystery Dish",
            imageName: images.randomElement() ?? "frankieImage",
            timeToCook: Int.random(in: 15...90),
            servingSize: Int.random(in: 1...6),
            difficulty: difficulties.randomElement() ?? .easy,
            isAvailableInPantry: Bool.random()
        )
    }
}
