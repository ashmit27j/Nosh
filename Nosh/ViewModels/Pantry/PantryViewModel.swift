import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class PantryViewModel: ObservableObject {
    private let pantryFileURL: URL
    private let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let db = Firestore.firestore()

    @Published var items: [String: [PantryItem]] = [:]

    let tabs: [String]

    init(tabs: [String]) {
        self.tabs = tabs
        self.pantryFileURL = docs.appendingPathComponent("pantry.json")
    }

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

        return names.map { PantryItem(id: UUID(), name: $0, quantity: 0, incrementBy: 0.5) }
    }

    func increment(_ item: PantryItem, in category: String) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
        list[index].quantity += list[index].incrementBy
        items[category] = list
        savePantry()
    }

    func decrement(_ item: PantryItem, in category: String) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
        list[index].quantity = max(0, list[index].quantity - list[index].incrementBy)
        items[category] = list
        savePantry()
    }

    func addItem(name: String, category: String, quantity: Double, incrementBy: Double) {
        let newItem = PantryItem(id: UUID(), name: name, quantity: quantity, incrementBy: incrementBy)
        items[category, default: []].append(newItem)
        refresh()
    }

    func deleteItem(_ item: PantryItem, from category: String) {
        guard var list = items[category] else { return }
        list.removeAll { $0.id == item.id }
        items[category] = list
        refresh()
    }

    func updateItem(_ item: PantryItem, in category: String, name: String, quantity: Double, incrementBy: Double) {
        guard var list = items[category],
              let index = list.firstIndex(where: { $0.id == item.id }) else { return }
        list[index].name = name
        list[index].quantity = quantity
        list[index].incrementBy = incrementBy
        items[category] = list
        refresh()
    }

    func refresh() {
        for tab in tabs where tab != "All" {
            sortItems(for: tab)
        }
        updateAllTab()
        savePantry()
    }

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

    private func colorRank(for quantity: Double) -> Int {
        switch quantity {
        case 5...: return 0
        case 1..<5: return 1
        default: return 2
        }
    }

    func findCategory(for item: PantryItem) -> String {
        for (category, list) in items where category != "All" {
            if list.contains(where: { $0.id == item.id }) {
                return category
            }
        }
        return "Unknown"
    }

    func savePantry() {
        // Local Save
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "pantryItems")
        } catch {
            print("❌ Failed to save pantry: \(error)")
        }
        
        // Firestore Save
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            let jsonData = try JSONEncoder().encode(items)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                db.collection("users").document(userId).collection("pantry").document("items").setData(jsonObject)
            }
        } catch {
            print("❌ Failed to sync to Firestore: \(error)")
        }
    }

    func loadPantry() {
        guard let userId = Auth.auth().currentUser?.uid else {
            if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                loadFromUserDefaults()
            } else {
                setupDummyItems()
            }
            return
        }
        
        db.collection("users").document(userId).collection("pantry").document("items").getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Failed to load from Firestore: \(error)")
                if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                    self.loadFromUserDefaults()
                } else {
                    self.setupDummyItems()
                }
                return
            }
            
            guard let data = snapshot?.data(),
                  !data.isEmpty,
                  let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
                if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                    self.loadFromUserDefaults()
                } else {
                    self.setupDummyItems()
                }
                return
            }
            
            do {
                self.items = try JSONDecoder().decode([String: [PantryItem]].self, from: jsonData)
                self.updateAllTab()
            } catch {
                print("❌ Failed to decode Firestore data: \(error)")
                if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                    self.loadFromUserDefaults()
                } else {
                    self.setupDummyItems()
                }
            }
        }
    }
    
    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "pantryItems") else { return }
        do {
            items = try JSONDecoder().decode([String: [PantryItem]].self, from: data)
            updateAllTab()
        } catch {
            print("❌ Failed to load pantry: \(error)")
        }
    }
}
