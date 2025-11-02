import Foundation
import FirebaseFirestore

struct Meal: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var imageName: String?
    var timeToCook: String
    var servingSize: Int
    var difficulty: Difficulty
    var categoryId: Int
    var preferences: Int
    var ingredients: [String]
    var steps: [String]
    var nutritionalContent: String
    var isAvailableInPantry: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageName = "image"
        case timeToCook = "time_to_cook"
        case servingSize = "serving_size"
        case difficulty
        case categoryId = "category_id"
        case preferences
        case ingredients
        case steps
        case nutritionalContent = "nutritional_content"
        case isAvailableInPantry = "is_available_in_pantry"
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case novice = "Novice"
        case intermediate = "Intermediate"
        case professional = "Professional"
    }
    
    // Helper to get numeric minutes
    var timeInMinutes: Int {
        let digits = timeToCook.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let minutes = Int(digits), minutes > 0 {
            return minutes
        }
        return 999
    }
    
    // Memberwise initializer
    init(id: String? = nil, name: String, description: String = "",
         imageName: String? = nil, timeToCook: String, servingSize: Int,
         difficulty: Difficulty, categoryId: Int = 4, preferences: Int = 0,
         ingredients: [String] = [], steps: [String] = [],
         nutritionalContent: String = "", isAvailableInPantry: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.timeToCook = timeToCook
        self.servingSize = servingSize
        self.difficulty = difficulty
        self.categoryId = categoryId
        self.preferences = preferences
        self.ingredients = ingredients
        self.steps = steps
        self.nutritionalContent = nutritionalContent
        self.isAvailableInPantry = isAvailableInPantry
    }
    
    // Custom decoder - ALL fields have fallback values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // ID
        id = try? container.decode(String.self, forKey: .id)
        
        // Name (required, defaults to "Untitled Recipe")
        name = (try? container.decode(String.self, forKey: .name)) ?? "Untitled Recipe"
        
        // Description (defaults to empty)
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        
        // Image (optional, defaults to nil)
        imageName = try? container.decode(String.self, forKey: .imageName)
        
        // Time to cook (defaults to "30 mins")
        timeToCook = (try? container.decode(String.self, forKey: .timeToCook)) ?? "30 mins"
        
        // Serving size (defaults to 1)
        servingSize = (try? container.decode(Int.self, forKey: .servingSize)) ?? 1
        
        // Difficulty (handle Int or fallback to easy)
        if let diffInt = try? container.decode(Int.self, forKey: .difficulty) {
            switch diffInt {
            case 1: difficulty = .easy
            case 2: difficulty = .novice
            case 3: difficulty = .intermediate
            case 4: difficulty = .professional
            default: difficulty = .easy
            }
        } else {
            difficulty = .easy
        }
        
        // Category ID (defaults to 4 = Full Meal)
        categoryId = (try? container.decode(Int.self, forKey: .categoryId)) ?? 4
        
        // Preferences (defaults to 0 = vegetarian)
        preferences = (try? container.decode(Int.self, forKey: .preferences)) ?? 0
        
        // Ingredients (defaults to empty array)
        ingredients = (try? container.decode([String].self, forKey: .ingredients)) ?? []
        
        // Steps (defaults to empty array)
        steps = (try? container.decode([String].self, forKey: .steps)) ?? []
        
        // Nutritional content (defaults to empty)
        nutritionalContent = (try? container.decode(String.self, forKey: .nutritionalContent)) ?? ""
        
        // Pantry availability (defaults to false)
        isAvailableInPantry = (try? container.decode(Bool.self, forKey: .isAvailableInPantry)) ?? false
    }
}
