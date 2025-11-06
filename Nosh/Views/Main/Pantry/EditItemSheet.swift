import SwiftUI

struct EditItemSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var itemName: String
    @Binding var quantity: Double
    @Binding var incrementBy: Double
    let item: PantryItem
    let category: String
    @ObservedObject var viewModel: PantryViewModel

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
                        .buttonStyle(.borderless) // Fix

                        Text(String(format: "%.1f", quantity))
                            .frame(width: 50)

                        Button {
                            quantity += incrementBy
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                        .buttonStyle(.borderless) // Fix
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
                        .buttonStyle(.borderless) // Fix

                        Text(String(format: "%.1f", incrementBy))
                            .frame(width: 50)

                        Button {
                            incrementBy += 0.1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("primaryAccent"))
                        }
                        .buttonStyle(.borderless) // Fix
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
