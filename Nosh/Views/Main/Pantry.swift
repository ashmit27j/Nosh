import SwiftUI

struct Pantry: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "All"

    @Namespace private var underlineNamespace
    @StateObject private var viewModel = PantryViewModel(tabs: [
        "All", "Vegetables", "Fruits", "Dairy", "Spices", "Condiments", "Oils", "Instant", "Drinks"
    ])

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollContent
                Header
            }
            .background(Color("primaryBackground"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var ScrollContent: some View {
        ScrollView {
            GeometryReader { geo in
                Color.clear
                    .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
            }
            .frame(height: 0)

            LazyVStack(spacing: 16) {
                if let currentItems = viewModel.items[selectedTab == "All" ? "All" : selectedTab] {
                    ForEach(currentItems, id: \ .id) { item in
                        PantryItemCard(item: item, selectedTab: selectedTab, viewModel: viewModel)
                    }

                    AddItemButton(
                        category: selectedTab == "All" ? "Vegetables" : selectedTab,
                        viewModel: viewModel
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 188)
            .animation(.default, value: viewModel.items)
        }
        .scrollIndicators(.hidden)
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value
        }
    }

    private var Header: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("Pantry")
                    .font(.largeTitle.bold())
                    .transition(.opacity)

                Spacer()

                Button {
                    print("Add tapped")
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "cart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color("secondaryAccent"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color("primaryAccent"))
                    .cornerRadius(16)
                }
            }

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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.tabs, id: \.self) { tab in
                        VStack(spacing: 2) {
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .fontWeight(selectedTab == tab ? .semibold : .regular)
                                    .foregroundColor(selectedTab == tab ? .primary : .secondary)
//                                    .padding(.top, 0)
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
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color("primaryCard"))
        .animation(.easeInOut(duration: 0.3), value: scrollOffset)
    }


    private func color(for quantity: Int) -> Color {
        switch quantity {
        case 5...: return Color("primaryAccent")
        case 1...4: return Color("pastelYellow")
        default: return Color("secondaryButton")
        }
    }
}

struct PantryItemCard: View {
    let item: PantryItem
    let selectedTab: String
    let viewModel: PantryViewModel
    var category: String {
        selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab
    }
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(color(for: item.quantity))
                .frame(width: 12, height: 60)

            HStack {
                Text(item.name)
                    .foregroundColor(item.quantity == 0 ? Color("secondaryButton") : Color("primaryText"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 2)

                HStack(spacing: 4) {
                    Button {
                        viewModel.decrement(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("secondaryText"))
                            .frame(width: 20, height: 20)
                    }

                    Text("\(item.quantity)")
                        .frame(width: 24)
                        .foregroundColor(Color("primaryText"))

                    Button {
                        viewModel.increment(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("secondaryText"))
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(4)
                .background(Color("secondaryButton").opacity(item.quantity == 0 ? 0.5 : 0.7))
                .cornerRadius(20)
            }
            .padding()
            .frame(minHeight: 60)
            .background(Color("primaryCard"))
        }
        .cornerRadius(12)
    }

    private func color(for quantity: Int) -> Color {
        switch quantity {
        case 5...: return Color("primaryAccent")
        case 1...4: return Color("pastelYellow")
        default: return Color("secondaryButton")
        }
    }
}

