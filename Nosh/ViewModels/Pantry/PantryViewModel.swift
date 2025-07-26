//import Foundation
//import Combine
//
//final class PantryViewModel: ObservableObject {
//    private let pantryFileURL: URL
//    private let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    @Published var items: [String: [PantryItem]] = [:] {
//        didSet {
//            updateAllTab(shouldSort: false)
//        }
//    }
//
//    let tabs: [String]
//
//    // MARK: - Init
//    init(tabs: [String]) {
//        self.tabs = tabs
//        self.pantryFileURL = docs.appendingPathComponent("pantry.json")
//
//        if UserDefaults.standard.data(forKey: "pantryItems") != nil {
//            loadPantry()
//        } else {
//            setupDummyItems()
//        }
//    }
//
//    // MARK: - Dummy Data Setup
//    private func setupDummyItems() {
//        for tab in tabs where tab != "All" {
//            items[tab] = dummyItems(for: tab)
//        }
//        updateAllTab(shouldSort: false)
//        savePantry()
//    }
//
//    func dummyItems(for tab: String) -> [PantryItem] {
//        let names: [String]
//        switch tab {
//        case "Vegetables": names = ["Tomato", "Onion", "Potato"]
//        case "Fruits": names = ["Apple", "Banana", "Mango"]
//        case "Dairy": names = ["Milk", "Cheese", "Curd"]
//        case "Spices": names = ["Turmeric", "Chili Powder", "Cumin"]
//        case "Condiments": names = ["Ketchup", "Mayonnaise", "Soy Sauce"]
//        case "Oils": names = ["Sunflower Oil", "Olive Oil"]
//        case "Instant": names = ["Noodles", "Soup Pack", "Instant Coffee"]
//        case "Drinks": names = ["Juice", "Cola", "Water Bottle"]
//        default: names = []
//        }
//
//        return names.map { PantryItem(id: UUID().uuidString, name: $0, quantity: 0) }
//    }
//
//    func increment(_ item: PantryItem, in category: String) {
//        guard var list = items[category],
//              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
//
//        list[index].quantity += 1
//        items[category] = list
//        savePantry()
//    }
//
//    func decrement(_ item: PantryItem, in category: String) {
//        guard var list = items[category],
//              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
//
//        list[index].quantity = max(0, list[index].quantity - 1)
//        items[category] = list
//        savePantry()
//    }
//
//    func findCategory(for item: PantryItem) -> String {
//        for (category, list) in items where category != "All" {
//            if list.contains(where: { $0.id == item.id }) {
//                return category
//            }
//        }
//        return "Unknown"
//    }
//
//    func addCustomItem(to category: String, name: String, quantity: Int = 0) {
//        let newItem = PantryItem(id: UUID().uuidString, name: name, quantity: quantity)
//        items[category, default: []].append(newItem)
//        savePantry()
//    }
//
//    func sortItems(for category: String) {
//        guard var list = items[category] else { return }
//        list = sortedList(list)
//        items[category] = list
//    }
//
//    func sortAllItems() {
//        for tab in tabs where tab != "All" {
//            sortItems(for: tab)
//        }
//        updateAllTab(shouldSort: true)
//    }
//
//    private func updateAllTab(shouldSort: Bool) {
//        let allItems = tabs
//            .filter { $0 != "All" }
//            .flatMap { items[$0] ?? [] }
//
//        if shouldSort {
//            items["All"] = sortedList(allItems)
//        } else {
//            items["All"] = allItems
//        }
//    }
//
//    private func sortedList(_ list: [PantryItem]) -> [PantryItem] {
//        return list.sorted {
//            let r1 = colorRank(for: $0.quantity)
//            let r2 = colorRank(for: $1.quantity)
//            return r1 != r2 ? r1 < r2 : $0.quantity > $1.quantity
//        }
//    }
//
//    private func colorRank(for quantity: Int) -> Int {
//        switch quantity {
//        case 5...: return 0
//        case 1...4: return 1
//        default: return 2
//        }
//    }
//
//    // MARK: - Persistence
//    func savePantry() {
//        do {
//            let data = try JSONEncoder().encode(items)
//            UserDefaults.standard.set(data, forKey: "pantryItems")
//        } catch {
//            print("❌ Failed to save pantry: \(error)")
//        }
//    }
//
//    func loadPantry() {
//        guard let data = UserDefaults.standard.data(forKey: "pantryItems") else { return }
//        do {
//            items = try JSONDecoder().decode([String: [PantryItem]].self, from: data)
//            updateAllTab(shouldSort: false)
//        } catch {
//            print("❌ Failed to load pantry: \(error)")
//        }
//    }
//}


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

    // MARK: - Dummy Data
    private func setupDummyItems() {
        for tab in tabs where tab != "All" {
            items[tab] = dummyItems(for: tab)
        }
        refresh()
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

        return names.map { PantryItem(id: UUID().uuidString, name: $0, quantity: 0) }
    }

    // MARK: - Core Item Ops (No Save/Sort)
    func increment(_ item: PantryItem, in category: String) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
        list[index].quantity += 1
        items[category] = list
    }

    func decrement(_ item: PantryItem, in category: String) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
        list[index].quantity = max(0, list[index].quantity - 1)
        items[category] = list
    }

    func addCustomItem(to category: String, name: String, quantity: Int = 0) {
        let newItem = PantryItem(id: UUID().uuidString, name: name, quantity: quantity)
        items[category, default: []].append(newItem)
    }

    // MARK: - Manual Refresh
    func refresh() {
        for tab in tabs where tab != "All" {
            sortItems(for: tab)
        }
        updateAllTab()
        savePantry()
    }

    // MARK: - Sorting
    private func sortItems(for category: String) {
        guard var list = items[category] else { return }
        list = sortedList(list)
        items[category] = list
    }

    private func updateAllTab() {
        let allItems = tabs
            .filter { $0 != "All" }
            .flatMap { items[$0] ?? [] }
        items["All"] = sortedList(allItems)
    }

    private func sortedList(_ list: [PantryItem]) -> [PantryItem] {
        return list.sorted {
            let r1 = colorRank(for: $0.quantity)
            let r2 = colorRank(for: $1.quantity)
            return r1 != r2 ? r1 < r2 : $0.quantity > $1.quantity
        }
    }

    private func colorRank(for quantity: Int) -> Int {
        switch quantity {
        case 5...: return 0
        case 1...4: return 1
        default: return 2
        }
    }

    // MARK: - Misc
    func findCategory(for item: PantryItem) -> String {
        for (category, list) in items where category != "All" {
            if list.contains(where: { $0.id == item.id }) {
                return category
            }
        }
        return "Unknown"
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
            refresh()
        } catch {
            print("❌ Failed to load pantry: \(error)")
        }
    }
}
