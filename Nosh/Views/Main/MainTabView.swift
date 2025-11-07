import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home
    @State private var isAiChefActive = false
    @State private var shouldGoToPantry = false

    @StateObject private var mealPlannerViewModel = MealPlannerViewModel()
    @StateObject private var pantryViewModel = PantryViewModel(tabs: [
        "All", "Grains & Flours", "Baking", "Dairy", "Vegetables", "Proteins", "Spices",
        "Oils", "Aromatics", "Herbs", "Sweeteners", "Condiments", "Beverages", "Fruits",
        "Specialty", "Snacks", "Others"
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
            switch selectedTab {
            case .home:
                Home(
                    viewModel: mealPlannerViewModel,
                    onSwitchToMealPlanner: {
                        withAnimation { selectedTab = .mealPlanner }
                    },
                    isAiChefActive: $isAiChefActive
                )
            case .mealPlanner:
                MealPlanner(
                    viewModel: mealPlannerViewModel,
                    onGotoPantry: { shouldGoToPantry = true }
                )
            case .nosh:
                Nosh()
            case .pantry:
                Pantry(viewModel: pantryViewModel)
            case .profile:
                Profile(pantryViewModel: pantryViewModel)
            }

            if !isAiChefActive {
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
                                        .foregroundColor(selectedTab == tab ? Color("primaryIcon") : Color("secondaryIcon"))
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
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 8)
                            .ignoresSafeArea(edges: .bottom)
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .onAppear {
            NotificationManager.shared.scheduleMealNotifications(mealTimes: appState.mealTimes)
            print("MainTabView: Connecting PantryManager to shared pantryViewModel")
            PantryManager.shared.pantryViewModel = pantryViewModel
            pantryViewModel.initializeDefaultPantry()
            print("MainTabView: Loading meal planner data from Firestore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("PantryManager connected: \(PantryManager.shared.pantryViewModel != nil)")
                print("Pantry items count: \(pantryViewModel.items.count)")
                print("MealPlanner initialized for date: \(mealPlannerViewModel.selectedDate)")
            }
        }
        .onChange(of: shouldGoToPantry) { newValue in
            if newValue {
                selectedTab = .pantry
                shouldGoToPantry = false 
            }
        }
    }
}
