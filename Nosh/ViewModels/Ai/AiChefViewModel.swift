import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import GoogleGenerativeAI

@MainActor
class AiChefViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var userName = "Chef"
    @Published var randomGreeting = ""
    
    let faqs = [
        "What can I make with chicken and rice?",
        "Show me quick dinner ideas",
        "I need a vegetarian recipe",
        "What's good for meal prep?",
        "Suggest something under 30 minutes"
    ]
    
    private let db = Firestore.firestore()
    private var model: GenerativeModel
    
    init() {
        model = GenerativeModel(
            name: "gemini-2.0-flash-exp",
            apiKey: "AIzaSyC9yMTAkzzJzbr8cwMyIgZRrz7tVUM-s7g"
        )
    }
    
    func loadUserName() {
        if let currentUser = Auth.auth().currentUser {
            if let displayName = currentUser.displayName, !displayName.isEmpty {
                userName = displayName.components(separatedBy: " ").first ?? displayName
            } else if let email = currentUser.email {
                userName = email.components(separatedBy: "@").first?.capitalized ?? "Chef"
            } else {
                userName = "Chef"
            }
        } else if let name = UserDefaults.standard.string(forKey: "userName") {
            userName = name
        } else {
            Task {
                await fetchUserNameFromFirestore()
            }
        }
    }
    
    private func fetchUserNameFromFirestore() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            if let data = document.data(),
               let name = data["name"] as? String ?? data["firstName"] as? String {
                userName = name
            }
        } catch {
            print("Error fetching username: \(error)")
            userName = "Chef"
        }
    }
    
    func sendMessage(_ text: String) {
        // Add user message
        messages.append(ChatMessage(
            content: text,
            isUser: true,
            recipes: nil,
            mealFromDatabase: nil
        ))
        
        isLoading = true
        
        // First, check if meal exists in database
        checkDatabaseForMeal(query: text) { foundMeal in
            if let meal = foundMeal {
                // Found in database - show meal card directly
                self.messages.append(ChatMessage(
                    content: "I found this recipe in your collection!",
                    isUser: false,
                    recipes: nil,
                    mealFromDatabase: meal
                ))
                self.isLoading = false
            } else {
                // Not in database - get AI response
                Task {
                    await self.getAIResponse(for: text)
                }
            }
        }
    }

    private func checkDatabaseForMeal(query: String, completion: @escaping (Meal?) -> Void) {
        let lowercaseQuery = query.lowercased()
        
        db.collection("recipes")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return
                }
                
                // Search for matching meal name
                for doc in documents {
                    if let meal = try? doc.data(as: Meal.self),
                       meal.name.lowercased().contains(lowercaseQuery) ||
                       lowercaseQuery.contains(meal.name.lowercased()) {
                        completion(meal)
                        return
                    }
                }
                
                completion(nil)
            }
    }

    private func getAIResponse(for text: String) async {
        let prompt = """
        You are Chef Nosh, a friendly cooking assistant. Please respond naturally without using markdown formatting like asterisks or bold markers.
        
        User query: \(text)
        
        Provide a clear, conversational response with proper paragraphs and line breaks for readability. Do not use ** or * for formatting. Just write naturally.
        """
        
        do {
            let response = try await model.generateContent(prompt)
            
            guard let responseText = response.text else {
                self.messages.append(ChatMessage(
                    content: "Sorry, I couldn't generate a response. Please try again.",
                    isUser: false,
                    recipes: nil,
                    mealFromDatabase: nil
                ))
                self.isLoading = false
                return
            }
            
            // Clean the response text
            let cleanedText = cleanMarkdown(responseText)
            
            self.messages.append(ChatMessage(
                content: cleanedText,
                isUser: false,
                recipes: nil,
                mealFromDatabase: nil
            ))
            
        } catch {
            self.messages.append(ChatMessage(
                content: "Sorry, I encountered an error. Please try again.",
                isUser: false,
                recipes: nil,
                mealFromDatabase: nil
            ))
        }
        
        self.isLoading = false
    }
    
    // Clean markdown formatting from text
    private func cleanMarkdown(_ text: String) -> String {
        var cleaned = text
        // Remove bold markers
        cleaned = cleaned.replacingOccurrences(of: "**", with: "")
        // Remove italic markers (single asterisk not touching alphanumeric)
        cleaned = cleaned.replacingOccurrences(of: "*", with: "")
        // Remove code markers
        cleaned = cleaned.replacingOccurrences(of: "`", with: "")
        // Remove headers
        cleaned = cleaned.replacingOccurrences(of: "###", with: "")
        cleaned = cleaned.replacingOccurrences(of: "##", with: "")
        cleaned = cleaned.replacingOccurrences(of: "#", with: "")
        return cleaned
    }
    
    private func searchDatabaseRecipes(query: String) async throws -> [Recipe] {
        let lowercaseQuery = query.lowercased()
        let keywords = extractKeywords(from: lowercaseQuery)
        
        var recipes: [Recipe] = []
        
        let snapshot = try await db.collection("recipes")
            .limit(to: 5)
            .getDocuments()
        
        for document in snapshot.documents {
            let data = document.data()
            
            if let recipe = parseRecipe(from: data, id: document.documentID) {
                if recipeMatchesQuery(recipe: recipe, keywords: keywords) {
                    var matchedRecipe = recipe
                    matchedRecipe.isFromDatabase = true
                    recipes.append(matchedRecipe)
                }
            }
        }
        
        return recipes
    }
    
    private func extractKeywords(from query: String) -> [String] {
        let stopWords = ["i", "want", "need", "show", "me", "can", "make", "with", "for", "a", "an", "the"]
        return query.components(separatedBy: .whitespacesAndNewlines)
            .filter { !stopWords.contains($0) && $0.count > 2 }
    }
    
    private func recipeMatchesQuery(recipe: Recipe, keywords: [String]) -> Bool {
        let searchableText = "\(recipe.name) \(recipe.description) \(recipe.category.rawValue) \(recipe.ingredients.joined(separator: " "))"
            .lowercased()
        
        return keywords.contains { keyword in
            searchableText.contains(keyword)
        }
    }
    
    private func generateDatabaseResponse(recipes: [Recipe], query: String) -> String {
        let recipeNames = recipes.map { $0.name }.joined(separator: ", ")
        
        let responses = [
            "Great! I found \(recipes.count) delicious recipe\(recipes.count > 1 ? "s" : "") from your collection: \(recipeNames). Tap any recipe to view details!",
            "Perfect! Here are \(recipes.count) recipe\(recipes.count > 1 ? "s" : "") that match what you're looking for. Check them out below!",
            "I've got \(recipes.count) fantastic option\(recipes.count > 1 ? "s" : "") for you! These are all from your saved recipes.",
            "Excellent choice! Found \(recipes.count) recipe\(recipes.count > 1 ? "s" : "") that should work perfectly."
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    private func parseRecipe(from data: [String: Any], id: String) -> Recipe? {
        guard let name = data["name"] as? String,
              let categoryStr = data["category"] as? String,
              let category = RecipeCategory(rawValue: categoryStr),
              let prepTime = data["prepTime"] as? Int,
              let cookTime = data["cookTime"] as? Int,
              let servings = data["servings"] as? Int,
              let difficultyStr = data["difficulty"] as? String,
              let difficulty = RecipeDifficulty(rawValue: difficultyStr),
              let ingredients = data["ingredients"] as? [String],
              let instructions = data["instructions"] as? [String]
        else {
            return nil
        }
        
        let description = data["description"] as? String ?? ""
        let preferenceStr = data["foodPreference"] as? String ?? "Both"
        let preference = FoodPreference(rawValue: preferenceStr) ?? .both
        
        return Recipe(
            id: id,
            name: name,
            description: description,
            category: category,
            prepTime: prepTime,
            cookTime: cookTime,
            servings: servings,
            difficulty: difficulty,
            ingredients: ingredients,
            instructions: instructions,
            foodPreference: preference,
            imageURL: data["imageURL"] as? String,
            isFromDatabase: false
        )
    }
}

struct Recipe: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: RecipeCategory
    let prepTime: Int
    let cookTime: Int
    let servings: Int
    let difficulty: RecipeDifficulty
    let ingredients: [String]
    let instructions: [String]
    let foodPreference: FoodPreference
    let imageURL: String?
    var isFromDatabase: Bool
}

enum RecipeCategory: String, CaseIterable {
    case fullMeal = "Full Meal"
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case dessert = "Dessert"
    case snack = "Snack"
}

enum RecipeDifficulty: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum FoodPreference: String, CaseIterable {
    case vegetarian = "Vegetarian"
    case nonVegetarian = "Non-Vegetarian"
    case vegan = "Vegan"
    case both = "Both"
}
