//struct MealItem: Identifiable, Hashable, Codable {
//    let id: UUID
//    var name: String
//    var imageName: String
//    var cookTime: Int
//    var servingSize: Int
//    var isAvailableInPantry: Bool
//
//    init(id: UUID = UUID(), name: String, imageName: String, cookTime: Int, servingSize: Int, isAvailableInPantry: Bool) {
//        self.id = id
//        self.name = name
//        self.imageName = imageName
//        self.cookTime = cookTime
//        self.servingSize = servingSize
//        self.isAvailableInPantry = isAvailableInPantry
//    }
//}
import Foundation

struct MealItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var imageName: String
    var cookTime: Int
    var servingSize: Int
    var isAvailableInPantry: Bool
}
