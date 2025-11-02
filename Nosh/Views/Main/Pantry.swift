import SwiftUI

struct Pantry: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "All"
    @State private var showAddItemSheet = false
    @State private var showShoppingList = false

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
            .overlay(
                refreshButton
                    .padding(.bottom, 100)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            )
            .sheet(isPresented: $showAddItemSheet) {
                AddItemSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $showShoppingList) {
                ShoppingListView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadPantry()
            }
        }
    }

    private var ScrollContent: some View {
        List {
            if let currentItems = viewModel.items[selectedTab == "All" ? "All" : selectedTab] {
                ForEach(currentItems, id: \.id) { item in
                    PantryItemCard(item: item, selectedTab: selectedTab, viewModel: viewModel)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                
                AddItemButton(
                    category: selectedTab == "All" ? "Vegetables" : selectedTab,
                    showAddItemSheet: $showAddItemSheet
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .padding(.top, 188)
    }

    private var Header: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("Pantry")
                    .font(.largeTitle.bold())
                    .transition(.opacity)

                Spacer()

                Button {
                    showShoppingList = true
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

    private var refreshButton: some View {
        Button {
            viewModel.refresh()
        } label: {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color("primaryAccent"))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
        }
    }
}

struct AddItemButton: View {
    let category: String
    @Binding var showAddItemSheet: Bool
    
    var body: some View {
        Button {
            showAddItemSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("primaryAccent"))
                Text("Add New Item")
                    .foregroundColor(Color("primaryText"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("primaryCard"))
            .cornerRadius(12)
        }
    }
}

struct PantryItemCard: View {
    let item: PantryItem
    let selectedTab: String
    let viewModel: PantryViewModel
    @State private var showEditSheet = false
    
    var category: String {
        selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(color(for: item.quantity))
                .frame(width: 12, height: 60)

            HStack {
                Button {
                    showEditSheet = true
                } label: {
                    Text(item.name)
                        .foregroundColor(item.quantity == 0 ? Color("secondaryButton") : Color("primaryText"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 2)
                }
                .buttonStyle(.plain)

                HStack(spacing: 4) {
                    Button {
                        viewModel.decrement(item, in: category)
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("secondaryText"))
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)

                    Text(String(format: "%.1f", item.quantity))
                        .frame(width: 40)
                        .foregroundColor(Color("primaryText"))

                    Button {
                        viewModel.increment(item, in: category)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("secondaryText"))
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
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
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteItem(item, from: category)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditItemSheet(item: item, category: category, viewModel: viewModel)
        }
    }

    private func color(for quantity: Double) -> Color {
        switch quantity {
        case 5...: return Color("primaryAccent")
        case 1..<5: return Color("pastelYellow")
        default: return Color("secondaryButton")
        }
    }
}
