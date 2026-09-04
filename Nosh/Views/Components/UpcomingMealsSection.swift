import SwiftUI
import FirebaseFirestore
import FirebaseAuth

//test
struct UpcomingMealsSection: View {
    @State private var currentIndex = 0
    @State private var cardHeight: CGFloat = 380
    @State private var meals: [Meal] = []
    @State private var isLoading = true

    @State private var selectedMeal: Meal? = nil
    @State private var showRecipe: Bool = false

    let onViewAllTapped: () -> Void
    private let db = Firestore.firestore()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's meals")
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
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(Color("secondaryText").opacity(0.5))
                    Text("No meals planned for today")
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                    Text("Start planning your meals for the day")
                        .font(.subheadline)
                        .foregroundColor(Color("secondaryText"))
                        .multilineTextAlignment(.center)
                    Button(action: onViewAllTapped) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Recipes")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color("primaryAccent"))
                        .cornerRadius(12)
                    }
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("primaryCard"))
                .cornerRadius(12)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(meals.indices, id: \.self) { index in
                        MealCardView(
                            meal: meals[index],
                            onCookNowTapped: { meal in
                                selectedMeal = meal
                                showRecipe = true
                            }
                        )
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
            fetchTodaysMeals()
        }
        // NEW: Sheet for RecipeView
        .sheet(isPresented: $showRecipe) {
            if let meal = selectedMeal {
                RecipeView(meal: meal) 
            }
        }
    }

    // MARK: - Fetch Today's Meals from Meal Planner
    private func fetchTodaysMeals() {
        guard let userId = Auth.auth().currentUser?.uid else {
            Log.mealPlanner.error("No user logged in")
            isLoading = false
            return
        }


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())


        db.collection("users")
            .document(userId)
            .collection("mealPlanner")
            .document(todayString)
            .getDocument { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false

                    if let error = error {
                        Log.mealPlanner.error("Error fetching today's meals: \(error.localizedDescription)")
                        return
                    }

                    guard let snapshot = snapshot, snapshot.exists else {
                        return
                    }

                    do {
                        let dayPlan = try snapshot.data(as: DayMealPlan.self)

                        var allMeals: [Meal] = []
                        allMeals.append(contentsOf: dayPlan.breakfast)
                        allMeals.append(contentsOf: dayPlan.lunch)
                        allMeals.append(contentsOf: dayPlan.dinner)

                        self.meals = allMeals


                    } catch {
                        Log.mealPlanner.error("Failed to decode meal plan: \(error)")
                    }
                }
            }
    }
}

// Preference key for geometry reading.
struct CardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 380
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
