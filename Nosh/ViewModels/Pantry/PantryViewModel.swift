import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class PantryViewModel: ObservableObject {

    /// Name of the synthetic tab that shows every category at once.
    static let allTab = "All"

    /// Real categories only. "All" is never stored here — it is derived by
    /// `items(for:)`. Storing it meant quantity changes made from the All tab
    /// didn't show up until a full refresh, and that every item was persisted
    /// twice.
    @Published private(set) var items: [String: [PantryItem]] = [:]

    let tabs: [String]

    private let db = Firestore.firestore()
    private var saveTask: Task<Void, Never>?

    /// Categories excluding the synthetic "All" tab.
    private var categories: [String] { tabs.filter { $0 != Self.allTab } }

    init(tabs: [String]) {
        self.tabs = tabs
    }

    deinit {
        saveTask?.cancel()
    }

    // MARK: - Reading

    /// Items for a tab. "All" is flattened on demand from the real categories.
    func items(for tab: String) -> [PantryItem] {
        guard tab != Self.allTab else {
            return sortedList(categories.flatMap { items[$0] ?? [] })
        }
        return items[tab] ?? []
    }

    var allItems: [PantryItem] { items(for: Self.allTab) }

    func findCategory(for item: PantryItem) -> String? {
        categories.first { items[$0]?.contains(where: { $0.id == item.id }) == true }
    }

    // MARK: - Initialization

    /// Loads the pantry, seeding defaults the first time a user signs in.
    func initializeDefaultPantry() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            loadFromUserDefaults()
            return
        }

        do {
            let document = try await db.collection("users").document(userId).getDocument()

            if document.data()?["pantryInitialized"] as? Bool == true {
                await loadPantry()
                return
            }

            items = Self.defaultPantryItems()
            savePantry()

            try await db.collection("users").document(userId)
                .setData(["pantryInitialized": true], merge: true)
        } catch {
            // Offline or rules failure — fall back to whatever is cached locally.
            loadFromUserDefaults()
        }
    }

    // MARK: - CRUD

    func increment(_ item: PantryItem, in category: String) {
        adjust(item, in: category) { $0.quantity += $0.incrementBy }
    }

    func decrement(_ item: PantryItem, in category: String) {
        adjust(item, in: category) { $0.quantity = max(0, $0.quantity - $0.incrementBy) }
    }

    func updateQuantity(for item: PantryItem, in category: String, to newQuantity: Double) {
        adjust(item, in: category) { $0.quantity = max(0, newQuantity) }
    }

    func addItem(name: String, category: String, quantity: Double, incrementBy: Double) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        items[category, default: []].append(
            PantryItem(id: UUID(), name: trimmed, quantity: quantity, incrementBy: incrementBy)
        )
        savePantry()
    }

    func deleteItem(_ item: PantryItem, from category: String) {
        items[category]?.removeAll { $0.id == item.id }
        savePantry()
    }

    func updateItem(
        _ item: PantryItem,
        in category: String,
        name: String,
        quantity: Double,
        incrementBy: Double
    ) {
        adjust(item, in: category) {
            $0.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            $0.quantity = max(0, quantity)
            $0.incrementBy = incrementBy
        }
    }

    /// Adds `amount` to an item found by ID, wherever it lives.
    func incrementPantryItem(id: UUID, by amount: Double) {
        for category in categories {
            guard let index = items[category]?.firstIndex(where: { $0.id == id }) else { continue }
            items[category]?[index].quantity = max(0, items[category]![index].quantity + amount)
            savePantry()
            return
        }
    }

    /// Applies a mutation in whichever category actually holds the item.
    ///
    /// The passed-in category is a hint: when the user is on the All tab the
    /// caller can't know it, so fall back to a lookup rather than dropping the edit.
    private func adjust(
        _ item: PantryItem,
        in category: String,
        _ mutate: (inout PantryItem) -> Void
    ) {
        let resolved = (category != Self.allTab && items[category] != nil)
            ? category
            : findCategory(for: item)

        guard let resolved,
              let index = items[resolved]?.firstIndex(where: { $0.id == item.id })
        else { return }

        mutate(&items[resolved]![index])
        savePantry()
    }

    // MARK: - Sorting

    /// Re-sorts every category. Only invoked from the refresh button — sorting on
    /// every edit reorders the list under the user's finger mid-tap.
    func refresh() {
        for category in categories {
            items[category] = sortedList(items[category] ?? [])
        }
        savePantry()
    }

    private func sortedList(_ list: [PantryItem]) -> [PantryItem] {
        list.sorted {
            let r1 = stockRank(for: $0.quantity)
            let r2 = stockRank(for: $1.quantity)
            return r1 != r2 ? r1 < r2 : $0.quantity > $1.quantity
        }
    }

    private func stockRank(for quantity: Double) -> Int {
        switch quantity {
        case 5...:   return 0
        case 1..<5:  return 1
        default:     return 2
        }
    }

    // MARK: - Persistence

    /// Writes locally at once and coalesces the Firestore sync.
    ///
    /// Every +/- tap used to push the entire pantry to Firestore immediately;
    /// holding the button issued one full-document write per tap.
    func savePantry() {
        persistLocally()

        saveTask?.cancel()
        saveTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            guard !Task.isCancelled else { return }
            await self?.syncToFirestore()
        }
    }

    private func persistLocally() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "pantryItems")
        } catch {
            assertionFailure("Failed to encode pantry: \(error)")
        }
    }

    private func syncToFirestore() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            let data = try JSONEncoder().encode(items)
            guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return
            }
            try await db.collection("users").document(userId)
                .collection("pantry").document("items").setData(object)
        } catch {
            // Local copy is already saved; the next edit retries the sync.
        }
    }

    func loadPantry() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            loadFromUserDefaults()
            return
        }

        do {
            let document = try await db.collection("users").document(userId)
                .collection("pantry").document("items").getDocument()

            guard let data = document.data(), !data.isEmpty else {
                loadFromUserDefaults()
                return
            }

            let jsonData = try JSONSerialization.data(withJSONObject: data)
            var decoded = try JSONDecoder().decode([String: [PantryItem]].self, from: jsonData)

            // Drop the stale "All" bucket written by older builds.
            decoded.removeValue(forKey: Self.allTab)
            items = decoded

            // Local cache only — no need to echo straight back to Firestore.
            persistLocally()
        } catch {
            loadFromUserDefaults()
        }
    }

    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "pantryItems") else {
            if items.isEmpty { items = Self.defaultPantryItems() }
            return
        }
        do {
            var decoded = try JSONDecoder().decode([String: [PantryItem]].self, from: data)
            decoded.removeValue(forKey: Self.allTab)
            items = decoded
        } catch {
            items = Self.defaultPantryItems()
        }
    }

    /// Clears in-memory and cached state. Called on sign-out so the next user
    /// doesn't inherit the previous one's pantry.
    func clearPantry() {
        saveTask?.cancel()
        items = [:]
        UserDefaults.standard.removeObject(forKey: "pantryItems")
    }

    // MARK: - Defaults

    private static func defaultPantryItems() -> [String: [PantryItem]] {
        func make(_ entries: [(String, Double)]) -> [PantryItem] {
            entries.map { PantryItem(id: UUID(), name: $0.0, quantity: 0, incrementBy: $0.1) }
        }

        return [
            "Grains & Flours": make([
                ("All-purpose flour", 100), ("Wheat flour", 100),
                ("Rice", 100), ("Popcorn kernels", 50)
            ]),
            "Baking": make([
                ("Baking powder", 5), ("Baking soda", 5),
                ("Cocoa powder", 5), ("Vanilla extract", 5)
            ]),
            "Dairy": make([
                ("Butter", 50), ("Milk", 100), ("Full cream milk", 100), ("Cream", 50),
                ("Whipped cream", 50), ("Yogurt", 100), ("Paneer", 100),
                ("Shredded cheese", 50), ("Sour cream", 50), ("Milk powder", 50), ("Eggs", 1)
            ]),
            "Vegetables": make([
                ("Onions", 1), ("Tomatoes", 1), ("Potatoes", 1), ("Bell peppers", 1),
                ("Cherry tomatoes", 50), ("Green peas", 50), ("Spinach", 100),
                ("Zucchini", 1), ("Jalapeños", 1), ("Mixed vegetables", 100)
            ]),
            "Proteins": make([("Chicken", 100), ("Chicken breast", 100)]),
            "Spices": make([
                ("Salt", 100), ("Black pepper", 100), ("Red chili powder", 100),
                ("Cumin powder", 100), ("Cumin seeds", 100), ("Garam masala", 100),
                ("Biryani masala", 100), ("Chaat masala", 100), ("Cardamom powder", 100),
                ("Paprika", 100), ("Garlic powder", 100), ("Kasuri methi", 100)
            ]),
            "Oils": make([("Oil", 250), ("Olive oil", 250), ("Ghee", 250)]),
            "Aromatics": make([("Garlic cloves", 5), ("Ginger-garlic paste", 10)]),
            "Herbs": make([("Fresh mint leaves", 10), ("Mint leaves", 10), ("Parsley", 10)]),
            "Sweeteners": make([("Sugar", 50), ("Honey", 50)]),
            "Condiments": make([("Tomato puree", 50), ("Salsa", 50)]),
            "Beverages": make([
                ("Coffee", 10), ("Water", 100), ("Hot water", 100), ("Soda water", 100)
            ]),
            "Fruits": make([
                ("Lime", 1), ("Lime slices", 1), ("Lemon juice", 10),
                ("Fresh mangoes", 1), ("Watermelon", 100)
            ]),
            "Specialty": make([("Saffron", 1), ("Rose water", 10), ("Dark chocolate", 50)]),
            "Snacks": make([("Bread loaf", 1), ("Tortilla chips", 50), ("Black olives", 10)]),
            "Others": make([("Ice cubes", 10)])
        ]
    }
}
