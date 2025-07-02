import SwiftUI

struct Pantry: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "All"
    @State private var showCollapsedTitle = false

    @Namespace private var underlineNamespace
    @StateObject private var viewModel = PantryViewModel(tabs: [
        "All", "Vegetables", "Fruits", "Dairy", "Spices", "Condiments", "Oils", "Instant", "Drinks"
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
                                HStack(spacing: 0) {
                                    //MARK: left hand side item color indicator for stock
                                    Rectangle()
                                        .fill(color(for: item.quantity))
                                        .frame(width: 12, height: 60)
                                    //MARK: alignment of the other content in card
                                    HStack {
                                        //Item name
                                        Text(item.name)
                                            .foregroundColor(item.quantity == 0 ? Color("buttonSecondary") : Color("primaryText"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 2)
                                        
                                        //MARK: Buttons Div
                                        HStack(spacing: 4) {
                                            Button(action: {
                                                viewModel.decrement(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                                            }) {
                                                Image(systemName: "minus")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(Color("secondaryText"))
                                                    .frame(width: 20, height: 20)
//                                                    .overlay(
//                                                        RoundedRectangle(cornerRadius: 4)
//                                                            .stroke(Color("primaryOutline"), lineWidth: 1)
//                                                    )
                                            }

                                            Text("\(item.quantity)")
                                                .frame(width: 24)
                                                .foregroundColor(Color("primaryText"))

                                            Button(action: {
                                                viewModel.increment(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                                            }) {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(Color("secondaryText"))
                                                    .frame(width: 20, height: 20)
//                                                    .overlay(
//                                                        RoundedRectangle(cornerRadius: 4)
//                                                            .stroke(Color("primaryOutli"ne"), lineWidth: 1)
//                                                    )
                                            }
                                        }
                                        .padding(4)
                                        .background(Color("buttonSecondary").opacity(item.quantity == 0 ? 0.5 : 0.7))
                                        .cornerRadius(20)

                                        
                                    }
                                    .padding()
                                    .frame(minHeight: 60)
                                    .background(Color("primaryCard"))
                                }
                                .cornerRadius(12)
                            }

                            AddItemButton(
                                category: selectedTab == "All" ? "Vegetables" : selectedTab,
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.horizontal)
                    // space for sticky header
                    .padding(.top, 130)
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
                        .padding(.horizontal, 2)
                    }
                }
                .padding()
                .background(Color("primaryCard"))
            }
            .navigationTitle("Pantry")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("primaryBackground"))
        }
    }

    private func color(for quantity: Int) -> Color {
        switch quantity {
        case 5...: return Color("primaryAccent")
        case 1...4: return Color("pastelYellow")
        default: return Color("buttonSecondary")
        }
    }
}
