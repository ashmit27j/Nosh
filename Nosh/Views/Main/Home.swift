import SwiftUI

struct Home: View {
    @State private var searchText = ""
    @State private var showCollapsedTitle = false

    var body: some View {
        NavigationStack {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)

                VStack(spacing: 16) {
                    // Pinned search bar
                    SearchBar(text: $searchText)

                    // Cards
                    ForEach(0..<20) { i in
                        Text("Card \(i)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { offset in
                // When the scroll offset is < -20, show the collapsed nav title
                withAnimation(.easeInOut(duration: 0.2)) {
                    showCollapsedTitle = offset < -20
                }
            }
            .navigationTitle("Welcome User")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .opacity(showCollapsedTitle ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: showCollapsedTitle)
                        .font(.headline)
                }
            }
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Search Bar View
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Scroll Offset Tracker
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//#Preview {
//    Home()
//}
