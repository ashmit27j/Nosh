import Foundation

struct PantryItem: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var quantity: Double
    var incrementBy: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case incrementBy
    }
    
    init(id: UUID, name: String, quantity: Double, incrementBy: Double = 0.5) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.incrementBy = incrementBy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(Double.self, forKey: .quantity)
        incrementBy = try container.decodeIfPresent(Double.self, forKey: .incrementBy) ?? 0.5
    }
}
