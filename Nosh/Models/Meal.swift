import Foundation
import FirebaseFirestore

struct Meal: Identifiable, Hashable, Codable {

    /// Stable identity that survives the Firestore round trip.
    ///
    /// For a recipe read out of the `recipes` collection this is the document ID,
    /// stamped on by `init(document:)`. It is then *encoded* into the nested
    /// meal-plan arrays, so decoding the same recipe back out of a meal plan
    /// yields the same identity. Previously this fell back to a fresh `UUID()` on
    /// every decode, which made duplicate detection and SwiftUI diffing unreliable.
    var recipeId: String

    var id: String { recipeId }

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
        case recipeId = "recipe_id"
        // Written by earlier builds; read so meals already saved in a meal plan
        // keep their identity instead of all decoding to the same empty ID.
        case legacyLocalId = "localId"
        case legacyFirestoreId = "firestoreId"
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

    var timeInMinutes: Int {
        let digits = timeToCook.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let minutes = Int(digits), minutes > 0 {
            return minutes
        }
        return 999
    }

    // MARK: - Init

    init(
        recipeId: String = UUID().uuidString,
        name: String,
        description: String = "",
        imageName: String? = nil,
        timeToCook: String,
        servingSize: Int,
        difficulty: Difficulty,
        categoryId: Int = 4,
        preferences: Int = 0,
        ingredients: [String] = [],
        steps: [String] = [],
        nutritionalContent: String = "",
        isAvailableInPantry: Bool = false
    ) {
        self.recipeId = recipeId
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

    /// Decodes a recipe from a Firestore document, stamping the document ID as
    /// the meal's identity.
    ///
    /// `@DocumentID` cannot be relied on here: this type needs a hand-written
    /// decoder for its lenient field fallbacks, and a custom `init(from:)`
    /// bypasses the property wrapper's document-ID injection entirely.
    init?(document: DocumentSnapshot) {
        guard var meal = try? document.data(as: Meal.self) else { return nil }
        if meal.recipeId.isEmpty {
            meal.recipeId = document.documentID
        }
        self = meal
    }

    init?(document: QueryDocumentSnapshot) {
        guard var meal = try? document.data(as: Meal.self) else { return nil }
        if meal.recipeId.isEmpty {
            meal.recipeId = document.documentID
        }
        self = meal
    }

    // MARK: - Codable

    /// Lenient decoder: recipe documents in Firestore are not uniformly shaped,
    /// so every field falls back rather than failing the whole document.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Empty means "not yet identified" — init(document:) fills it in.
        // Falls back to the pre-migration keys so meals already stored in a
        // meal plan keep the identity they were saved with.
        recipeId = (try? container.decode(String.self, forKey: .recipeId))
            ?? (try? container.decode(String.self, forKey: .legacyFirestoreId))
            ?? (try? container.decode(String.self, forKey: .legacyLocalId))
            ?? ""

        name = (try? container.decode(String.self, forKey: .name)) ?? "Untitled Recipe"
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        imageName = try? container.decode(String.self, forKey: .imageName)
        timeToCook = (try? container.decode(String.self, forKey: .timeToCook)) ?? "30 mins"
        servingSize = (try? container.decode(Int.self, forKey: .servingSize)) ?? 1

        // Difficulty is stored as a string in some documents and an int in others.
        if let raw = try? container.decode(String.self, forKey: .difficulty),
           let parsed = Difficulty(rawValue: raw) {
            difficulty = parsed
        } else if let raw = try? container.decode(Int.self, forKey: .difficulty) {
            switch raw {
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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Persisting recipeId is what makes identity survive into meal plans.
        try container.encode(recipeId, forKey: .recipeId)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encode(timeToCook, forKey: .timeToCook)
        try container.encode(servingSize, forKey: .servingSize)
        try container.encode(difficulty.rawValue, forKey: .difficulty)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(preferences, forKey: .preferences)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(steps, forKey: .steps)
        try container.encode(nutritionalContent, forKey: .nutritionalContent)
        try container.encode(isAvailableInPantry, forKey: .isAvailableInPantry)
    }

    // MARK: - Hashable

    // Identity-based, so a meal compares equal to itself across fetches.
    static func == (lhs: Meal, rhs: Meal) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Day Meal Plan

struct DayMealPlan: Identifiable, Codable {
    /// The `yyyy-MM-dd` document ID. Also the dictionary key used throughout the
    /// meal planner — see `MealPlannerViewModel.dateKey(for:)`.
    var id: String
    var date: Date
    var breakfast: [Meal]
    var lunch: [Meal]
    var dinner: [Meal]

    enum CodingKeys: String, CodingKey {
        case date, breakfast, lunch, dinner
    }

    init(id: String, date: Date, breakfast: [Meal] = [], lunch: [Meal] = [], dinner: [Meal] = []) {
        self.id = id
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }

    init?(document: DocumentSnapshot) {
        guard var plan = try? document.data(as: DayMealPlan.self) else { return nil }
        plan.id = document.documentID
        self = plan
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = ""
        if let timestamp = try? container.decode(Timestamp.self, forKey: .date) {
            date = timestamp.dateValue()
        } else {
            date = Date()
        }
        breakfast = (try? container.decode([Meal].self, forKey: .breakfast)) ?? []
        lunch = (try? container.decode([Meal].self, forKey: .lunch)) ?? []
        dinner = (try? container.decode([Meal].self, forKey: .dinner)) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Timestamp(date: date), forKey: .date)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
    }

    /// Convenience accessor so callers don't switch on a raw string.
    subscript(mealType: MealType) -> [Meal] {
        get {
            switch mealType {
            case .breakfast: return breakfast
            case .lunch: return lunch
            case .dinner: return dinner
            }
        }
        set {
            switch mealType {
            case .breakfast: breakfast = newValue
            case .lunch: lunch = newValue
            case .dinner: dinner = newValue
            }
        }
    }
}

// MARK: - Meal Times

struct MealTimes: Codable {
    var breakfastTime: Date
    var lunchTime: Date
    var dinnerTime: Date

    /// Defaults applied when a user first signs up.
    static var `default`: MealTimes {
        let calendar = Calendar.current
        let now = Date()
        let breakfast = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now) ?? now
        let lunch = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now) ?? now
        let dinner = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now
        return MealTimes(breakfastTime: breakfast, lunchTime: lunch, dinnerTime: dinner)
    }
}

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"

    /// The Firestore field name for this meal type.
    var field: String { rawValue.lowercased() }

    init?(field: String) {
        self.init(rawValue: field.capitalized)
    }
}
