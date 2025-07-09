import Foundation

struct PantryItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var quantity: Int
//    var requiresRestocking: Bool
}
