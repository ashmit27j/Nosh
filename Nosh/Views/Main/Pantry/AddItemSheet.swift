//
//  AddItemSheet.swift
//  Nosh
//
//  Created by MacBook on 02/11/25.
//


import SwiftUI

struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PantryViewModel
    
    @State private var itemName = ""
    @State private var unit = ""
    @State private var selectedCategory = "Vegetables"
    @State private var quantity: Double = 1.0
    @State private var incrementBy: Double = 0.5
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    TextField("Item Name", text: $itemName)
                    TextField("Unit (e.g., kg, g, L)", text: $unit)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(viewModel.tabs.filter { $0 != "All" }, id: \.self) { tab in
                            Text(tab).tag(tab)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Quantity") {
                    HStack {
                        Text("Starting Amount")
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
                        Text("Step Size")
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
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let finalName = unit.isEmpty ? itemName : "\(itemName) (\(unit))"
                        viewModel.addItem(name: finalName, category: selectedCategory, quantity: quantity, incrementBy: incrementBy)
                        dismiss()
                    }
                    .disabled(itemName.isEmpty)
                }
            }
        }
    }
}
