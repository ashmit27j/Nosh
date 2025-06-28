import SwiftUI

struct Home: View {
    @State private var searchText = ""
    @State private var showCollapsedTitle = false
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)

                    VStack(spacing: 24) {
                        HomeButtons()

                        // Quick Bites (CategorySelector copied exactly as before)
                        CategorySelector(selectedCategory: .constant("Full Meal"))

                        // Upcoming Meals Horizontal Scroll
                        UpcomingMealsSection()
                    }
                    .padding()
                    .padding(.top, 80)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }

                // Floating search section
                VStack(spacing: 8) {
                    if showCollapsedTitle {
                        Text("Home")
                            .font(.headline)
                            .transition(.opacity)
                    }

                    HStack(spacing: 8) {
                        SearchBar(text: $searchText, isEditing: $isEditing)

                        if isEditing {
                            Button("Cancel") {
                                searchText = ""
                                isEditing = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .foregroundColor(Color.accentColor)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: isEditing)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Welcome User")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


// MARK: - Scroll Offset Tracker
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

