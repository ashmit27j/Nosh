import SwiftUI

struct MealCardView: View {
    let meal: Meal
    
    var body: some View {
        NavigationLink {
            RecipeView(meal: meal)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: meal.imageName.isEmpty ? "invalid" : meal.imageName)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.3)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .padding(40)
                            .background(Color.gray.opacity(0.2))
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(height: 180)
                .clipped()
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(meal.name)
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                        .lineLimit(1)
                    
                    Text(meal.description)
                        .font(.caption)
                        .foregroundColor(Color("secondaryText"))
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                            Text("\(meal.timeToCook) min")
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                        }
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(difficultyColor(for: meal.difficulty))
                                .frame(width: 6, height: 6)
                            Text(meal.difficulty.rawValue)
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                        }
                    }
                    
                    Text("Cook Now")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primaryButtonText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color("primaryAccent"))
                        .cornerRadius(8)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("primaryCard"))
            }
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(CardButtonStyle())
    }
    
    private func difficultyColor(for difficulty: Meal.Difficulty) -> Color {
        switch difficulty {
        case .easy: return Color("primaryAccent")
        case .novice: return Color("pastelGreen")
        case .intermediate: return Color.orange
        case .professional: return Color.red
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
