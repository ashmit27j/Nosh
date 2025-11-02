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

    // MARK: - Initialization
    
    func initializeDefaultPantry() {
        guard let userId = Auth.auth().currentUser?.uid else {
            // No user - load from local or dummy
            if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                loadFromUserDefaults()
            } else {
                setupDummyItems()
            }
            return
        }
        
        // Check if already initialized
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let data = snapshot?.data(), data["pantryInitialized"] as? Bool == true {
                print("✅ Pantry already initialized")
                self.loadPantry()
                return
            }
            
            print("🔄 Initializing default pantry for new user...")
            
            // Get default items
            let defaultItems = self.getDefaultPantryItems()
            
            // Populate items dictionary
            for (category, itemList) in defaultItems {
                self.items[category] = itemList
            }
            
            self.updateAllTab()
            self.savePantry()
            
            // Mark as initialized
            self.db.collection("users").document(userId).setData([
                "pantryInitialized": true
            ], merge: true) { error in
                if let error = error {
                    print("❌ Error marking pantry initialized: \(error)")
                } else {
                    print("✅ Pantry initialized with default items")
                }
            }
        }
    }
    
    private func getDefaultPantryItems() -> [String: [PantryItem]] {
        var items: [String: [PantryItem]] = [:]
        
        // Grains & Flours
        items["Grains & Flours"] = [
            PantryItem(id: UUID(), name: "All-purpose flour", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Wheat flour", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Rice", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Popcorn kernels", quantity: 0, incrementBy: 50)
        ]
        
        // Baking
        items["Baking"] = [
            PantryItem(id: UUID(), name: "Baking powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Baking soda", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Cocoa powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Vanilla extract", quantity: 0, incrementBy: 1)
        ]
        
        // Dairy
        items["Dairy"] = [
            PantryItem(id: UUID(), name: "Butter", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Milk", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Full cream milk", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Cream", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Whipped cream", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Yogurt", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Paneer", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Shredded cheese", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Sour cream", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Milk powder", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Eggs", quantity: 0, incrementBy: 1)
        ]
        
        // Vegetables
        items["Vegetables"] = [
            PantryItem(id: UUID(), name: "Onions", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Tomatoes", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Potatoes", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Bell peppers", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Cherry tomatoes", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Green peas", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Spinach", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Zucchini", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Jalapeños", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Mixed vegetables", quantity: 0, incrementBy: 100)
        ]
        
        // Proteins
        items["Proteins"] = [
            PantryItem(id: UUID(), name: "Chicken", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Chicken breast", quantity: 0, incrementBy: 100)
        ]
        
        // Spices
        items["Spices"] = [
            PantryItem(id: UUID(), name: "Salt", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Black pepper", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Red chili powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Cumin powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Cumin seeds", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Garam masala", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Biryani masala", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Chaat masala", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Cardamom powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Paprika", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Garlic powder", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Kasuri methi", quantity: 0, incrementBy: 1)
        ]
        
        // Oils
        items["Oils"] = [
            PantryItem(id: UUID(), name: "Oil", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Olive oil", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Ghee", quantity: 0, incrementBy: 50)
        ]
        
        // Aromatics
        items["Aromatics"] = [
            PantryItem(id: UUID(), name: "Garlic cloves", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Ginger-garlic paste", quantity: 0, incrementBy: 1)
        ]
        
        // Herbs
        items["Herbs"] = [
            PantryItem(id: UUID(), name: "Fresh mint leaves", quantity: 0, incrementBy: 10),
            PantryItem(id: UUID(), name: "Mint leaves", quantity: 0, incrementBy: 10),
            PantryItem(id: UUID(), name: "Parsley", quantity: 0, incrementBy: 10)
        ]
        
        // Sweeteners
        items["Sweeteners"] = [
            PantryItem(id: UUID(), name: "Sugar", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Honey", quantity: 0, incrementBy: 10)
        ]
        
        // Condiments
        items["Condiments"] = [
            PantryItem(id: UUID(), name: "Tomato puree", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Salsa", quantity: 0, incrementBy: 50)
        ]
        
        // Beverages
        items["Beverages"] = [
            PantryItem(id: UUID(), name: "Coffee", quantity: 0, incrementBy: 10),
            PantryItem(id: UUID(), name: "Water", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Hot water", quantity: 0, incrementBy: 100),
            PantryItem(id: UUID(), name: "Soda water", quantity: 0, incrementBy: 100)
        ]
        
        // Fruits
        items["Fruits"] = [
            PantryItem(id: UUID(), name: "Lime", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Lime slices", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Lemon juice", quantity: 0, incrementBy: 10),
            PantryItem(id: UUID(), name: "Fresh mangoes", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Watermelon", quantity: 0, incrementBy: 100)
        ]
        
        // Specialty
        items["Specialty"] = [
            PantryItem(id: UUID(), name: "Saffron", quantity: 0, incrementBy: 0.1),
            PantryItem(id: UUID(), name: "Rose water", quantity: 0, incrementBy: 10),
            PantryItem(id: UUID(), name: "Dark chocolate", quantity: 0, incrementBy: 50)
        ]
        
        // Snacks
        items["Snacks"] = [
            PantryItem(id: UUID(), name: "Bread loaf", quantity: 0, incrementBy: 1),
            PantryItem(id: UUID(), name: "Tortilla chips", quantity: 0, incrementBy: 50),
            PantryItem(id: UUID(), name: "Black olives", quantity: 0, incrementBy: 10)
        ]
        
        // Others
        items["Others"] = [
            PantryItem(id: UUID(), name: "Ice cubes", quantity: 0, incrementBy: 10)
        ]
        
        return items
    }

    // MARK: - CRUD Operations
    
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

    // MARK: - Refresh & Sorting
    
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

    // MARK: - Save & Load
    
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
            // No user - load from local
            if UserDefaults.standard.data(forKey: "pantryItems") != nil {
                loadFromUserDefaults()
            } else {
                setupDummyItems()
            }
            return
        }
        
        // User logged in - load from Firestore
        db.collection("users").document(userId).collection("pantry").document("items").getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Failed to load from Firestore: \(error)")
                return
            }
            
            guard let data = snapshot?.data(),
                  !data.isEmpty,
                  let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
                print("⚠️ No pantry data in Firestore")
                return
            }
            
            do {
                self.items = try JSONDecoder().decode([String: [PantryItem]].self, from: jsonData)
                self.updateAllTab()
                
                // Also update UserDefaults
                self.savePantry()
            } catch {
                print("❌ Failed to decode Firestore data: \(error)")
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
    
    func clearPantry() {
        items = [:]
        UserDefaults.standard.removeObject(forKey: "pantryItems")
        print("🗑️ Pantry cleared")
    }

    // MARK: - Dummy Data (Fallback)
    
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
        default: names = []
        }

        return names.map { PantryItem(id: UUID(), name: $0, quantity: 0, incrementBy: 0.5) }
    }
}
