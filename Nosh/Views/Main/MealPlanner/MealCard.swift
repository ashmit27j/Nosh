import SwiftUI
struct MealCard: View {
    let meal: MealItem
    var isEditing: Bool = false // <- Add this to control the UI based on editing mode

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

            // MARK: - CTA Button
            if !isEditing {
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
                .disabled(meal.isAvailableInPantry ? false : true) //disable the button if the material isnt available
            } else {
                // background red when editing
                Rectangle()
                    .fill(Color("pastelRed"))
                    .frame(width: 56, height: 56)
                    .cornerRadius(12)
                    
            }
        }
        .padding(.vertical, 4)
        .background(Color("primaryCard"))
        .cornerRadius(16)
    }
}
