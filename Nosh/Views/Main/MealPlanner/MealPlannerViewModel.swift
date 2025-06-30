import Foundation

class MealPlannerViewModel: ObservableObject {
    @Published var items: [String: [PantryItem]] = [:]

    let tabs: [String]

    init(tabs: [String]) {
        self.tabs = tabs
        setupDummyItems()
    }

    private func setupDummyItems() {
        for tab in tabs where tab != "All" {
            items[tab] = dummyItems(for: tab)
        }
        items["All"] = tabs
            .filter { $0 != "All" }
            .flatMap { items[$0] ?? [] }
    }

    func dummyItems(for tab: String) -> [PantryItem] {
        switch tab {
        case "Mon": return ["Poha", "Dal Rice", "Sandwich"].map { PantryItem(name: $0, quantity: 0) }
        case "Tue": return ["Paratha", "Kadhi Chawal", "Salad"].map { PantryItem(name: $0, quantity: 0) }
        case "Wed": return ["Upma", "Chole Rice", "Wrap"].map { PantryItem(name: $0, quantity: 0) }
        case "Thu": return ["Idli", "Rajma Chawal", "Burger"].map { PantryItem(name: $0, quantity: 0) }
        case "Fri": return ["Dosa", "Fried Rice", "Burrito"].map { PantryItem(name: $0, quantity: 0) }
        case "Sat": return ["Pancake", "Veg Biryani", "Pizza"].map { PantryItem(name: $0, quantity: 0) }
        case "Sun": return ["Toast", "Paneer Pulao", "Pasta"].map { PantryItem(name: $0, quantity: 0) }
        default: return []
        }
    }


    func addCustomItem(to category: String) {
        let newItem = PantryItem(name: "Custom Meal", quantity: 0)
        items[category, default: []].append(newItem)
    }

    func findCategory(for item: PantryItem) -> String {
        for (category, items) in self.items {
            if items.contains(item) {
                return category
            }
        }
        return "Mon"
    }
}
