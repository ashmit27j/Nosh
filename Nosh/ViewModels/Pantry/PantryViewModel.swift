import Foundation
import Combine

final class PantryViewModel: ObservableObject {
    private let pantryFileURL: URL
    
    private let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    @Published var items: [String: [PantryItem]] = [:]
    let tabs: [String]

    // MARK: - Init
    init(tabs: [String]) {
        self.tabs = tabs
        self.pantryFileURL = docs.appendingPathComponent("pantry.json")

        if UserDefaults.standard.data(forKey: "pantryItems") != nil {
            loadPantry()
        } else {
            setupDummyItems()
        }
    }

    // MARK: - Dummy Data Setup
    private func setupDummyItems() {
        for tab in tabs where tab != "All" {
            items[tab] = dummyItems(for: tab)
        }
        updateAllTab(shouldSort: false)
        savePantry()
    }

    func dummyItems(for tab: String) -> [PantryItem] {
        let names: [String]
        switch tab {
        case "Vegetables": names = ["Tomato", "Onion", "Potato"]
        case "Fruits": names = ["Apple", "Banana", "Mango"]
        case "Dairy": names = ["Milk", "Cheese", "Curd"]
        case "Spices": names = ["Turmeric", "Chili Powder", "Cumin"]
        case "Condiments": names = ["Ketchup", "Mayonnaise", "Soy Sauce"]
        case "Oils": names = ["Sunflower Oil", "Olive Oil"]
        case "Instant": names = ["Noodles", "Soup Pack", "Instant Coffee"]
        case "Drinks": names = ["Juice", "Cola", "Water Bottle"]
        default: names = []
        }

        return names.map { PantryItem(id: UUID().uuidString, name: $0, category: tab, quantity: 0) }


    }

    func increment(_ item: PantryItem, in category: String) {
        updateQuantity(of: item, in: category, by: 1)
    }

    func decrement(_ item: PantryItem, in category: String) {
        updateQuantity(of: item, in: category, by: -1)
    }
    
    private func updateQuantity(of item: PantryItem, in category: String, by amount: Int) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }

        // Create a mutable copy of the item
        var updatedItem = list[index]
        updatedItem.quantity = max(0, updatedItem.quantity + amount)

        // Update the list
        list[index] = updatedItem
        items[category] = list  // <- triggers SwiftUI update

        // Also update the "All" tab to reflect this change
        updateAllTab(shouldSort: false)
        savePantry()
    }



    private func updateItem(_ item: PantryItem, in category: String, change: Int) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }

        list[index].quantity = max(0, list[index].quantity + change)
        items[category] = list

        // Don't call updateAllTab here
        savePantry()
    }

    // MARK: - Manual Sorting (called on Refresh Button)
    func sortItems(for category: String) {
        guard var list = items[category] else { return }

        list.sort {
            let rank1 = colorRank(for: $0.quantity)
            let rank2 = colorRank(for: $1.quantity)
            return rank1 != rank2 ? rank1 < rank2 : $0.quantity > $1.quantity
        }

        items[category] = list
    }

    func sortAllItems() {
        for tab in tabs where tab != "All" {
            sortItems(for: tab)
        }
        updateAllTab(shouldSort: true)
    }

    private func colorRank(for quantity: Int) -> Int {
        switch quantity {
        case 5...: return 0
        case 1...4: return 1
        default: return 2
        }
    }

    // MARK: - All Tab Logic
    func updateAllTab(shouldSort: Bool) {
        let allItems = tabs
            .filter { $0 != "All" }
            .flatMap { items[$0] ?? [] }

        if shouldSort {
            let sorted = allItems.sorted {
                let r1 = colorRank(for: $0.quantity)
                let r2 = colorRank(for: $1.quantity)
                return r1 != r2 ? r1 < r2 : $0.quantity > $1.quantity
            }
            items["All"] = sorted
        } else {
            items["All"] = allItems
        }
    }

    // MARK: - Category Helper
    func findCategory(for item: PantryItem) -> String {
        for (category, list) in items where category != "All" {
            if list.contains(where: { $0.id == item.id }) {
                return category
            }
        }
        return "Unknown"
    }

    // MARK: - Add Item
    func addCustomItem(to category: String, name: String, quantity: Int = 0) {
        let newItem = PantryItem(id: UUID().uuidString, name: name, category: category, quantity: quantity)
        items[category, default: []].append(newItem)
        updateAllTab(shouldSort: category == "All")
        savePantry()
    }

    // MARK: - Persistence
    func savePantry() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "pantryItems")
        } catch {
            print("❌ Failed to save pantry: \(error)")
        }
    }

    func loadPantry() {
        guard let data = UserDefaults.standard.data(forKey: "pantryItems") else { return }
        do {
            items = try JSONDecoder().decode([String: [PantryItem]].self, from: data)
            updateAllTab(shouldSort: false)
        } catch {
            print("❌ Failed to load pantry: \(error)")
        }
    }
    private func sortedList(_ list: [PantryItem]) -> [PantryItem] {
        return list.sorted {
            let r1 = colorRank(for: $0.quantity)
            let r2 = colorRank(for: $1.quantity)
            return r1 != r2 ? r1 < r2 : $0.quantity > $1.quantity
        }
    }

}
