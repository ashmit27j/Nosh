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
                    VStack(spacing: 16) {
                        ForEach(0..<30) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .secondarySystemBackground))
                                .frame(height: 80)
                                .overlay(Text("Item \(i)").foregroundColor(.primary))
                        }
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
            //MARK: new addition
//            .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Search Bar with Filter Icon
struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .textFieldStyle(PlainTextFieldStyle())
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            // 🔍 Your custom filter icon from assets
            Image("filterIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Scroll Offset Tracker
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
