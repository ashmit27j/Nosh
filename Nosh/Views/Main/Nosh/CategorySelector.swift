import SwiftUI

struct CategorySelector: View {
    @Binding var selectedCategories: Set<String>
    var allowMultipleSelection: Bool = true
    
    let categories = [
        (name: "Snack", icon: "snackIcon", color: Color.yellow),
        (name: "Drinks", icon: "drinkIcon", color: Color.cyan),
        (name: "Appetizer", icon: "appetizerIcon", color: Color.purple),
        (name: "Full Meal", icon: "fullmealIcon", color: Color.green)
    ]

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Category")
                        .font(.headline)
                    
                    if allowMultipleSelection && !selectedCategories.isEmpty {
                        Spacer()
                        Button("Clear All") {
                            selectedCategories.removeAll()
                        }
                        .font(.caption)
                        .foregroundColor(Color("primaryAccent"))
                    }
                }

                HStack {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        VStack(spacing: 10) {
                            Button(action: {
                                handleCategoryTap(category.name)
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    Image(category.icon)
                                        .resizable()
                                        .renderingMode(.original)
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .frame(width: 70, height: 70)
                                        .background(
                                            selectedCategories.contains(category.name)
                                            ? category.color.opacity(0.3)
                                            : Color.clear
                                        )
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    selectedCategories.contains(category.name)
                                                    ? category.color
                                                    : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    
                                    // Checkmark for multi-select
                                    if allowMultipleSelection && selectedCategories.contains(category.name) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(category.color)
                                            .background(
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 18, height: 18)
                                            )
                                            .offset(x: 4, y: -4)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        
                        if index != categories.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
    
    // Centralized tap handling
    private func handleCategoryTap(_ categoryName: String) {
        print("🎯 Category tapped: \(categoryName), multi-select: \(allowMultipleSelection)")
        
        if allowMultipleSelection {
            // Multi-select mode: toggle
            if selectedCategories.contains(categoryName) {
                selectedCategories.remove(categoryName)
                print("   ➖ Removed \(categoryName)")
            } else {
                selectedCategories.insert(categoryName)
                print("   ➕ Added \(categoryName)")
            }
        } else {
            // Single-select mode: replace
            if selectedCategories.contains(categoryName) {
                selectedCategories.removeAll()
                print("  Deselected \(categoryName)")
            } else {
                selectedCategories = [categoryName]
                print("  Selected \(categoryName) only")
            }
        }
        
        print("   Current selection: \(selectedCategories)")
    }
}
