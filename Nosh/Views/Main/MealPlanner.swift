import SwiftUI

struct MealPlanner: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "All"
    @State private var showCollapsedTitle = false

    @Namespace private var underlineNamespace
    @StateObject private var viewModel = MealPlannerViewModel(tabs: [
        "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
    ])


    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)

                    VStack(spacing: 16) {
                        if let currentItems = viewModel.items[selectedTab == "All" ? "All" : selectedTab] {
                            ForEach(currentItems, id: \.id) { item in
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 130) // space for sticky header
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }

                // Sticky Header
                VStack(spacing: 8) {
                    if showCollapsedTitle {
                        Text("Pantry")
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
                            .foregroundColor(.accentColor)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: isEditing)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.tabs, id: \.self) { tab in
                                VStack(spacing: 2) {
                                    Button(action: {
                                        selectedTab = tab
                                    }) {
                                        Text(tab)
                                            .fontWeight(selectedTab == tab ? .semibold : .regular)
                                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                            .padding(.top, 10)
                                    }

                                    Capsule()
                                        .frame(height: 3)
                                        .foregroundColor(selectedTab == tab ? Color("primaryAccent") : .clear)
                                        .matchedGeometryEffect(id: "underline", in: underlineNamespace, isSource: selectedTab == tab)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Meal Planner")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
