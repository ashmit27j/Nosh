import Foundation

struct PantryItem: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var category: String
    var quantity: Int
}

