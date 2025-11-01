import SwiftUI

struct MealResultsView: View {
    @Environment(\.dismiss) var dismiss
    let meals: [Meal]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground")
                    .ignoresSafeArea()
                
                if meals.isEmpty {
                    // Empty State
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
                } else {
                    // Results List
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(meals) { meal in
                                MealCardView(meal: meal)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
