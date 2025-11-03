import Foundation

struct CategoryHelper {
    static func nameToId(_ name: String) -> Int {
        switch name {
        case "Snack": return 1
        case "Drinks": return 2
        case "Appetizer": return 3
        case "Full Meal": return 4
        default: return 4
        }
    }
    
    static func idToName(_ id: Int) -> String {
        switch id {
        case 1: return "Snack"
        case 2: return "Drinks"
        case 3: return "Appetizer"
        case 4: return "Full Meal"
        default: return "Full Meal"
        }
    }
}
