import SwiftUI

struct CategorySelector: View {
    @Binding var selectedCategory: String?
    
    let categories = [
        (name: "Snack", icon: "snackIcon", color: Color.yellow),
        (name: "Drinks", icon: "drinkIcon", color: Color.cyan),
        (name: "Appetizer", icon: "appetizerIcon", color: Color.purple),
        (name: "Full Meal", icon: "fullmealIcon", color: Color.green)
    ]

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.headline)

                HStack {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        VStack(spacing: 10) {
                            Button(action: {
                                selectedCategory = category.name
                            }) {
                                Image(category.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        selectedCategory == category.name
                                        ? category.color
                                        : Color.clear
                                    )
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
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
}
