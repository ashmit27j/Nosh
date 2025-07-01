import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var sharedViewModel = MealPlannerViewModel(tabs: [
        "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
    ])

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
                    Home(viewModel: sharedViewModel)
                case .mealPlanner:
                    MealPlanner(viewModel: sharedViewModel)
                case .nosh:
                    Nosh()
                case .pantry:
                    Pantry()
                case .profile:
                    Profile()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("primaryBackground")) // ← CHANGE THIS LINE

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
                    } label: {
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
            .padding(.bottom, 40)
            .background(
                ZStack {
                    Color("primaryBackground")
                        .ignoresSafeArea(edges: .bottom)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("primaryCard"))
                        .shadow(radius: 5)
                        .ignoresSafeArea(edges: .bottom)
                }
            )
        }
        
        .ignoresSafeArea()
    }
}

//#Preview {
//    MainTabView()
//}
