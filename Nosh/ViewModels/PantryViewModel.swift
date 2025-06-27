import Foundation

class PantryViewModel: ObservableObject {
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
        case "Vegetables": return ["Tomato", "Onion", "Potato"].map { PantryItem(name: $0, quantity: 0) }
        case "Fruits": return ["Apple", "Banana", "Mango"].map { PantryItem(name: $0, quantity: 0) }
        case "Dairy": return ["Milk", "Cheese", "Curd"].map { PantryItem(name: $0, quantity: 0) }
        case "Spices": return ["Turmeric", "Chili Powder", "Cumin"].map { PantryItem(name: $0, quantity: 0) }
        case "Condiments": return ["Ketchup", "Mayonnaise", "Soy Sauce"].map { PantryItem(name: $0, quantity: 0) }
        case "Oils": return ["Sunflower Oil", "Olive Oil"].map { PantryItem(name: $0, quantity: 0) }
        case "Instant": return ["Noodles", "Soup Pack", "Instant Coffee"].map { PantryItem(name: $0, quantity: 0) }
        case "Drinks": return ["Juice", "Cola", "Water Bottle"].map { PantryItem(name: $0, quantity: 0) }
        default: return []
        }
    }

    func increment(_ item: PantryItem, in category: String) {
        guard var list = items[category], let index = list.firstIndex(of: item) else { return }
        list[index].quantity += 1
        items[category] = list
    }

    func decrement(_ item: PantryItem, in category: String) {
        guard var list = items[category], let index = list.firstIndex(of: item), list[index].quantity > 0 else { return }
        list[index].quantity -= 1
        items[category] = list
    }

    func addCustomItem(to category: String) {
        let newItem = PantryItem(name: "Custom Item", quantity: 0)
        items[category, default: []].append(newItem)
    }

    func findCategory(for item: PantryItem) -> String {
        for (category, items) in self.items {
            if items.contains(item) {
                return category
            }
        }
        return "Vegetables"
    }
}
