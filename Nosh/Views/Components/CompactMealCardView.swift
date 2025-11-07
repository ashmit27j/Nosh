import SwiftUI

//this is for the compact meal card view that can be added and seen in a shorter form
struct CompactMealCardView: View {
    let meal: Meal
    var showAddButton: Bool = false
    var onAdd: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            // Recipe image
            if let imageName = meal.imageName, let url = URL(string: imageName) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .foregroundColor(.white)
                    )
            }
            
            // Recipe info (REMOVED serving size)
            VStack(alignment: .leading, spacing: 6) {
                Text(meal.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primaryText"))
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(meal.timeToCook, systemImage: "clock")
                        .font(.system(size: 13))
                    
                    Label(meal.difficulty.rawValue, systemImage: "chart.bar")
                        .font(.system(size: 13))
                }
                .foregroundColor(Color("secondaryText"))
            }
            
            Spacer()
            
            if showAddButton {
                Button(action: {
                    onAdd?()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("primaryAccent"))
                }
            }
        }
        .padding(12)
        .background(Color("primaryCard"))
        .cornerRadius(12)
    }
}
