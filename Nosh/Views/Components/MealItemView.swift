//import SwiftUI
////this is the compact mealViewCard that is shown in Schedule right now
//struct MealItemView: View {
//    let meal: Meal
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            // Recipe image
//            if let imageName = meal.imageName, let url = URL(string: imageName) {
//                AsyncImage(url: url) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                } placeholder: {
//                    Color.gray.opacity(0.3)
//                }
//                .frame(width: 60, height: 60)
//                .cornerRadius(8)
//            } else {
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 60, height: 60)
//                    .overlay(
//                        Image(systemName: "fork.knife")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20))
//                    )
//            }
//            
//            // Recipe info (REMOVED serving size)
//            VStack(alignment: .leading, spacing: 4) {
//                Text(meal.name)
//                    .font(.system(size: 15, weight: .medium))
//                    .foregroundColor(Color("primaryText"))
//                    .lineLimit(1)
//                
//                HStack(spacing: 8) {
//                    Label(meal.timeToCook, systemImage: "clock")
//                        .font(.system(size: 12))
//                        .foregroundColor(Color("secondaryText"))
//                }
//            }
//            
//            Spacer()
//        }
//        .padding(8)
//        .background(Color("secondaryButton").opacity(0.3))
//        .cornerRadius(8)
//    }
//}

import SwiftUI
// MARK: - MealItemView (Compact Card)
struct MealItemView: View {
    let meal: Meal
    
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
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("primaryText"))
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Label(meal.timeToCook, systemImage: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(Color("secondaryText"))
                }
            }
            Spacer()
        }
        .padding(8)
        .background(Color("secondaryButton").opacity(0.3))
        .cornerRadius(8)
    }
}
