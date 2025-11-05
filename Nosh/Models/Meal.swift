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
        
        id = try? container.decode(String.self, forKey: .id)
        name = (try? container.decode(String.self, forKey: .name)) ?? "Untitled Recipe"
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        imageName = try? container.decode(String.self, forKey: .imageName)
        timeToCook = (try? container.decode(String.self, forKey: .timeToCook)) ?? "30 mins"
        servingSize = (try? container.decode(Int.self, forKey: .servingSize)) ?? 1
        
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
        
        categoryId = (try? container.decode(Int.self, forKey: .categoryId)) ?? 4
        preferences = (try? container.decode(Int.self, forKey: .preferences)) ?? 0
        ingredients = (try? container.decode([String].self, forKey: .ingredients)) ?? []
        steps = (try? container.decode([String].self, forKey: .steps)) ?? []
        nutritionalContent = (try? container.decode(String.self, forKey: .nutritionalContent)) ?? ""
        isAvailableInPantry = (try? container.decode(Bool.self, forKey: .isAvailableInPantry)) ?? false
    }
}

// MARK: - Day Meal Plan Structure (UPDATED - Robust Decoding)
struct DayMealPlan: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var breakfast: [Meal]
    var lunch: [Meal]
    var dinner: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case breakfast
        case lunch
        case dinner
    }
    
    // Custom initializer
    init(id: String? = nil, date: Date, breakfast: [Meal], lunch: [Meal], dinner: [Meal]) {
        self.id = id
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
    
    // Custom decoder with fallbacks
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode ID (optional)
        id = try? container.decode(String.self, forKey: .id)
        
        // Decode date (required, fallback to now)
        if let timestamp = try? container.decode(Timestamp.self, forKey: .date) {
            date = timestamp.dateValue()
        } else {
            date = Date()
        }
        
        // Decode breakfast array (fallback to empty array)
        breakfast = (try? container.decode([Meal].self, forKey: .breakfast)) ?? []
        
        // Decode lunch array (fallback to empty array)
        lunch = (try? container.decode([Meal].self, forKey: .lunch)) ?? []
        
        // Decode dinner array (fallback to empty array)
        dinner = (try? container.decode([Meal].self, forKey: .dinner)) ?? []
    }
    
    // Custom encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(Timestamp(date: date), forKey: .date)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
    }
}


// MARK: - Meal Times (Stored at User Level)
struct MealTimes: Codable {
    var breakfastTime: Date
    var lunchTime: Date
    var dinnerTime: Date
    
    static var `default`: MealTimes {
        let calendar = Calendar.current
        let now = Date()
        
        let breakfast = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now) ?? now
        let lunch = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now) ?? now
        let dinner = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now
        
        return MealTimes(breakfastTime: breakfast, lunchTime: lunch, dinnerTime: dinner)
    }
}

enum MealType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
}
