//import SwiftUI
//
//struct UpcomingMealCard: View {
//    let meal: UpcomingMeal
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Image(meal.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 180)
//                .padding(16)
//                .frame(maxWidth: .infinity)
//                .clipped()
//                .cornerRadius(16)
//
//            VStack(alignment: .leading, spacing: 10) {
//                Text(meal.name)
//                    .font(.headline)
//
//                Button(action: {
//                    print("cook noew button clicked hehe")
//                }) {
//                    HStack {
//                        Text("Cook Now")
//                            .foregroundColor(Color("primaryButtonText"))
//                        Image("triangleIcon")
//                            .renderingMode(.template)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20, height: 20)
//                            .rotationEffect(.degrees(-90))
//                            .foregroundColor(Color("primaryButtonText"))
//                    }
//                    .font(.subheadline.bold())
//                    .foregroundColor(.white)
//                    .padding(.vertical, 20)
//                    .frame(maxWidth: .infinity)
//                    .background(Color("primaryAccent"))
//                    .cornerRadius(10)
//                }
//            }
//            .padding(20)
//        }
//        .background(Color("primaryCard"))
//        
//        .cornerRadius(20)
//    }
//}
//
import SwiftUI

struct UpcomingMealCard: View {
    let meal: UpcomingMeal

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipped() // Removed corner radius

            VStack(alignment: .leading, spacing: 8) {
                Text(meal.name)
                    .font(.headline)

                Text("Ready in 30 min · Serves 2")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    // TODO: Handle cook action
                }) {
                    HStack {
                        Text("Cook Now")
                            .foregroundColor(Color("primaryButtonText"))
                        Image("triangleIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(Color("primaryButtonText"))
                    }
                    .font(.subheadline.bold())
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color("primaryAccent"))
                    .cornerRadius(10)
                }
            }
            .padding(20)
            .background(Color("primaryCard"))
        }
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
}
