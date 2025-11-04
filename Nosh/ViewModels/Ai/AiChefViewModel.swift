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
        let userMessage = ChatMessage(content: text, isUser: true, recipes: nil)
        messages.append(userMessage)
        
        isLoading = true
        
        Task {
            do {
                let dbRecipes = try await searchDatabaseRecipes(query: text)
                
                if !dbRecipes.isEmpty {
                    let response = generateDatabaseResponse(recipes: dbRecipes, query: text)
                    let botMessage = ChatMessage(
                        content: response,
                        isUser: false,
                        recipes: dbRecipes
                    )
                    messages.append(botMessage)
                } else {
                    try await searchOnlineAndRespond(query: text)
                }
                
                isLoading = false
            } catch {
                let errorMessage = ChatMessage(
                    content: "Sorry, I encountered an error. Please try again!",
                    isUser: false,
                    recipes: nil
                )
                messages.append(errorMessage)
                isLoading = false
            }
        }
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
    
    private func searchOnlineAndRespond(query: String) async throws {
        let prompt = """
        You are Chef Nash, a friendly and knowledgeable cooking assistant. A user asked: "\(query)"
        
        Please provide a recipe recommendation with the following details:
        - Recipe name
        - Brief description (1-2 sentences)
        - List of ingredients with quantities
        - Step-by-step instructions
        - Prep time (in minutes)
        - Cook time (in minutes)
        - Difficulty level (Beginner/Intermediate/Advanced)
        - Servings
        - Category (Full Meal/Breakfast/Lunch/Dinner/Dessert/Snack)
        - Food preference (Vegetarian/Non-Vegetarian/Vegan)
        
        Format the response in a friendly, conversational way. Start with a brief greeting and explain the recipe you're suggesting.
        """
        
        let response = try await model.generateContent(prompt)
        
        guard let text = response.text else {
            throw NSError(domain: "AiChef", code: 1, userInfo: [NSLocalizedDescriptionKey: "No response"])
        }
        
        let recipe = try parseGeminiResponse(text, query: query)
        
        let botMessage = ChatMessage(
            content: text,
            isUser: false,
            recipes: recipe != nil ? [recipe!] : nil
        )
        messages.append(botMessage)
    }
    
    private func parseGeminiResponse(_ text: String, query: String) throws -> Recipe? {
        return nil
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
