import SwiftUI

struct DifficultySelector: View {
    @Binding var selectedDifficulty: String?

    let difficulties = [
        (name: "Beginner", icon: "beginnerIcon", color: Color("primaryAccent")),
        (name: "Novice", icon: "noviceIcon", color: Color("pastelGreen")),
        (name: "Intermediate", icon: "intermediateIcon", color: Color.orange),
        (name: "Professional", icon: "professionalIcon", color: Color.red)
    ]

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Difficulty")
                    .font(.headline)
                Text("Select your cooking skill level")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    ForEach(difficulties.indices, id: \.self) { index in
                        let difficulty = difficulties[index]

                        VStack(spacing: 10) {
                            Button(action: {
                                selectedDifficulty = difficulty.name
                            }) {
                                Image(difficulty.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .frame(width: 70, height: 70)
                                    .background(difficulty.color.opacity(selectedDifficulty == difficulty.name ? 1 : 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            Text(difficulty.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }

                        if index != difficulties.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
