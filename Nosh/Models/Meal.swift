import Foundation

struct Meal: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var description: String
    var imageName: String
    var timeToCook: Int // in minutes (maps to time_to_cook)
    var servingSize: Int // maps to serving_size
    var difficulty: Difficulty
    var categoryId: Int // maps to category_id (3 = cupcakes from your example)
    var preferences: Int // 0 = both, 1 = veg, 2 = non-veg
    var ingredients: [String] // array of ingredients
    var steps: [String] // array of cooking steps
    var nutritionalContent: String // e.g., "Calories: 333 kcal, Protein: 7g"
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
    
    // Category mapping
    enum Category: Int {
        case snack = 1
        case drinks = 2
        case cupcakes = 3 // from your data
        case fullMeal = 4
        case appetizer = 5
        
        var name: String {
            switch self {
            case .snack: return "Snack"
            case .drinks: return "Drinks"
            case .cupcakes: return "Dessert"
            case .fullMeal: return "Full Meal"
            case .appetizer: return "Appetizer"
            }
        }
    }
    
    // Preference mapping
    enum FoodPreference: Int {
        case both = 0
        case veg = 1
        case nonVeg = 2
        
        var displayName: String {
            switch self {
            case .both: return "Both"
            case .veg: return "Veg"
            case .nonVeg: return "Non-Veg"
            }
        }
    }
    
    // Default initializer
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String = "Delicious homemade dish",
        imageName: String,
        timeToCook: Int,
        servingSize: Int,
        difficulty: Difficulty,
        categoryId: Int = 4,
        preferences: Int = 0,
        ingredients: [String] = [],
        steps: [String] = [],
        nutritionalContent: String = "",
        isAvailableInPantry: Bool = false
    ) {
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
}

// MARK: - Firestore Extension
// In Meal.swift, update the init?(from document:) method
extension Meal {
    init?(from document: [String: Any]) {
        // Debug: Print what we're receiving
        print("📄 Parsing document data: \(document)")
        
        guard let id = document["id"] as? String,
              let name = document["name"] as? String else {
            print("❌ Missing required fields: id or name")
            return nil
        }
        
        print("✅ Found ID: \(id), Name: \(name)")
        
        // Make image optional with fallback
        let imageName = document["image"] as? String ?? "frankieImage"
        
        // Parse time_to_cook - handle both String and Int
        let timeToCook: Int
        if let timeInt = document["time_to_cook"] as? Int {
            timeToCook = timeInt
        } else if let timeString = document["time_to_cook"] as? String {
            // Extract number from string like "100 mins"
            let numbers = timeString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            timeToCook = Int(numbers) ?? 30
        } else {
            timeToCook = 30
        }
        
        // Parse serving_size
        let servingSize = document["serving_size"] as? Int ?? 2
        
        // Other fields with defaults
        let description = document["description"] as? String ?? "Delicious dish"
        let categoryId = document["category_id"] as? Int ?? 4
        let preferences = document["preferences"] as? Int ?? 0
        let nutritionalContent = document["nutritional_content"] as? String ?? ""
        let isAvailable = document["is_available_in_pantry"] as? Bool ?? false
        
        // Parse ingredients array
        let ingredients: [String]
        if let ingredientsArray = document["ingredients"] as? [Any] {
            ingredients = ingredientsArray.compactMap { item in
                // Handle both string and dictionary formats
                if let str = item as? String {
                    return str
                } else if let dict = item as? [String: Any] {
                    // Get first value from dictionary
                    return dict.values.first as? String
                }
                return nil
            }
            print("   📝 Parsed \(ingredients.count) ingredients")
        } else {
            ingredients = []
        }
        
        // Parse steps - handle dictionary format
        let steps: [String]
        if let stepsDict = document["steps"] as? [String: Any] {
            // Dictionary format like {"0": "Mix flour", "1": "Add eggs"}
            steps = stepsDict.keys.sorted().compactMap { key in
                stepsDict[key] as? String
            }
            print("   📋 Parsed \(steps.count) steps from dictionary")
        } else if let stepsArray = document["steps"] as? [String] {
            steps = stepsArray
            print("   📋 Parsed \(steps.count) steps from array")
        } else {
            steps = []
        }
        
        // Parse difficulty (integer in Firestore)
        let difficultyInt = document["difficulty"] as? Int ?? 1
        let difficulty: Difficulty = {
            switch difficultyInt {
            case 1: return .easy
            case 2: return .novice
            case 3: return .intermediate
            case 4: return .professional
            default: return .easy
            }
        }()
        
        print("   ✅ Successfully parsed meal: \(name)")
        
        self.init(
            id: id,
            name: name,
            description: description,
            imageName: imageName,
            timeToCook: timeToCook,
            servingSize: servingSize,
            difficulty: difficulty,
            categoryId: categoryId,
            preferences: preferences,
            ingredients: ingredients,
            steps: steps,
            nutritionalContent: nutritionalContent,
            isAvailableInPantry: isAvailable
        )
    }
}
