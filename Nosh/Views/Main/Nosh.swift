import SwiftUI

struct Nosh: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    NoshSection()
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 40) // Extra space at bottom
            }
            .navigationTitle("Nosh Now")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct NoshSection: View {
    @State private var selectedCategory: String? = "Full Meal"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"

    let categories = [
        (name: "Snack", icon: "snackIcon", color: Color.yellow),
        (name: "Drinks", icon: "drinkIcon", color: Color.cyan),
        (name: "Appetizer", icon: "appetizerIcon", color: Color.purple),
        (name: "Full Meal", icon: "fullmealIcon", color: Color.green)
    ]

    let difficulties = [
        (name: "Beginner", icon: "beginnerIcon", color: Color("primaryAccent")),
        (name: "Novice", icon: "noviceIcon", color: Color("pastelGreen")),
        (name: "Intermediate", icon: "intermediateIcon", color: Color.orange),
        (name: "Professional", icon: "professionalIcon", color: Color.red)
    ]

    var body: some View {
        VStack(spacing: 20) {

            // Category Box
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(categories, id: \.name) { category in
                        VStack(spacing: 10) {
                            Button(action: {
                                selectedCategory = category.name
                            }) {
                                Image(category.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .frame(width: 70, height: 70)
                                    .background(category.color.opacity(selectedCategory == category.name ? 1 : 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Portion Size Box
            VStack(alignment: .leading, spacing: 12) {
                Text("Portion Size")
                    .font(.headline)
                Text("Select the number of people to cook for")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Button(action: { if portionSize > 1 { portionSize -= 1 } }) {
                        Text("-")
                            .font(.title)
                            .frame(width: 50, height: 50)
                            .background(Color("primaryAccent"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Spacer()

                    Text("\(portionSize)")
                        .font(.title2)

                    Spacer()

                    Button(action: { portionSize += 1 }) {
                        Text("+")
                            .font(.title)
                            .frame(width: 50, height: 50)
                            .background(Color("primaryAccent"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Time to Cook Box
            VStack(alignment: .leading, spacing: 12) {
                Text("Time to Cook")
                    .font(.headline)
                Text("Select the amount of preparation time")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                VStack(alignment: .leading) {
                    HStack {
                        Text("0")
                        Spacer()
                        Text("60")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)

                    Text("\(Int(timeToCook)) min")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)

                    Slider(value: $timeToCook, in: 0...60, step: 1)
                        .accentColor(Color("primaryAccent"))
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Difficulty Box
            VStack(alignment: .leading, spacing: 12) {
                Text("Difficulty")
                    .font(.headline)
                Text("How hard it is to prepare the dish")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 12) {
                    ForEach(difficulties, id: \.name) { difficulty in
                        VStack(spacing: 20) {
                            Button(action: {
                                selectedDifficulty = difficulty.name
                            }) {
                                Image(difficulty.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .frame(width: 70, height: 70)
                                    .background(difficulty.color.opacity(selectedDifficulty == difficulty.name ? 1 : 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(difficulty.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Cook Now Button
            Button(action: {
                // Action to cook
            }) {
                Text("Cook Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primaryAccent"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

