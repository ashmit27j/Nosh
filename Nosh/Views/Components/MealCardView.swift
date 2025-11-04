import SwiftUI

struct MealCardView: View {
    let meal: Meal
    var onCookNowTapped: ((Meal) -> Void)? = nil
    
    // Check ingredient availability
    private var hasIngredients: Bool {
        PantryManager.shared.hasAllIngredients(for: meal, servingSize: meal.servingSize)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let imageURL: URL? = {
                guard let imageName = meal.imageName,
                      !imageName.isEmpty,
                      let url = URL(string: imageName) else {
                    return nil
                }
                return url
            }()
            
            AsyncImage(url: imageURL) { phase in
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
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(hasIngredients ? Color("primaryText") : Color("secondaryText"))
                    .lineLimit(1)
                
                Text(meal.description)
                    .font(.subheadline)
                    .foregroundColor(Color("secondaryText"))
                    .lineLimit(2)
                
                // ✅ Insufficient ingredients indicator
                if !hasIngredients {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                        Text("Insufficient Ingredients")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                        Text(meal.timeToCook)
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                        Text("\(meal.servingSize)")
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(difficultyColor(for: meal.difficulty))
                            .frame(width: 8, height: 8)
                        Text(meal.difficulty.rawValue)
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                    }
                }
                
                Text("Cook Now")
                    .font(.headline)
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
        .opacity(hasIngredients ? 1.0 : 0.6)  // ✅ Gray out if unavailable
        .contentShape(Rectangle())
        .onTapGesture {
            onCookNowTapped?(meal)
        }
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
