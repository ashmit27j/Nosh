import SwiftUI

struct Pantry: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "All"
    @State private var showAddItemSheet = false
    @State private var showShoppingList = false

    @State private var editingItem: PantryItem? = nil
    @State private var editingItemName: String = ""
    @State private var editingQuantity: Double = 1.0
    @State private var editingIncrementBy: Double = 0.5
    @State private var editingCategory: String? = nil

    @Namespace private var underlineNamespace
    @ObservedObject var viewModel: PantryViewModel

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
            .sheet(item: $editingItem) { item in
                EditItemSheet(
                    itemName: $editingItemName,
                    quantity: $editingQuantity,
                    incrementBy: $editingIncrementBy,
                    item: item,
                    category: editingCategory ?? "All",
                    viewModel: viewModel
                )
            }
            .onAppear {
                viewModel.initializeDefaultPantry()
                PantryManager.shared.pantryViewModel = viewModel
                print("🔗 PantryManager connected: \(PantryManager.shared.pantryViewModel != nil)")
                print("🔗 Pantry items count: \(viewModel.items.count)")
            }
        }
    }

    private var ScrollContent: some View {
        List {
            if let currentItems = viewModel.items[selectedTab == "All" ? "All" : selectedTab] {
                ForEach(currentItems, id: \.id) { item in
                    PantryItemCard(
                        item: item,
                        selectedTab: selectedTab,
                        viewModel: viewModel,
                        onEdit: {
                            tappedItem, category in
                                    editingItem = tappedItem
                                    editingCategory = category
                                    editingItemName = tappedItem.name
                                    editingQuantity = tappedItem.quantity
                                    editingIncrementBy = tappedItem.incrementBy
                        }
                    )
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
                
//                VerticalSpacerCoverNavbar()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .padding(.top, 188)
        .padding(.bottom, 100x)
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



