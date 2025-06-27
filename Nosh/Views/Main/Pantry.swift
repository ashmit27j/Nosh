//import SwiftUI
//
//struct Pantry: View {
//    @State private var searchText = ""
//    @State private var isEditing = false
//    @State private var selectedTab = "All"
//    @State private var showCollapsedTitle = false
//
//    let tabs = ["All", "Fruits", "Veggies", "Snacks", "Drinks", "Others"]
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
//                        // Space for search and tab bar to stick
////                        Color.clear.frame(height: 120)
//
//                        // Example item grid
//                        ForEach(0..<30) { i in
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color(uiColor: .secondarySystemBackground))
//                                .frame(height: 80)
//                                .overlay(Text("\(selectedTab) Item \(i)").foregroundColor(.primary))
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 20)
//                }
//                .coordinateSpace(name: "scroll")
//                .onPreferenceChange(ScrollOffsetKey.self) { offset in
//                    withAnimation(.easeInOut(duration: 0.25)) {
//                        showCollapsedTitle = offset < -20
//                    }
//                }
//
//                // Sticky Header: Title + Search + Tabs
//                VStack(spacing: 8) {
//                    if showCollapsedTitle {
//                        Text("Pantry")
//                            .font(.headline)
//                            .transition(.opacity)
//                    }
//
//                    // Search + Cancel
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
//                    // Horizontal Tab Bar
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 20) {
//                            ForEach(tabs, id: \.self) { tab in
//                                VStack(spacing: 4) {
//                                    Button(action: {
//                                        selectedTab = tab
//                                    }) {
//                                        Text(tab)
//                                            .fontWeight(selectedTab == tab ? .semibold : .regular)
//                                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
//                                    }
//
//                                    if selectedTab == tab {
//                                        Capsule()
//                                            .frame(height: 2)
//                                            .foregroundColor(Color("primaryAccent"))
//                                            .matchedGeometryEffect(id: "underline", in: Namespace().wrappedValue)
//                                    } else {
//                                        Capsule()
//                                            .frame(height: 2)
//                                            .foregroundColor(.clear)
//                                    }
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
////                .padding(.top, 20)
//                .padding()
//                .background(.ultraThinMaterial)
//            }
//            
//            .navigationTitle("Pantry")
//            .navigationBarTitleDisplayMode(.large)
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

    let tabs = ["All", "Vegetables", "Fruits", "Dairy", "Spices", "Condiments", "Oils", "Instant", "Drinks"]

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
                        ForEach(0..<30) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .secondarySystemBackground))
                                .frame(height: 80)
                                .padding(.leading, 0)
                                .overlay(Text("\(selectedTab) Item \(i)").foregroundColor(.primary))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 120) // leave space for sticky header
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

                    // Tab Bar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(tabs, id: \.self) { tab in
                                VStack(spacing: 2) { //here spacing daala
                                    Button(action: {
                                        selectedTab = tab
                                    }) {
                                        Text(tab)
                                            .fontWeight(selectedTab == tab ? .semibold : .regular)
                                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                            .padding(.top, 10) // Push text up slightly was 2 before
//                                            .padding(.leading, 0)
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
}

