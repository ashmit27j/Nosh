//what all data does the meal item take
import Foundation
struct MealItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var imageName: String
    var cookTime: Int
    var servingSize: Int
    var isAvailableInPantry: Bool //to check for item availability
}
