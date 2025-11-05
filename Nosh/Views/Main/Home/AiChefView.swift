import SwiftUI

struct AiChefView: View {
    @StateObject private var viewModel = AiChefViewModel()
    @State private var messageText = ""
    @State private var isAnimating = false
    @FocusState private var isInputFocused: Bool
    @Binding var isAiChefActive: Bool
    
    // Sheet state for opening meal details
    @State private var selectedMeal: Meal? = nil
    @State private var showMealSheet = false
    
    // Multiple greeting options for random display
    let greetings = [
        "Ready to whip up something amazing?",
        "What's cooking today?",
        "Let's create something delicious!",
        "Hungry for inspiration?",
        "Time to explore new flavors!",
        "Let's find your next favorite meal!",
        "Ready to cook something special?"
    ]
    
    var body: some View {
        ZStack {
            Color("primaryBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if viewModel.messages.isEmpty {
                    ScrollView {
                        VStack(spacing: 24) {
                            Spacer()
                                .frame(height: 20)
                            
                            // Animated Chef Circle
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color("primaryAccent"),
                                                Color("primaryAccent").opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: 140, height: 140)
                                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                    .animation(
                                        Animation.linear(duration: 8)
                                            .repeatForever(autoreverses: false),
                                        value: isAnimating
                                    )
                                
                                Circle()
                                    .fill(Color("primaryAccent").opacity(0.15))
                                    .frame(width: 120, height: 120)
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 2)
                                            .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                
                                Circle()
                                    .fill(Color("primaryAccent"))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "fork.knife")
                                            .font(.system(size: 40, weight: .semibold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: Color("primaryAccent").opacity(0.3), radius: 20)
                            }
                            .padding(.vertical, 12)
                            .onAppear {
                                isAnimating = true
                            }
                            
                            // Updated greeting text
                            Text("Hi, \(viewModel.userName)!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("primaryText"))
                            
                            Text(viewModel.randomGreeting)
                                .font(.subheadline)
                                .foregroundColor(Color("secondaryText"))
                                .padding(.top, -4)
                            
                            Spacer()
                                .frame(height: 20)
                            
                            // FAQs Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quick Questions")
                                    .font(.headline)
                                    .foregroundColor(Color("primaryText"))
                                    .padding(.horizontal, 20)
                                
                                ForEach(viewModel.faqs, id: \.self) { faq in
                                    Button(action: {
                                        messageText = faq
                                        sendMessage()
                                    }) {
                                        HStack {
                                            Text(faq)
                                                .font(.subheadline)
                                                .foregroundColor(Color("primaryText"))
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "arrow.right.circle.fill")
                                                .foregroundColor(Color("primaryAccent"))
                                        }
                                        .padding()
                                        .background(Color("primaryCard"))
                                        .cornerRadius(12)
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.messages) { message in
                                    ChatMessageRow(
                                        message: message,
                                        onMealTap: { meal in
                                            selectedMeal = meal
                                            showMealSheet = true
                                        }
                                    )
                                    .id(message.id)
                                }
                                
                                if viewModel.isLoading {
                                    HStack {
                                        ProgressView()
                                            .tint(Color("primaryAccent"))
                                        Text("Chef Nosh is thinking...")
                                            .font(.caption)
                                            .foregroundColor(Color("secondaryText"))
                                    }
                                    .padding()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Updated input bar with visible send button
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color("secondaryText").opacity(0.2))
                        .frame(height: 0.5)
                    
                    HStack(alignment: .center, spacing: 12) {
                        // Text input area
                        HStack(spacing: 8) {
                            TextField("Message", text: $messageText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .focused($isInputFocused)
                                .font(.body)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(24)
                        
                        // Send button - always visible with primaryAccent background
                        Button(action: {
                            if !messageText.isEmpty {
                                sendMessage()
                            }
                        }) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    messageText.isEmpty ?
                                        Color("primaryAccent").opacity(0.5) :
                                        Color("primaryAccent")
                                )
                                .clipShape(Circle())
                        }
                        .disabled(viewModel.isLoading || messageText.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color("primaryCard"))
                }
                .background(Color("primaryCard"))
            }
        }
        .navigationTitle("Chef Nosh")
        .toolbarBackground(Color("primaryCard"), for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMealSheet) {
            if let meal = selectedMeal {
                NavigationStack {
                    RecipeView(meal: meal)
                }
            }
        }
        .onAppear {
            isAiChefActive = true
            viewModel.loadUserName()
            viewModel.randomGreeting = greetings.randomElement() ?? greetings[0]
        }
        .onDisappear {
            isAiChefActive = false
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let text = messageText
        messageText = ""
        isInputFocused = false
        viewModel.sendMessage(text)
    }
}

struct ChatMessageRow: View {
    let message: ChatMessage
    var onMealTap: ((Meal) -> Void)? = nil
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(cleanedText(message.content))
                    .font(.body)
                    .foregroundColor(message.isUser ? Color("primaryCard") : Color("primaryText"))
                    .padding(12)
                    .background(
                        message.isUser ?
                            Color("primaryAccent") :
                            Color(.systemGray6)
                    )
                    .cornerRadius(16)
                
                // Show meal cards if available from database
                if let meal = message.mealFromDatabase {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Found in Your Collection")
                            .font(.headline)
                            .foregroundColor(Color("primaryAccent"))
                            .padding(.top, 4)
                        
                        MealCardView(meal: meal) { tappedMeal in
                            onMealTap?(tappedMeal)
                        }
                    }
                } else if let recipes = message.recipes, !recipes.isEmpty {
                    // Show AI-generated recipes if no database match
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Chef's Recommendation")
                            .font(.headline)
                            .foregroundColor(Color("primaryAccent"))
                            .padding(.top, 4)
                        
                        ForEach(recipes) { recipe in
                            RecipeCardCompact(recipe: recipe)
                        }
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
    
    // Clean text by removing markdown formatting
    private func cleanedText(_ text: String) -> String {
        var cleaned = text
        // Remove bold markers
        cleaned = cleaned.replacingOccurrences(of: "**", with: "")
        // Remove italic markers
        cleaned = cleaned.replacingOccurrences(of: "*", with: "")
        // Remove code markers
        cleaned = cleaned.replacingOccurrences(of: "`", with: "")
        return cleaned
    }
}

struct RecipeCardCompact: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color("primaryText"))
            
            Text(recipe.description)
                .font(.caption)
                .foregroundColor(Color("secondaryText"))
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Label("\(recipe.prepTime + recipe.cookTime) min", systemImage: "clock")
                Label(recipe.difficulty.rawValue, systemImage: "chart.bar")
                Label("\(recipe.servings)", systemImage: "person.2")
            }
            .font(.caption)
            .foregroundColor(Color("secondaryText"))
            
            if recipe.isFromDatabase {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("primaryAccent"))
                        .font(.caption)
                    Text("From your collection")
                        .font(.caption2)
                        .foregroundColor(Color("primaryAccent"))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color("primaryAccent").opacity(0.15))
                .cornerRadius(8)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("primaryCard"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color("primaryAccent").opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: Color("primaryAccent").opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let recipes: [Recipe]?
    let mealFromDatabase: Meal? // NEW: Add meal from database
    let timestamp: Date = Date()
}
