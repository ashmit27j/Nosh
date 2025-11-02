import SwiftUI

struct ShoppingListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PantryViewModel
    @State private var checkedItems: Set<UUID> = []
    @State private var quantities: [UUID: Double] = [:]
    
    private var itemsToShop: [PantryItem] {
        viewModel.items.values.flatMap { $0 }.filter { $0.quantity < 5 }
    }
    
    private var allChecked: Bool {
        itemsToShop.allSatisfy { checkedItems.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(itemsToShop) { item in
                        HStack {
                            Button {
                                if checkedItems.contains(item.id) {
                                    checkedItems.remove(item.id)
                                } else {
                                    checkedItems.insert(item.id)
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: checkedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(checkedItems.contains(item.id) ? Color("primaryAccent") : Color("secondaryText"))
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .foregroundColor(Color("primaryText"))
                                        Text("Current: \(String(format: "%.1f", item.quantity))")
                                            .font(.caption)
                                            .foregroundColor(Color("secondaryText"))
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Button {
                                            let current = quantities[item.id] ?? 0
                                            if current >= item.incrementBy {
                                                quantities[item.id] = current - item.incrementBy
                                            }
                                        } label: {
                                            Image(systemName: "minus")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color("secondaryText"))
                                                .frame(width: 20, height: 20)
                                        }
                                        
                                        Text(String(format: "%.1f", quantities[item.id] ?? 0))
                                            .frame(width: 40)
                                            .foregroundColor(Color("primaryText"))
                                        
                                        Button {
                                            let current = quantities[item.id] ?? 0
                                            quantities[item.id] = current + item.incrementBy
                                        } label: {
                                            Image(systemName: "plus")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color("secondaryText"))
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding(4)
                                    .background(Color("secondaryButton").opacity(0.7))
                                    .cornerRadius(20)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                if allChecked && !itemsToShop.isEmpty {
                    Button {
                        logItems()
                    } label: {
                        Text("Log Items")
                            .font(.headline)
                            .foregroundColor(Color("primaryButtonText"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color("primaryAccent"))
                            .cornerRadius(16)
                    }
                    .padding()
                }
            }
            .navigationTitle("Shopping List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func logItems() {
        for item in itemsToShop where checkedItems.contains(item.id) {
            let category = viewModel.findCategory(for: item)
            let additionalQuantity = quantities[item.id] ?? 0
            if var list = viewModel.items[category],
               let index = list.firstIndex(where: { $0.id == item.id }) {
                list[index].quantity += additionalQuantity
                viewModel.items[category] = list
            }
        }
        viewModel.refresh()
        dismiss()
    }
}
