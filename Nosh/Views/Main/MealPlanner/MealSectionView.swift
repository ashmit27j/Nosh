import SwiftUI

struct MealSectionView: View {
    let title: String
    let meals: [MealItem]
    let onEditTapped: () -> Void
    let onAdd: () -> Void
    let onDelete: (MealItem) -> Void
    let isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("primaryText"))

                Spacer()

                Button(action: onEditTapped) {
                    Text(!isEditing ? "Edit" : "Done")
                        .foregroundColor(Color("primaryAccent"))
                        .fontWeight(.medium)
                }
            }

            Rectangle()
                .fill(Color("secondaryButton"))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .cornerRadius(100)

            ForEach(meals) { meal in
                MealCard(
                    meal: meal,
                    isEditing: isEditing,
                    onDelete: { onDelete(meal) }
                )
            }

            if isEditing {
                Button(action: onAdd) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("primaryAccent"))
                        Text("Add \(title) Dish")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("secondaryText"))
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
