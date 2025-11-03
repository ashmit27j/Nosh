import SwiftUI

struct MealResultsView: View {
    @Environment(\.dismiss) var dismiss
    let meals: [Meal]
    
    @State private var selectedMealForCooking: Meal? = nil
    
    var body: some View {
        // REMOVED NavigationStack - already in Nosh
        ZStack {
            Color("primaryBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header (replaces navigationTitle)
                HStack {
                    Text("Recipes (\(meals.count))")
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color("primaryAccent"))
                }
                .padding()
                .background(Color("primaryCard"))
                
                if meals.isEmpty {
                    // Empty State
                    Spacer()
                    VStack(spacing: 24) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 80))
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                        VStack(spacing: 8) {
                            Text("No results found :(")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray.opacity(0.7))
                            
                            Text("Try adjusting your filters")
                                .font(.subheadline)
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                    }
                    Spacer()
                } else {
                    // Results List
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(meals) { meal in
                                MealCardView(
                                    meal: meal,
                                    onCookNowTapped: { selectedMeal in
                                        print("🔥 Card tapped for: \(selectedMeal.name)")
                                        selectedMealForCooking = selectedMeal
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedMealForCooking) { meal in
            RecipeView(meal: meal)
        }
    }
}
