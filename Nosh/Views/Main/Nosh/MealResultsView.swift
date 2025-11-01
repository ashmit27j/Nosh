import SwiftUI

struct MealResultsView: View {
    @Environment(\.dismiss) var dismiss
    let meals: [Meal]
    
    var body: some View {
        NavigationStack {
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
            .background(Color("primaryBackground"))
            .navigationTitle("Recipe Results")
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
