import Foundation

struct PantryItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    var quantity: Int
}
