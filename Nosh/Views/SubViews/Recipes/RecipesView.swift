import SwiftUI

struct RecipesView: View {
    @State private var selectedCategory: String? = "Full Meal"

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    CategorySelector(selectedCategory: $selectedCategory)
                    VStack(spacing: 20){
                        
                    }
                }
                .padding(.top)
                .padding(.bottom, 100) // Extra bottom spacing like original
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("primaryBackground"))
        }
    }
}
