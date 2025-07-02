import SwiftUI

struct QuickBitesSection: View {
    @Binding var selectedCategory: String?
    
    let categories = [
        (name: "Snack", icon: "snackIcon", color: Color.yellow),
        (name: "Drinks", icon: "drinkIcon", color: Color.cyan),
        (name: "Appetizer", icon: "appetizerIcon", color: Color.purple),
        (name: "Full Meal", icon: "fullmealIcon", color: Color.green)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Bites")
                .font(.headline)
                .foregroundColor(Color("primaryText"))

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
                                    : Color("buttonSecondary")
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
        .padding() // internal padding within card
        .background(Color("primaryCard")) // actual card color
        .cornerRadius(12)
//        .padding(.horizontal, 20) // same outer horizontal padding as others
    }
}
