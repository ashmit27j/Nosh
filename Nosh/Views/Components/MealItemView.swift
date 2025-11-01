import SwiftUI

struct MealItemView: View {
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail - AsyncImage
            AsyncImage(url: URL(string: meal.imageName)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(meal.timeToCook)m")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
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
