#warning("could be final")
import SwiftUI

struct Home: View {
    //home button vars
    @State private var showRandomDish = false
    @State private var randomMeal: MealItem? = nil

    //other vars
    @State private var searchText = ""
    @State private var showCollapsedTitle = false
    @State private var isEditing = false
    @State private var selectedCategory: String? = ""
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"
    let viewModel: MealPlannerViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("primaryBackground")
                    .ignoresSafeArea()

                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    
                    VStack(spacing: 20) {
                        AiChefSection()
                            .padding(.horizontal, 16)

                        QuickBitesSection(selectedCategory: $selectedCategory)
                            .padding(.horizontal, 16)

                        HomeButtons(showRandomDish: $showRandomDish)
                        
                        Rectangle()
                            .fill(Color("secondaryBackground"))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(100)
                            .padding(.horizontal, 16)

                        UpcomingMealsSection()
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 100)
                    #warning("this is the thing that pushes all content down by 100 pixels")
                }
                .scrollIndicators(.hidden)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        SearchBar(text: $searchText, isEditing: $isEditing)

                        if isEditing {
                            Button("Cancel") {
                                searchText = ""
                                isEditing = false
                                UIApplication.shared.sendAction(
                                    #selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil
                                )
                            }
                            .foregroundColor(.accentColor)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: isEditing)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showRandomDish) {
                if let meal = randomMeal {
                    RandomDishSheet(meal: meal) {
                        randomMeal = viewModel.generateRandomMeal()
                    }
                }
            }
            .onChange(of: showRandomDish) { show in
                if show {
                    randomMeal = viewModel.generateRandomMeal()
                }
            }
        }
        .id(showCollapsedTitle)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#warning("version 2")
//import SwiftUI
//
//struct Home: View {
//    // home button vars
//    @State private var showRandomDish = false
//    @State private var randomMeal: MealItem? = nil
//
//    // other vars
//    @State private var searchText = ""
//    @State private var showCollapsedTitle = false
//    @State private var isEditing = false
//    @State private var selectedCategory: String? = ""
//    @State private var portionSize: Int = 1
//    @State private var timeToCook: Double = 45
//    @State private var selectedDifficulty: String? = "Beginner"
//
//    let viewModel: MealPlannerViewModel
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//                Color("primaryBackground")
//                    .ignoresSafeArea()
//
//                ScrollView {
//                    GeometryReader { geo in
//                        Color.clear
//                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
//                    }
//                    .frame(height: 0)
//
//                    VStack(spacing: 20) {
//                        // Custom large title only shown when not collapsed
//                        if !showCollapsedTitle {
//                            Text("Welcome User")
//                                .font(.largeTitle.bold())
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.horizontal, 16)
//                                .transition(.opacity)
//                        }
//
//                        AiChefSection()
//                            .padding(.horizontal, 16)
//
//                        QuickBitesSection(selectedCategory: $selectedCategory)
//                            .padding(.horizontal, 16)
//
//                        HomeButtons(showRandomDish: $showRandomDish)
//
//                        Rectangle()
//                            .fill(Color("secondaryBackground"))
//                            .frame(height: 4)
//                            .frame(maxWidth: .infinity)
//                            .cornerRadius(100)
//                            .padding(.horizontal, 16)
//
//                        UpcomingMealsSection()
//                            .padding(.horizontal, 16)
//                    }
//                    .padding(.top, 100)
//                    .padding(.bottom, 100)
//                }
//                .scrollIndicators(.hidden)
//                .coordinateSpace(name: "scroll")
//                .onPreferenceChange(ScrollOffsetKey.self) { offset in
//                    withAnimation(.easeInOut(duration: 0.25)) {
//                        showCollapsedTitle = offset < -20
//                    }
//                }
//
//                // Floating Search Bar with Cancel
//                VStack(spacing: 8) {
//                    HStack(spacing: 8) {
//                        SearchBar(text: $searchText, isEditing: $isEditing)
//
//                        if isEditing {
//                            Button("Cancel") {
//                                searchText = ""
//                                isEditing = false
//                                UIApplication.shared.sendAction(
//                                    #selector(UIResponder.resignFirstResponder),
//                                    to: nil, from: nil, for: nil
//                                )
//                            }
//                            .foregroundColor(.accentColor)
//                            .transition(.opacity.combined(with: .move(edge: .trailing)))
//                        }
//                    }
//                    .animation(.easeInOut(duration: 0.25), value: isEditing)
//                    .padding(.horizontal)
//                }
//                .padding(.top, 20)
//                .padding(.bottom, 20)
//                .background(Color("primaryCard"))
//            }
//
//            // ✅ Keep a static title for clean back navigation
//            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar(.hidden, for: .navigationBar)
//
//            // Sheet to show a random meal
//            .sheet(isPresented: $showRandomDish) {
//                if let meal = randomMeal {
//                    RandomDishSheet(meal: meal) {
//                        randomMeal = viewModel.generateRandomMeal()
//                    }
//                }
//            }
//
//            .onChange(of: showRandomDish) { show in
//                if show {
//                    randomMeal = viewModel.generateRandomMeal()
//                }
//            }
//        }
//        .id(showCollapsedTitle) // Force refresh on collapse change
//    }
//}
//
//struct ScrollOffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}


#warning("v3")
//import SwiftUI
//
//struct Home: View {
//    // home button vars
//    @State private var showRandomDish = false
//    @State private var randomMeal: MealItem? = nil
//
//    // other vars
//    @State private var searchText = ""
//    @State private var showCollapsedTitle = false
//    @State private var isEditing = false
//    @State private var selectedCategory: String? = ""
//    @State private var portionSize: Int = 1
//    @State private var timeToCook: Double = 45
//    @State private var selectedDifficulty: String? = "Beginner"
//
//    let viewModel: MealPlannerViewModel
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//                Color("primaryBackground").ignoresSafeArea()
//
//                ScrollView {
//                    GeometryReader { geo in
//                        Color.clear
//                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
//                    }
//                    .frame(height: 0)
//
//                    VStack(spacing: 20) {
//                        // ⬇️ Content sections
//                        AiChefSection().padding(.horizontal, 16)
//                        QuickBitesSection(selectedCategory: $selectedCategory).padding(.horizontal, 16)
//                        HomeButtons(showRandomDish: $showRandomDish)
//
//                        Rectangle()
//                            .fill(Color("secondaryBackground"))
//                            .frame(height: 4)
//                            .frame(maxWidth: .infinity)
//                            .cornerRadius(100)
//                            .padding(.horizontal, 16)
//
//                        UpcomingMealsSection().padding(.horizontal, 16)
//                    }
//                    .padding(.top, 160) // Enough space for header
//                    .padding(.bottom, 100)
//                }
//                .coordinateSpace(name: "scroll")
//                .scrollIndicators(.hidden)
//                .onPreferenceChange(ScrollOffsetKey.self) { offset in
//                    withAnimation(.easeInOut(duration: 0.25)) {
//                        showCollapsedTitle = offset < -20
//                    }
//                }
//
//                // ✅ Floating header
//                VStack(spacing: 8) {
//                    Text("Welcome User")
//                        .font(.largeTitle.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//                        .opacity(showCollapsedTitle ? 0 : 1)
//                        .frame(height: showCollapsedTitle ? 0 : nil)
//                        .animation(.easeInOut(duration: 0.25), value: showCollapsedTitle)
//
//                    HStack(spacing: 8) {
//                        SearchBar(text: $searchText, isEditing: $isEditing)
//
//                        if isEditing {
//                            Button("Cancel") {
//                                searchText = ""
//                                isEditing = false
//                                UIApplication.shared.sendAction(
//                                    #selector(UIResponder.resignFirstResponder),
//                                    to: nil, from: nil, for: nil
//                                )
//                            }
//                            .foregroundColor(.accentColor)
//                            .transition(.opacity.combined(with: .move(edge: .trailing)))
//                        }
//                    }
//                    .animation(.easeInOut(duration: 0.25), value: isEditing)
//                    .padding(.horizontal)
//                }
//                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44 + 12)
//                .padding(.bottom, 20)
//                .background(.ultraThinMaterial)
//                .ignoresSafeArea(edges: .top)
//            }
//            // 👇 Navbar title shown only after scroll collapse
//            .navigationTitle(showCollapsedTitle ? "Home" : "")
//            .navigationBarTitleDisplayMode(.inline)
//
//            // 👇 Sheet for random meal
//            .sheet(isPresented: $showRandomDish) {
//                if let meal = randomMeal {
//                    RandomDishSheet(meal: meal) {
//                        randomMeal = viewModel.generateRandomMeal()
//                    }
//                }
//            }
//            .onChange(of: showRandomDish) { show in
//                if show {
//                    randomMeal = viewModel.generateRandomMeal()
//                }
//            }
//        }
//        .id(showCollapsedTitle) // Force view refresh when title collapse state changes
//    }
//}
//
//struct ScrollOffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}


//import SwiftUI
//
//struct HomeView: View {
//    let viewModel: MealPlannerViewModel
//    var body: some View {
//        Home(viewModel: viewModel)
//    }
//}
//
//struct Home: View {
//    @State private var scrollOffset: CGFloat = 0
//    @State private var isEditing = false
//    @State private var searchText = ""
//    let viewModel: MealPlannerViewModel
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                GeometryReader { geo in
//                    Color.clear
//                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
//                }
//                .frame(height: 0)
//
//                VStack(spacing: 24) {
//                    // 🔽 Collapsing Search Area
//                    VStack(spacing: 8) {
//                        SearchBar(text: $searchText, isEditing: $isEditing)
//
//                        if isEditing {
//                            Button("Cancel") {
//                                searchText = ""
//                                isEditing = false
//                                UIApplication.shared.sendAction(
//                                    #selector(UIResponder.resignFirstResponder),
//                                    to: nil, from: nil, for: nil
//                                )
//                            }
//                            .foregroundColor(.accentColor)
//                            .transition(.opacity.combined(with: .move(edge: .trailing)))
//                        }
//                    }
//                    .offset(y: max(0, 100 - scrollOffset))
//                    .opacity(Double(max(0, 100 - scrollOffset)) / 100)
//                    .animation(.easeInOut(duration: 0.25), value: scrollOffset)
//
//                    // 📦 Fake sections
//                    ForEach(1...10, id: \.self) { i in
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color("primaryCard"))
//                            .frame(height: 150)
//                            .overlay(Text("Section \(i)").bold().foregroundColor(.white))
//                            .padding(.horizontal)
//                    }
//                }
//                .padding(.top, 16)
//            }
//            .coordinateSpace(name: "scroll")
//            .onPreferenceChange(ScrollOffsetKey.self) { value in
//                scrollOffset = value
//            }
//            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//// MARK: - Scroll Offset PreferenceKey
//struct ScrollOffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
