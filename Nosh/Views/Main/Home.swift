import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    
                    // Header with profile, greeting, and search
                    HeaderView()
                        .padding(.top, geometry.safeAreaInsets.top + 8)
                    
                    // Recipes & AI Chef Buttons
                    HStack(spacing: 16) {
                        QuickBiteButton(title: "Recipes", icon: "")
                        QuickBiteButton(title: "AI Chef", icon: "chefhat.and.spoon")
                    }
//                    .padding(.horizontal)
                    
                    // Quick Bites Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick Bites")
                            .font(.title2).bold()
                        
                        Text("Whip up something delicious!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        QuickBitesChips()
                    }
//                    .padding(.horizontal)
                    
                    // Upcoming Meals Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming meals")
                            .font(.title2).bold()
                        
                        Text("Here are upcoming meals / No upcoming schedule one")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<3) { _ in
                                    MealCardView()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
//                    .padding(.horizontal)
                    
                    Spacer(minLength: geometry.safeAreaInsets.bottom + 20)
                }
            }
            .ignoresSafeArea(.keyboard) // avoids layout issues when keyboard shows up
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.circle.fill") // Replace with actual avatar
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Good Morning! User")
                    .font(.headline)
                Text("How’s it going today?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(Color(#colorLiteral(red: 0.854, green: 1.0, blue: 0.0, alpha: 1.0)))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Feature Buttons
struct QuickBiteButton: View {
    var title: String
    var icon: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.854, green: 1.0, blue: 0.0, alpha: 1.0)))
            .foregroundColor(.black)
            .cornerRadius(16)
        }
    }
}

// MARK: - Quick Bites Chips
struct QuickBitesChips: View {
    @State private var showRecipeView = false
    let categories = [
        ("Snack", "applelogo", Color("pastelYellow")),
        ("Drinks", "cup.and.saucer", Color("pastelYellow")),
        ("Appetizer", "takeoutbag.and.cup.and.straw.fill", Color("pastelYellow")),
        ("Full Meal", "fork.knife", Color("pastelYellow"))
    ]
    
    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.0) { item in
                    VStack {
                                Button {
                                    showRecipeView = true
                                } label: {
                                    Image(systemName: "book.fill") // Replace with item.1
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.purple) // Replace with item.2
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            .fullScreenCover(isPresented: $showRecipeView) {
                                RecipeView(selectedFilter: item.0) // 👈 PASS the filter name here
                            }
                }
            }
        }
    }
}

// MARK: - Meal Card View
struct MealCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("pancakes") // Replace with your actual asset
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 120)
                .clipped()
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Item Name")
                    .font(.headline)
                
                Text("Breakfast")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("330 kCalories")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Materials: available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Cook at 3:30")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {}) {
                    HStack {
                        Text("Cook Now")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 0.854, green: 1.0, blue: 0.0, alpha: 1.0)))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding([.horizontal, .bottom])
        }
        .frame(width: 220)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 15 Pro")
    }
}
