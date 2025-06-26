import SwiftUI

public struct RecipeView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedFilter: String

    let filters = ["Snack", "Drinks", "Appetizer", "Full Meal"]

    // Example recipe data (replace with your actual model or API)
    let recipes: [Recipe] = [
        Recipe(name: "Chips", type: "Snack"),
        Recipe(name: "Lemonade", type: "Drinks"),
        Recipe(name: "Spring Rolls", type: "Appetizer"),
        Recipe(name: "Pasta", type: "Full Meal"),
        Recipe(name: "Tea", type: "Drinks"),
        Recipe(name: "Burger", type: "Full Meal"),
        Recipe(name: "Nachos", type: "Snack")
    ]

    var filteredRecipes: [Recipe] {
        recipes.filter { $0.type == selectedFilter }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Top Bar with Close Button
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding()
            }

            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .font(.subheadline.bold())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedFilter == filter ? Color.purple : Color.gray.opacity(0.2))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }

            // Filtered Recipe List
            List {
                ForEach(filteredRecipes) { recipe in
                    HStack {
                        Image(systemName: "fork.knife") // Replace with recipe image if available
                            .foregroundColor(.purple)
                        Text(recipe.name)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color(.systemGroupedBackground))
    }
}
