import SwiftUI

struct Nosh: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    NoshSection()
                }
                .padding(.top)
                .padding(.bottom, 80) // Extra bottom spacing
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

            //MARK: Category Box
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.headline)
                //Buttons stack for category
                
                HStack {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]

                        VStack(spacing: 10) {
                            Button(action: {
                                selectedCategory = category.name
                            }) {
                                Image(category.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 26, height: 26)
                                    .frame(width: 70, height: 70)
                                    .background(category.color.opacity(selectedCategory == category.name ? 1 : 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }

                        // Add spacer *between* items, but not after the last one
                        if index != categories.count - 1 {
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)


            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)

            // MARK: Portion Size Box
            // Portion Size Box
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading) {
                                Text("Portion Size")
                                    .font(.headline)
                                Text("Select the number of people to cook for")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Spacer(minLength: 0)

                                HStack {
                                    Button(action: { if portionSize > 1 { portionSize -= 1 } }) {
                                        Image(systemName: "minus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .frame(width: 50, height: 50)
                                            .background(Color("primaryAccent"))
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }

                                    Spacer()

                                    Text("\(portionSize)")
                                        .font(.title2)
                                        .frame(minWidth: 40)

                                    Spacer()

                                    Button(action: { portionSize += 1 }) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .frame(width: 50, height: 50)
                                            .background(Color("primaryAccent"))
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )

                                Spacer(minLength: 0)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)

            // Time to Cook Box
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Time to Cook")
                        .font(.headline)
                    Text("Select the amount of preparation time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    

                    Text("\(Int(timeToCook)) min")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)

                    Slider(value: $timeToCook, in: 0...60, step: 1)
                        .accentColor(Color("primaryAccent"))
                    
                    HStack {
                        Text("0")
                        Spacer()
                        Text("60")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)

            // Difficulty Box
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Difficulty")
                        .font(.headline)
                    Text("How hard it is to prepare the dish")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                HStack {
                    Spacer(minLength: 0)

                    ForEach(difficulties.indices, id: \.self) { index in
                        let difficulty = difficulties[index]

                        VStack(spacing: 20) {
                            Button(action: {
                                selectedDifficulty = difficulty.name
                            }) {
                                Image(difficulty.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 26, height: 26)
                                    .frame(width: 70, height: 70)
                                    .background(difficulty.color.opacity(selectedDifficulty == difficulty.name ? 1 : 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(difficulty.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }

                        Spacer(minLength: 0)
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)

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
            .padding(.horizontal)
        }
    }
}
