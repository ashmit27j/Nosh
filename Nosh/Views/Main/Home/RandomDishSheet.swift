import SwiftUI

struct RandomDishSheet: View {
    let meal: MealItem
    let onRollAgain: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Meal Card
                VStack(alignment: .leading, spacing: 16) {
                    Image(meal.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(16)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(meal.name)
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text("\(meal.cookTime) mins | \(meal.servingSize) servings | Ready to cook!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Button(action: {
                        // Trigger your cook flow
                    }) {
                        Text("Cook Now")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryAccent"))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color("primaryCard"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)

                // MARK: - Dice Section
                VStack(spacing: 12) {
                    Text("Roll The Dice")
                        .font(.headline)
                        .foregroundColor(.white)

                    DiceView(iconName: "diceIcon") {
                        onRollAgain()
                    }

                    Text("Tap the dice to roll again and discover another dish!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 24)
        }
        .background(Color("primaryBackground").ignoresSafeArea())
    }
}
