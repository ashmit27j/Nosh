import Foundation
import Combine

final class PantryViewModel: ObservableObject {
    private let manager = FileManager.default
    private let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let pantryFileURL: URL
    private var sortTimer: Timer?

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

    // MARK: - Setup Dummy Data
    private func setupDummyItems() {
        for tab in tabs where tab != "All" {
            items[tab] = dummyItems(for: tab)
        }
        updateAllTab()
        savePantry()
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

    // MARK: - Increment/Decrement
    func increment(_ item: PantryItem, in category: String) {
        updateItem(item, in: category, change: +1)
    }

    func decrement(_ item: PantryItem, in category: String) {
        updateItem(item, in: category, change: -1)
    }

    private func updateItem(_ item: PantryItem, in category: String, change: Int) {
        guard var list = items[category], let index = list.firstIndex(of: item) else { return }

        list[index].quantity = max(0, list[index].quantity + change)
        items[category] = list

        updateAllTab()
        savePantry()
        debounceSort(for: category)
    }

    // MARK: - Debounced Sorting
    func debounceSort(for category: String) {
        sortTimer?.invalidate()
        sortTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.sortItems(for: category)
        }
    }

    func sortItems(for category: String) {
        guard var list = items[category] else { return }

        list.sort {
            let rank1 = colorRank(for: $0.quantity)
            let rank2 = colorRank(for: $1.quantity)
            return rank1 != rank2 ? rank1 < rank2 : $0.quantity > $1.quantity
        }

        items[category] = list
        updateAllTab()
    }

    private func colorRank(for quantity: Int) -> Int {
        switch quantity {
        case 5...: return 0 // Green
        case 1...4: return 1 // Yellow
        default: return 2 // Gray
        }
    }

    // MARK: - Add Custom Item
    func addCustomItem(to category: String, name: String, quantity: Int = 0) {
        let newItem = PantryItem(name: name, quantity: quantity)
        items[category, default: []].append(newItem)
        updateAllTab()
        savePantry()
        debounceSort(for: category)
    }

    // MARK: - Utility
    func updateAllTab() {
        let allItems = tabs
            .filter { $0 != "All" }
            .flatMap { items[$0] ?? [] }

        let sortedAll = allItems.sorted {
            let rank1 = colorRank(for: $0.quantity)
            let rank2 = colorRank(for: $1.quantity)
            return rank1 != rank2 ? rank1 < rank2 : $0.quantity > $1.quantity
        }

        items["All"] = sortedAll
    }

    func findCategory(for item: PantryItem) -> String {
        for (category, list) in items where category != "All" {
            if list.contains(where: { $0.id == item.id }) {
                return category
            }
        }
        return "Unknown"
    }

    // MARK: - Save & Load Pantry
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
            updateAllTab()
        } catch {
            print("❌ Failed to load pantry: \(error)")
        }
    }
}
