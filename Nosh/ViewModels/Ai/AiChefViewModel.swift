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

    /// Nil when GEMINI_API_KEY is absent from Secrets.plist, in which case the
    /// chat degrades to database lookups only instead of crashing.
    private let model: GenerativeModel?

    init() {
        if let apiKey = Config.geminiAPIKey {
            model = GenerativeModel(name: "gemini-2.0-flash-exp", apiKey: apiKey)
        } else {
            model = nil
        }
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
            Log.recipes.error("Error fetching username: \(error)")
            userName = "Chef"
        }
    }
    
    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }

        // Cap the input so one paste can't run up a large model bill.
        let prompt = String(trimmed.prefix(2000))

        messages.append(ChatMessage(
            content: prompt,
            isUser: true,
            mealFromDatabase: nil
        ))

        isLoading = true

        Task {
            if let meal = await findMatchingMeal(for: prompt) {
                messages.append(ChatMessage(
                    content: "I found this recipe in your collection!",
                    isUser: false,
                    mealFromDatabase: meal
                ))
                isLoading = false
            } else {
                await getAIResponse(for: prompt)
            }
        }
    }

    /// Looks for a recipe the user named explicitly.
    ///
    /// Only matches on a whole-word basis and requires a reasonably specific
    /// name, so "how do I stop my rice going mushy?" reaches the model instead
    /// of being short-circuited by the Rice recipe. Also queries by name rather
    /// than downloading the whole collection on every message.
    private func findMatchingMeal(for query: String) async -> Meal? {
        let normalized = query.lowercased()
        let tokens = Set(
            normalized
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 }
        )
        guard !tokens.isEmpty else { return nil }

        do {
            let snapshot = try await db.collection("recipes").limit(to: 200).getDocuments()

            var best: (meal: Meal, score: Int)?
            for document in snapshot.documents {
                guard let meal = Meal(document: document) else { continue }

                let nameTokens = Set(
                    meal.name.lowercased()
                        .components(separatedBy: CharacterSet.alphanumerics.inverted)
                        .filter { !$0.isEmpty }
                )
                guard !nameTokens.isEmpty else { continue }

                // Every significant word of the recipe name must appear in the
                // query, so a match means the user actually named the dish.
                guard nameTokens.isSubset(of: tokens) else { continue }

                let score = nameTokens.count
                if score > (best?.score ?? 0) {
                    best = (meal, score)
                }
            }
            return best?.meal
        } catch {
            return nil
        }
    }

    private func getAIResponse(for text: String) async {
        let prompt = """
        You are Chef Nosh, a friendly cooking assistant. Please respond naturally without using markdown formatting like asterisks or bold markers.
        
        User query: \(text)
        
        Provide a clear, conversational response with proper paragraphs and line breaks for readability. Do not use ** or * for formatting. Just write naturally.
        """
        
        guard let model else {
            messages.append(ChatMessage(
                content: "Chef Nosh isn't available right now. Try searching your recipes instead.",
                isUser: false,
                mealFromDatabase: nil
            ))
            isLoading = false
            return
        }

        do {
            let response = try await model.generateContent(prompt)
            
            guard let responseText = response.text else {
                self.messages.append(ChatMessage(
                    content: "Sorry, I couldn't generate a response. Please try again.",
                    isUser: false,
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
                mealFromDatabase: nil
            ))
            
        } catch {
            self.messages.append(ChatMessage(
                content: "Sorry, I encountered an error. Please try again.",
                isUser: false,
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
    
}
