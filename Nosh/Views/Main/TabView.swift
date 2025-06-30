import SwiftUI

struct TabView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: CaseIterable {
        case home, mealPlanner, nosh, pantry, profile

        var iconName: String {
            switch self {
            case .home: return "homeIcon"
            case .mealPlanner: return "mealplannerIcon"
            case .nosh: return "noshIcon"
            case .pantry: return "pantryIcon"
            case .profile: return "profileIcon"
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    Home()
                case .mealPlanner:
                    MealPlanner()
                case .nosh:
                    Nosh()
                case .pantry:
                    Pantry()
                case .profile:
                    Profile()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            
            // Custom Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            if tab == .nosh && selectedTab == .nosh {
                                selectedTab = .home
                            } else {
                                selectedTab = tab
                            }
                        }
                    }
                    label: {
                        VStack {
                            if tab == .nosh {
                                ZStack {
                                    Circle()
                                        .fill(Color("primaryAccent"))
                                        .frame(width: 40, height: 40)

                                    Group {
                                        if selectedTab == .nosh {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                                .transition(.scale)
                                        } else {
                                            Image(tab.iconName)
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                                .transition(.scale)
                                        }
                                    }
                                }
                                .scaleEffect(1.5)
                                .padding(.horizontal)
                            } else {
                                Image(tab.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(selectedTab == tab ? Color("iconPrimary") : Color("iconSecondary"))
                                    .opacity(selectedTab == tab ? 1.0 : 0.5)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .background(
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea(edges: .bottom)
//                    Color("tabBarBackground")
//                        .ignoresSafeArea(edges: .bottom)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 5)
                        .ignoresSafeArea(edges: .bottom)
                }
            )
        }
    }
}

// Uncomment when previewing:
#Preview {
    TabView()
}
