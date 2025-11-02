import SwiftUI

struct RandomDishSheet: View {
    let meal: Meal?
    let isLoading: Bool
    let onRollAgain: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
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
                    if isLoading {
                        ProgressView("Rolling the dice...")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                    } else if let meal = meal {
                        MealCardView(meal: meal)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No meals available")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                    }

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
            }
            .background(Color("primaryBackground").ignoresSafeArea())
        }
    }
}
