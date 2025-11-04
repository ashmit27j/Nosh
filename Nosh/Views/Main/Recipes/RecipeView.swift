
import SwiftUI

struct RecipeView: View {
    @Environment(\.dismiss) var dismiss
    let meal: Meal
    
    @State private var servingSize: Int
    @State private var isFavorite: Bool = false
    @State private var isIngredientsExpanded: Bool = false
    @State private var isRecipeExpanded: Bool = false
    @State private var checkedIngredients: Set<Int> = []
    @State private var checkedSteps: Set<Int> = []
    @State private var showSuccessScreen: Bool = false
    
    // ✅ Pantry integration properties
    private var hasIngredients: Bool {
        PantryManager.shared.hasAllIngredients(for: meal, servingSize: servingSize)
    }

    private var missingIngredients: [String] {
        PantryManager.shared.getMissingIngredients(for: meal, servingSize: servingSize)
    }
    
    private var servingMultiplier: Double {
        Double(servingSize) / Double(meal.servingSize)
    }
    
    private var allStepsCompleted: Bool {
        checkedSteps.count == meal.steps.count
    }
    
    init(meal: Meal) {
        self.meal = meal
        _servingSize = State(initialValue: meal.servingSize)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Image
                    ZStack(alignment: .topTrailing) {
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
                                    .padding(60)
                                    .background(Color.gray.opacity(0.2))
                            @unknown default:
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(height: 300)
                        .clipped()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .top,
                            endPoint: .center
                        )
                        .frame(height: 300)
                        
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(Color("primaryAccent"))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text(meal.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("primaryText"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(meal.description)
                                .font(.subheadline)
                                .foregroundColor(Color("secondaryText"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // ✅ MISSING INGREDIENTS BOX (only if missing)
                        if !missingIngredients.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text("Missing Ingredients")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(missingIngredients, id: \.self) { item in
                                        HStack(spacing: 6) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.red)
                                            Text(item)
                                                .font(.subheadline)
                                                .foregroundColor(Color("primaryText"))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 2)
                            )
                        }
                        
                        ServingSizeSection
                        IngredientsSection
                        RecipeStepsSection
                    }
                    .padding()
                    .padding(.bottom, 120)
                }
            }
            .background(Color("primaryBackground"))
            
            VStack {
                Spacer()
                BottomButtons
            }
            .ignoresSafeArea(edges: .bottom)
            
            if showSuccessScreen {
                SuccessOverlay
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
    
    // ✅ Original Serving Size Section
    private var ServingSizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Serving Size")
                    .font(.headline)
                    .foregroundColor(Color("primaryText"))
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                    .foregroundColor(Color("secondaryText"))
            }
            
            HStack {
                Button(action: {
                    if servingSize > 1 {
                        servingSize -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("primaryText"))
                        .frame(width: 60, height: 60)
                        .background(Color("primaryAccent"))
                        .cornerRadius(16)
                }
                
                Spacer()
                
                Text("\(servingSize)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryText"))
                
                Spacer()
                
                Button(action: {
                    servingSize += 1
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("primaryText"))
                        .frame(width: 60, height: 60)
                        .background(Color("primaryAccent"))
                        .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(16)
    }
    
    // ✅ Original Ingredients Section (collapsible with checkboxes)
    private var IngredientsSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isIngredientsExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Ingredients")
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                    
                    Spacer()
                    
                    Image(systemName: isIngredientsExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("secondaryText"))
                }
                .padding()
                .background(Color("primaryCard"))
            }
            
            if isIngredientsExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(meal.ingredients.enumerated()), id: \.offset) { index, ingredient in
                        Button(action: {
                            if checkedIngredients.contains(index) {
                                checkedIngredients.remove(index)
                            } else {
                                checkedIngredients.insert(index)
                            }
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: checkedIngredients.contains(index) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(checkedIngredients.contains(index) ? Color("primaryAccent") : Color("secondaryText"))
                                
                                Text(scaleIngredient(ingredient))
                                    .font(.body)
                                    .foregroundColor(Color("primaryText"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(Color("primaryCard"))
                        }
                        
                        if index < meal.ingredients.count - 1 {
                            Divider()
                                .background(Color("secondaryButton").opacity(0.3))
                        }
                    }
                }
                .background(Color("primaryCard"))
            }
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("secondaryButton").opacity(0.3), lineWidth: 1)
        )
    }
    
    // ✅ Original Recipe Steps Section (collapsible with numbered circles)
    private var RecipeStepsSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isRecipeExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Recipe")
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                    
                    Spacer()
                    
                    Image(systemName: isRecipeExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("secondaryText"))
                }
                .padding()
                .background(Color("primaryCard"))
            }
            
            if isRecipeExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                        Button(action: {
                            if checkedSteps.contains(index) {
                                checkedSteps.remove(index)
                            } else {
                                checkedSteps.insert(index)
                            }
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(spacing: 0) {
                                    ZStack {
                                        Circle()
                                            .fill(checkedSteps.contains(index) ? Color("primaryAccent") : Color("secondaryButton"))
                                            .frame(width: 32, height: 32)
                                        
                                        if checkedSteps.contains(index) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Color("primaryText"))
                                        } else {
                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color("primaryText"))
                                        }
                                    }
                                    
                                    if index < meal.steps.count - 1 {
                                        Rectangle()
                                            .fill(Color("secondaryButton").opacity(0.3))
                                            .frame(width: 2)
                                            .frame(maxHeight: .infinity)
                                    }
                                }
                                .frame(height: 80)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Step \(index + 1)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(checkedSteps.contains(index) ? Color("primaryAccent") : Color("primaryText"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(step)
                                        .font(.body)
                                        .foregroundColor(Color("secondaryText"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical, 8)
                            }
                            .padding()
                            .background(checkedSteps.contains(index) ? Color("primaryAccent").opacity(0.1) : Color("primaryCard"))
                        }
                        
                        if index < meal.steps.count - 1 {
                            Divider()
                                .background(Color("secondaryButton").opacity(0.3))
                        }
                    }
                }
                .background(Color("primaryCard"))
            }
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("secondaryButton").opacity(0.3), lineWidth: 1)
        )
    }
    
    // ✅ Bottom Buttons with Cancel + Finish (pantry integrated)
    private var BottomButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(Color("primaryText"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color("secondaryButton").opacity(0.3))
                    .cornerRadius(16)
            }
            
            Button(action: {
                if hasIngredients && allStepsCompleted {
                    // ✅ Deduct from pantry
                    PantryManager.shared.deductIngredients(for: meal, servingSize: servingSize)
                    showSuccessScreen = true
                }
            }) {
                Text(hasIngredients ? "Finish" : "Missing Ingredients")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("primaryText"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background((hasIngredients && allStepsCompleted) ? Color("primaryAccent") : Color.gray.opacity(0.3))
                    .cornerRadius(16)
            }
            .disabled(!hasIngredients || !allStepsCompleted)
        }
        .padding()
        .background(Color("primaryCard"))
    }
    
    private var SuccessOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Recipe Completed!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Great job on making \(meal.name)!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    showSuccessScreen = false
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color("primaryAccent"))
                        .cornerRadius(16)
                }
            }
            .padding(32)
            .background(Color("primaryCard"))
            .cornerRadius(24)
            .padding()
        }
    }
    
    private func scaleIngredient(_ ingredient: String) -> String {
        let pattern = #"(\d+\.?\d*)\s*(g|kg|ml|l|cup|cups|tbsp|tsp|oz)?"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return ingredient
        }
        
        let range = NSRange(ingredient.startIndex..., in: ingredient)
        guard let match = regex.firstMatch(in: ingredient, range: range) else {
            return ingredient
        }
        
        guard let numberRange = Range(match.range(at: 1), in: ingredient),
              let originalValue = Double(ingredient[numberRange]) else {
            return ingredient
        }
        
        let scaledValue = originalValue * servingMultiplier
        let scaledString = scaledValue.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(scaledValue)) : String(format: "%.1f", scaledValue)
        
        return regex.stringByReplacingMatches(
            in: ingredient,
            range: range,
            withTemplate: scaledString + (match.range(at: 2).location != NSNotFound ? " $2" : "")
        )
    }
}

struct MealSuccessScreen: View {
    let meal: Meal
    let dismiss: DismissAction
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("🎉")
                .font(.system(size: 80))
            
            Text("Meal Completed!")
                .font(.title.bold())
                .foregroundColor(Color("primaryText"))
            
            Text("You've successfully cooked \(meal.name)")
                .font(.body)
                .foregroundColor(Color("secondaryText"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(Color("primaryButtonText"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primaryAccent"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
    }
}
