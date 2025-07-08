import SwiftUI

struct MealPlannerHeader: View {
    @Binding var searchText: String
    @Binding var isEditing: Bool
    @Binding var selectedTab: String
    let tabs: [String]
    var underlineNamespace: Namespace.ID

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Title and Calendar Button
            HStack(alignment: .center) {
                Text("Schedule")
                    .font(.largeTitle.bold())
                    .transition(.opacity)

                Spacer()

                Button {
                    print("Calendar tapped")
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
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
            .padding(.top, 0)
            .transition(.opacity)

            // MARK: - Search Bar
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
            .padding(.top, 8) // ✅ Add top padding to separate from the title row
            .animation(.easeInOut(duration: 0.25), value: isEditing)

            // MARK: - Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(tabs, id: \.self) { tab in
                        VStack(spacing: 2) {
                            Button {
                                selectedTab = tab
                            } label: {
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
}
