import SwiftUI

struct EditItemSheet: View {
    @Environment(\.dismiss) var dismiss
    let item: PantryItem
    let category: String
    @ObservedObject var viewModel: PantryViewModel
    
    @State private var itemName: String
    @State private var quantity: Double
    @State private var incrementBy: Double
    
    init(item: PantryItem, category: String, viewModel: PantryViewModel) {
        self.item = item
        self.category = category
        self.viewModel = viewModel
        _itemName = State(initialValue: item.name)
        _quantity = State(initialValue: item.quantity)
        _incrementBy = State(initialValue: item.incrementBy)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    TextField("Item Name", text: $itemName)
                }
                
                Section("Quantity") {
                    HStack {
                        Text("Current")
                        Spacer()
                        Button {
                            if quantity >= incrementBy {
                                quantity -= incrementBy
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                        
                        Text(String(format: "%.1f", quantity))
                            .frame(width: 50)
                        
                        Button {
                            quantity += incrementBy
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                    }
                }
                
                Section("Increment/Decrement By") {
                    HStack {
                        Text("Step")
                        Spacer()
                        Button {
                            if incrementBy > 0.1 {
                                incrementBy -= 0.1
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                        
                        Text(String(format: "%.1f", incrementBy))
                            .frame(width: 50)
                        
                        Button {
                            incrementBy += 0.1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                    }
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.updateItem(item, in: category, name: itemName, quantity: quantity, incrementBy: incrementBy)
                        dismiss()
                    }
                    .disabled(itemName.isEmpty)
                }
            }
        }
    }
}
