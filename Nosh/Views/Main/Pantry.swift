//import SwiftUI
//
//struct Pantry: View {
//    @State private var searchText = ""
//    @State private var isEditing = false
//    @State private var selectedTab = "All"
//    @State private var showCollapsedTitle = false
//
//    @Namespace private var underlineNamespace
//    @StateObject private var viewModel = PantryViewModel(tabs: [
//        "All", "Vegetables", "Fruits", "Dairy", "Spices", "Condiments", "Oils", "Instant", "Drinks"
//    ])
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//                ScrollView {
//                    GeometryReader { geo in
//                        Color.clear
//                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
//                    }
//                    .frame(height: 0)
//
//                    VStack(spacing: 16) {
//                        if let currentItems = viewModel.items[selectedTab == "All" ? "All" : selectedTab] {
//                            ForEach(currentItems, id: \ .id) { item in
//                                HStack(spacing: 0) {
//                                    Rectangle()
//                                        .fill(color(for: item.quantity))
//                                        .frame(width: 6)
//
//                                    HStack {
//                                        Text(item.name)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                                        HStack(spacing: 8) {
//                                            Button(action: {
//                                                viewModel.decrement(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
//                                            }) {
//                                                Image(systemName: "minus")
//                                                    .font(.system(size: 14, weight: .bold))
//                                                    .foregroundColor(.primary)
//                                                    .frame(width: 24, height: 24)
//                                                    .overlay(
//                                                        RoundedRectangle(cornerRadius: 4)
//                                                            .stroke(Color("primaryOutline"), lineWidth: 1)
//                                                    )
//                                            }
//
//                                            Text("\(item.quantity)")
//                                                .frame(width: 24)
//
//                                            Button(action: {
//                                                viewModel.increment(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
//                                            }) {
//                                                Image(systemName: "plus")
//                                                    .font(.system(size: 14, weight: .bold))
//                                                    .foregroundColor(.primary)
//                                                    .frame(width: 24, height: 24)
//                                                    .overlay(
//                                                        RoundedRectangle(cornerRadius: 4)
//                                                            .stroke(Color("primaryOutline"), lineWidth: 1)
//                                                    )
//                                            }
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color(uiColor: .secondarySystemBackground))
//                                    .cornerRadius(12)
//                                }
//                            }
//
//                            AddItemButton(
//                                category: selectedTab == "All" ? "Vegetables" : selectedTab,
//                                viewModel: viewModel
//                            )
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 120) // space for sticky header
//                }
//                .coordinateSpace(name: "scroll")
//                .onPreferenceChange(ScrollOffsetKey.self) { offset in
//                    withAnimation(.easeInOut(duration: 0.25)) {
//                        showCollapsedTitle = offset < -20
//                    }
//                }
//
//                // Sticky Header
//                VStack(spacing: 8) {
//                    if showCollapsedTitle {
//                        Text("Pantry")
//                            .font(.headline)
//                            .transition(.opacity)
//                    }
//
//                    HStack(spacing: 8) {
//                        SearchBar(text: $searchText, isEditing: $isEditing)
//
//                        if isEditing {
//                            Button("Cancel") {
//                                searchText = ""
//                                isEditing = false
//                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                            }
//                            .foregroundColor(.accentColor)
//                            .transition(.opacity.combined(with: .move(edge: .trailing)))
//                        }
//                    }
//                    .animation(.easeInOut(duration: 0.25), value: isEditing)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 20) {
//                            ForEach(viewModel.tabs, id: \ .self) { tab in
//                                VStack(spacing: 2) {
//                                    Button(action: {
//                                        selectedTab = tab
//                                    }) {
//                                        Text(tab)
//                                            .fontWeight(selectedTab == tab ? .semibold : .regular)
//                                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
//                                            .padding(.top, 10)
//                                    }
//
//                                    Capsule()
//                                        .frame(height: 3)
//                                        .foregroundColor(selectedTab == tab ? Color("primaryAccent") : .clear)
//                                        .matchedGeometryEffect(id: "underline", in: underlineNamespace, isSource: selectedTab == tab)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//                .padding()
//                .background(.ultraThinMaterial)
//            }
//            .navigationTitle("Pantry")
//            .navigationBarTitleDisplayMode(.large)
//        }
//    }
//
//    private func color(for quantity: Int) -> Color {
//        switch quantity {
//        case 4...: return .green
//        case 2...3: return .yellow
//        default: return .red
//        }
//    }
//}


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
                            ForEach(currentItems, id: \ .id) { item in
                                HStack(spacing: 0) {
                                    HStack {
                                        Rectangle()
                                            .fill(color(for: item.quantity))
                                            .frame(width: 8, height: 8)
                                            .cornerRadius(12)

                                        Text(item.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 2)

                                        HStack(spacing: 8) {
                                            Button(action: {
                                                viewModel.decrement(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                                            }) {
                                                Image(systemName: "minus")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.primary)
                                                    .frame(width: 24, height: 24)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .stroke(Color("primaryOutline"), lineWidth: 1)
                                                    )
                                            }

                                            Text("\(item.quantity)")
                                                .frame(width: 24)

                                            Button(action: {
                                                viewModel.increment(item, in: selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab)
                                            }) {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.primary)
                                                    .frame(width: 24, height: 24)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .stroke(Color("primaryOutline"), lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }

                            AddItemButton(
                                category: selectedTab == "All" ? "Vegetables" : selectedTab,
                                viewModel: viewModel
                            )
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
                            ForEach(viewModel.tabs, id: \ .self) { tab in
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
            .navigationTitle("Pantry")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func color(for quantity: Int) -> Color {
        switch quantity {
        case 4...: return .green
        case 2...3: return .yellow
        default: return .red
        }
    }
}
