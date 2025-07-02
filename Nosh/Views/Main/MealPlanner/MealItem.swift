//what all data does the meal item take
//SAMPLE DATA USED BY MANY PAGES DONT DELETE
import Foundation
struct MealItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var imageName: String
    var cookTime: Int
    var servingSize: Int
    var isAvailableInPantry: Bool //to check for item availability
}
