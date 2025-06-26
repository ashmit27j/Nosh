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
            // Content view based on selected tab
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
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
            .ignoresSafeArea()

            // Custom Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack {
                            Image(tab.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: selectedTab == tab ? 28 : 24, height: selectedTab == tab ? 28 : 24)
                                .opacity(selectedTab == tab ? 1.0 : 0.6)
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 6, height: 6)
                                    .transition(.scale)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 5)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}

#Preview {
    TabView()
}
