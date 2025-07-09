import SwiftUI

struct RandomDishSheet: View {
    let meal: MealItem
    let onRollAgain: () -> Void

    var body: some View {
        ScrollView {
            //add the rectangle here
            VStack {
                Rectangle()
                    .fill(Color("primaryLineColor"))
                    .frame(height: 6)
                    .frame(maxWidth: 50)
                    .cornerRadius(100)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity) 
            .padding(.vertical, 10)

            VStack(spacing: 24) {
                //MARK: this is the top bar that will be pulled down if the user wishes to exit UI popup
                #warning("Meal Card (I will later add a meal card component here directly, this is temp)")
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

                    //cook now button
                    Button(action: {
                        #warning("delete this later, only for testing")
                        print("cook now button was succesfully pressed (testprint statment delete later)")
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
                #warning("dice section animation and working pending, this is static")
                HStack {
                    VStack(spacing: 12) {
                        Text("Roll The Dice")
                            .font(.headline)
                            .foregroundColor(Color("primaryText"))

                        DiceView(iconName: "diceIcon") {
                            onRollAgain()
                        }

                        Text("Tap the dice to roll again and discover another dish!")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("primaryCard"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal)
            }
//            .padding(.top)
        }
        .background(Color("primaryBackground").ignoresSafeArea())
    }
}
