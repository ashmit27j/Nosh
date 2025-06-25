import SwiftUI

struct HomeView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeView()
}

//import SwiftUI
//
//struct HomeView: View {x
//    @Environment(\.colorScheme) var colorScheme
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Top Greeting & Search
//                VStack(alignment: .leading, spacing: 12) {
//                    HStack(alignment: .center, spacing: 12) {
//                        Image("profile_pic")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 50, height: 50)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Good Morning! User")
//                                .font(.system(size: 20, weight: .semibold))
//                                .foregroundColor(.black)
//                            Text("How’s it going today?")
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.gray)
//                        }
//                    }
//                    HStack(spacing: 0) {
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(Color.gray)
//                            Text("Search")
//                                .foregroundColor(Color.gray)
//                            Spacer()
//                        }
//                        .padding()
//                        .background(Color.primaryAccent.opacity(0.2))
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .frame(maxWidth: .infinity)
//
//                        Button(action: {
//                            // filter action
//                        }) {
//                            Image(systemName: "line.horizontal.3.decrease")
//                                .foregroundColor(.black)
//                                .frame(width: 50, height: 50)
//                                .background(Color.primaryAccent)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                    }
//                }
//                .padding(.horizontal)
//
//                // Recipe Buttons Row
//                HStack(spacing: 16) {
//                    Button(action: {}) {
//                        HStack {
//                            Image(systemName: "book.closed")
//                            Text("Recipes")
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.primaryAccent)
//                        .foregroundColor(.black)
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                    }
//                    Button(action: {}) {
//                        HStack {
//                            Image(systemName: "chefhat.fill")
//                            Text("AI Chef")
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.primaryAccent)
//                        .foregroundColor(.black)
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                    }
//                }
//                .padding(.horizontal)
//
//                // Quick Bites Section
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Quick Bites")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.black)
//                    Text("Whip up something delicious!")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color.gray)
//                    HStack(spacing: 16) {
//                        QuickBiteButton(color: Color.pastelYellow, icon: "applelogo", label: "Snack")
//                        QuickBiteButton(color: Color.pastelRed, icon: "pizza", label: "Cravings")
//                        QuickBiteButton(color: Color.pastelPurple, icon: "soup", label: "Appetizer")
//                        QuickBiteButton(color: Color.pastelGreen, icon: "fork.knife", label: "Full Meal")
//                    }
//                }
//                .padding(.horizontal)
//
//                // Upcoming Meals Card
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Upcoming meals")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.black)
//                    Text("Here are upcoming meals / No upcoming schedule one")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color.gray)
//                    VStack {
//                        HStack(spacing: 16) {
//                            Image("pancakes")
//                                .resizable()
//                                .aspectRatio(4/3, contentMode: .fill)
//                                .frame(width: 100, height: 100)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text("Item Name")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                                Text("Breakfast")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.green)
//                                Text("330 kCalories")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.green)
//                                Text("Materials: available")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.green)
//                                Text("Cook at 3:30")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.green)
//                            }
//                            Spacer()
//                        }
//                        Button(action: {}) {
//                            Text("Cook Now")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color.primaryAccent)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                }
//                .padding(.horizontal)
//
//                // Other Stuff Section
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Other Stuff")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.black)
//                    Text("Here are upcoming meals / No upcoming schedule one")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color.gray)
//
//                    // Pro Consultations
//                    VStack(alignment: .leading) {
//                        HStack {
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text("Pro Consultations")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                                Text("Book a consultation with a dietitian now!")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(Color.gray)
//                            }
//                            Spacer()
//                            Image("helmet_icon")
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                        }
//                        Button(action: {}) {
//                            Text("Book Now  ➝")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color.primaryAccent)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//
//                    // Plan Expired
//                    VStack(alignment: .leading) {
//                        HStack {
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text("Plan Expired")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                                Text("Premium plan with added benefits and 500+ recipes")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(Color.gray)
//                            }
//                            Spacer()
//                            Image("lotus_icon")
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                        }
//                        Button(action: {}) {
//                            Text("Renew Now  ➝")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color.primaryAccent)
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                }
//                .padding(.horizontal)
//
//                Spacer(minLength: 20)
//
//                // Bottom Navigation
//                HStack(spacing: 40) {
//                    NavItem(icon: "house.fill", selected: true)
//                    NavItem(icon: "list.bullet")
//                    NavItem(icon: "square.grid.2x2")
//                    NavItem(icon: "bag.fill")
//                    NavItem(icon: "person.fill")
//                }
//                .padding(.vertical, 12)
//                .frame(maxWidth: .infinity)
//                .background(Color.pastelGreen)
//            }
//            .padding(.top, 20)
//            .background(Color.primaryBackground)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//// QuickBiteButton, NavItem, Color extension, and PreviewProvider stay unchanged
//
////MARK: this has to be changed to a Navigation Component that will later be imported from a library or i will custom code the whole thing at once
//    // Custom Navigation Item
//struct NavItem: View {
//    var icon: String
//    var selected: Bool = false
//    
//    var body: some View {
//        Image(systemName: icon)
//            .resizable()
//            .scaledToFit()
//            .frame(width: 24, height: 24)
//            .foregroundColor(selected ? .white : Color.white.opacity(0.7))
//    }
//}
//
//// ✅ QuickBiteButton Component
//struct QuickBiteButton: View {
//    var color: Color
//    var icon: String
//    var label: String
//
//    var body: some View {
//        VStack(spacing: 8) {
//            Circle()
//                .fill(color.opacity(0.2))
//                .frame(width: 60, height: 60)
//                .overlay(
//                    Image(systemName: icon)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 28, height: 28)
//                        .foregroundColor(color)
//                )
//            Text(label)
//                .font(.system(size: 14))
//                .foregroundColor(.primary)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.white)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//    }
//}
//
//
//
//    struct HomeView_Preview: PreviewProvider {
//        static var previews: some View {
//            HomeView()
//        }
//    }
//
