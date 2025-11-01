import SwiftUI

struct MealItemView: View {
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(meal.timeToCook)m")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    // Servings
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.caption2)
                        Text("\(meal.servingSize)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Pantry indicator
            if meal.isAvailableInPantry {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color("cardBackground"))
        .cornerRadius(10)
    }
}
