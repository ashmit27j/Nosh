import SwiftUI
import FirebaseFirestore

struct UpcomingMealsSection: View {
    @State private var currentIndex = 0
    @State private var cardHeight: CGFloat = 380
    @State private var meals: [Meal] = []
    @State private var isLoading = true
    
    let onViewAllTapped: () -> Void
    private let db = Firestore.firestore()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Upcoming meals")
                    .font(.title2.bold())

                Spacer()

                Button(action: onViewAllTapped) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundColor(Color("primaryAccent"))

                        Image("triangleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(Color("primaryButtonText"))
                    }
                }
            }

            if isLoading {
                ProgressView()
                    .frame(height: cardHeight)
                    .frame(maxWidth: .infinity)
            } else if meals.isEmpty {
                Text("No meals available")
                    .foregroundColor(.gray)
                    .frame(height: cardHeight)
                    .frame(maxWidth: .infinity)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(meals.indices, id: \.self) { index in
                        MealCardView(meal: meals[index])
                            .padding(.horizontal, 4)
                            .tag(index)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: CardHeightKey.self, value: geo.size.height)
                                }
                            )
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: cardHeight)
                .onPreferenceChange(CardHeightKey.self) { height in
                    if height > 0 {
                        cardHeight = height
                    }
                }

                HStack(spacing: 6) {
                    ForEach(0..<meals.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.primary : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            fetchUpcomingMeals()
        }
    }
    
    private func fetchUpcomingMeals() {
        print("🔄 Fetching upcoming meals...")
        
        db.collection("recipes")
            .limit(to: 5)
            .getDocuments { snapshot, error in  // Remove [weak self]
                // Use self directly instead of self?
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("❌ Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("❌ No documents")
                        return
                    }
                    
                    print("📦 Got \(documents.count) documents")
                    
                    self.meals = documents.compactMap { doc in
                        do {
                            return try doc.data(as: Meal.self)
                        } catch {
                            print("❌ Failed to decode: \(error)")
                            return nil
                        }
                    }
                    
                    print("✅ Parsed \(self.meals.count) meals")
                    self.meals.forEach { print("   - \($0.name)") }
                }
            }
    }

}

struct CardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 380
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
