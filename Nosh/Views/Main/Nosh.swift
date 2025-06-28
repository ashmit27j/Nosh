import SwiftUI

struct Nosh: View {
    //these are default values that i wrote randomly, they will be assigned based on data given during user onboarding
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
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {

                    // Category Selector
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 16) {
                            ForEach(categories, id: \.name) { category in
                                VStack(spacing: 4) {
                                    Button(action: {
                                        selectedCategory = category.name
                                    }) {
                                        Image(category.icon)
                                            .resizable()
                                            .renderingMode(.original)
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .padding(16)
                                            .frame(maxWidth: .infinity)
                                            .background(category.color.opacity(selectedCategory == category.name ? 1 : 0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    Text(category.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // Portion Size
                    VStack(alignment: .leading, spacing: 8) {
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
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    // Time to Cook
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time to Cook")
                            .font(.headline)
                        Text("Select the amount of preparation time (in minutes)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        VStack {
                            Text("\(Int(timeToCook)) min")
                                .font(.title2)
                                .bold()

                            Slider(value: $timeToCook, in: 5...60, step: 1)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    // Difficulty
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty")
                            .font(.headline)
                        Text("How hard it is to prepare the dish")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        HStack(spacing: 16) {
                            ForEach(difficulties, id: \.name) { difficulty in
                                VStack(spacing: 4) {
                                    Button(action: {
                                        selectedDifficulty = difficulty.name
                                    }) {
                                        Image(difficulty.icon)
                                            .resizable()
                                            .renderingMode(.original)
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .padding(16)
                                            .frame(maxWidth: .infinity)
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

                    // Example Scroll Cards
                    VStack(spacing: 16) {
                        ForEach(0..<10) { i in
                            Text("Generated Recipe \(i + 1)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                }
                .padding()
            }
            .navigationTitle("Nosh")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension Color {
    func darker() -> Color {
        return self.opacity(0.5)
    }
}
