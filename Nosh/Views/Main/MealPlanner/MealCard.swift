import SwiftUI

struct MealCard: View {
    let meal: MealItem
    var isEditing: Bool = false // to control UI state
    var onDelete: (() -> Void)? = nil // optional closure for delete action

    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Meal Image
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(12)

            // MARK: - Meal Info
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)

                Text("\(meal.cookTime) mins | \(meal.servingSize) servings")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(meal.isAvailableInPantry ? "Ready To Cook!" : "Unavailable")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: - Right-Aligned Action Button
            if isEditing {
                // When editing: show red trash button
                Button(action: {
                    onDelete?()
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding() // match size with cook button
//                        .background(Color("buttonSecondary"))
                        .background(.ultraThinMaterial)
                    
                        .cornerRadius(12)
                        .foregroundColor(.red)
                }
            } else {
                // When not editing: show cook CTA
                Button(action: {
                    print("Cook now tapped for \(meal.name)")
                }) {
                    Image("triangleIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(-90))
                        .padding()
                        .foregroundColor(Color("secondaryAccent"))
                        .background(meal.isAvailableInPantry ? Color("primaryAccent") : Color("buttonSecondary"))
                        .cornerRadius(12)
                }
                .disabled(!meal.isAvailableInPantry) // disable the button if the material isn't available
            }
        }
        .padding(.vertical, 4)
        .background(Color("primaryCard"))
        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
