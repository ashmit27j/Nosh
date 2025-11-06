//
//  PantryItemCard.swift
//  Nosh
//
//  Created by MacBook on 06/11/25.
//



import SwiftUI

struct PantryItemCard: View {
    let item: PantryItem
    let selectedTab: String
    let viewModel: PantryViewModel
    let onEdit: (PantryItem, String) -> Void

    var category: String {
        selectedTab == "All" ? viewModel.findCategory(for: item) : selectedTab
    }

    private var formattedQuantity: String {
        let value = item.quantity
        let rounded = (value * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", rounded)
        } else {
            return String(format: "%.1f", rounded)
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(color(for: item.quantity))
                .frame(width: 12, height: 60)

            HStack {
                Button {
                    onEdit(item, category)
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

                    Text(formattedQuantity)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .frame(width: 60)
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
    }

    private func color(for quantity: Double) -> Color {
        switch quantity {
        case 5...: return Color("primaryAccent")
        case 1..<5: return Color("pastelYellow")
        default: return Color("secondaryButton")
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
