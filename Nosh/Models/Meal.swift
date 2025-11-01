import Foundation

struct Meal: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var imageName: String
    var timeToCook: Int // in minutes
    var servingSize: Int
    var difficulty: Difficulty
    var isAvailableInPantry: Bool
    
    enum Difficulty: String, Codable {
        case easy = "Easy"
        case novice = "Novice"
        case intermediate = "Intermediate"
        case professional = "Professional"
        
        var color: String {
            switch self {
            case .easy: return "green"
            case .novice: return "blue"
            case .intermediate: return "orange"
            case .professional: return "red"
            }
        }
    }
    
    // Default initializer
    init(
        id: String = UUID().uuidString,
        name: String,
        imageName: String,
        timeToCook: Int,
        servingSize: Int,
        difficulty: Difficulty,
        isAvailableInPantry: Bool = false
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.timeToCook = timeToCook
        self.servingSize = servingSize
        self.difficulty = difficulty
        self.isAvailableInPantry = isAvailableInPantry
    }
}

// MARK: - Firestore Extension
extension Meal {
    init?(from document: [String: Any]) {
        guard let id = document["id"] as? String,
              let name = document["name"] as? String,
              let imageName = document["image"] as? String,
              let timeToCook = document["time_to_cook"] as? Int,
              let servingSize = document["serving_size"] as? Int,
              let difficultyString = document["difficulty"] as? String,
              let difficulty = Difficulty(rawValue: difficultyString.capitalized) else {
            return nil
        }
        
        let isAvailable = document["is_available_in_pantry"] as? Bool ?? false
        
        self.init(
            id: id,
            name: name,
            imageName: imageName,
            timeToCook: timeToCook,
            servingSize: servingSize,
            difficulty: difficulty,
            isAvailableInPantry: isAvailable
        )
    }
    
    // Convert to Firestore document
    func toDocument() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "image": imageName,
            "time_to_cook": timeToCook,
            "serving_size": servingSize,
            "difficulty": difficulty.rawValue,
            "is_available_in_pantry": isAvailableInPantry
        ]
    }
}
