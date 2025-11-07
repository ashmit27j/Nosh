//import SwiftUI
//
//struct ShoppingListView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: PantryViewModel
//
//    // Only show understocked items (quantity < 5) by unique id
//    private var itemsToShop: [ShoppingItem] {
//        viewModel.items
//            .filter { $0.key != "All" }
//            .flatMap { (category, items) in
//                items.filter { $0.quantity < 5 }
//                    .map { ShoppingItem(id: $0.id, name: $0.name, category: category, required: max(5 - $0.quantity, 0), incrementBy: $0.incrementBy) }
//            }
//    }
//
//    @State private var userQuantities: [UUID: Double] = [:]
//    @State private var checkedItems: Set<UUID> = []
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color("primaryBackground").ignoresSafeArea()
//                VStack {
//                    List {
//                        ForEach(itemsToShop) { item in
//                            HStack {
//                                Button {
//                                    if checkedItems.contains(item.id) {
//                                        checkedItems.remove(item.id)
//                                    } else {
//                                        checkedItems.insert(item.id)
//                                        userQuantities[item.id] = userQuantities[item.id] ?? item.required
//                                    }
//                                } label: {
//                                    Image(systemName: checkedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(checkedItems.contains(item.id) ? Color("primaryAccent") : Color("secondaryText"))
//                                }
//                                .buttonStyle(.plain)
//
//                                VStack(alignment: .leading) {
//                                    Text(item.name)
//                                        .foregroundColor(Color("primaryText"))
//                                    Text("Needed: \(String(format: "%.1f", item.required))")
//                                        .font(.caption)
//                                        .foregroundColor(Color("secondaryText"))
//                                }
//                                Spacer()
//                                HStack(spacing: 4) {
//                                    Button {
//                                        let current = userQuantities[item.id, default: item.required]
//                                        let next = max(0, current - item.incrementBy)
//                                        userQuantities[item.id] = next
//                                    } label: {
//                                        Image(systemName: "minus")
//                                            .font(.system(size: 14, weight: .bold))
//                                            .foregroundColor(Color("secondaryText"))
//                                    }
//                                    Text(String(format: "%.1f", userQuantities[item.id, default: item.required]))
//                                        .frame(width: 40)
//                                        .foregroundColor(Color("primaryText"))
//                                    Button {
//                                        let current = userQuantities[item.id, default: item.required]
//                                        let next = current + item.incrementBy
//                                        userQuantities[item.id] = next
//                                    } label: {
//                                        Image(systemName: "plus")
//                                            .font(.system(size: 14, weight: .bold))
//                                            .foregroundColor(Color("secondaryText"))
//                                    }
//                                }
//                                .padding(4)
//                                .background(Color("secondaryButton").opacity(0.7))
//                                .cornerRadius(20)
//                            }
//                        }
//                    }
//                    .listStyle(.plain)
//                    .scrollContentBackground(.hidden)
//
//                    Button {
//                        logItems()
//                    } label: {
//                        Text("Log Items")
//                            .font(.headline)
//                            .foregroundColor(Color("primaryButtonText"))
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 55)
//                            .background(Color("primaryAccent"))
//                            .cornerRadius(16)
//                    }
//                    .padding()
//                }
//                .navigationTitle("Shopping List")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button("Done") { dismiss() }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            // Set initial user quantities if needed
//            for item in itemsToShop {
//                if userQuantities[item.id] == nil {
//                    userQuantities[item.id] = item.required
//                }
//            }
//        }
//    }
//
//    private func logItems() {
//        for item in itemsToShop where checkedItems.contains(item.id) {
//            let amount = userQuantities[item.id, default: item.required]
//            viewModel.incrementPantryItem(id: item.id, by: amount)
//        }
//        checkedItems.removeAll()
//        userQuantities.removeAll()
//        dismiss()
//    }
//
//    struct ShoppingItem: Identifiable {
//        let id: UUID
//        let name: String
//        let category: String
//        let required: Double
//        let incrementBy: Double
//    }
//}
//
//
//// MARK: - PantryViewModel helpers (put this in PantryViewModel)
//extension PantryViewModel {
//    // Increment by name. If user logs more than needed, just add it!
//    func incrementPantryItem(named name: String, by amount: Double) {
//        for category in items.keys {
//            guard var arr = items[category] else { continue }
//            if let idx = arr.firstIndex(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
//                arr[idx].quantity += amount
//                items[category] = arr
//            }
//        }
//    }
//}


import SwiftUI

struct ShoppingListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PantryViewModel

    private var itemsToShop: [ShoppingItem] {
        viewModel.items
            .filter { $0.key != "All" }
            .flatMap { (category, items) in
                items.filter { $0.quantity < 5 }
                    .map { ShoppingItem(id: $0.id, name: $0.name, category: category, required: max(5 - $0.quantity, 0), incrementBy: $0.incrementBy) }
            }
    }

    @State private var userQuantities: [UUID: Double] = [:]
    @State private var checkedItems: Set<UUID> = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground").ignoresSafeArea()
                VStack {
                    if itemsToShop.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "cart")
                                .font(.system(size: 56, weight: .regular))
                                .foregroundColor(Color("secondaryText"))
                                .opacity(0.4)
                            Text("Nothing to shop")
                                .font(.headline)
                                .foregroundColor(Color("secondaryText"))
                                .opacity(0.8)
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(itemsToShop) { item in
                                HStack {
                                    Button {
                                        if checkedItems.contains(item.id) {
                                            checkedItems.remove(item.id)
                                        } else {
                                            checkedItems.insert(item.id)
                                            userQuantities[item.id] = userQuantities[item.id] ?? item.required
                                        }
                                    } label: {
                                        Image(systemName: checkedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(checkedItems.contains(item.id) ? Color("primaryAccent") : Color("secondaryText"))
                                    }
                                    .buttonStyle(.plain)

                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .foregroundColor(Color("primaryText"))
                                        Text("Needed: \(String(format: "%.1f", item.required))")
                                            .font(.caption)
                                            .foregroundColor(Color("secondaryText"))
                                    }
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Button {
                                            let current = userQuantities[item.id, default: item.required]
                                            let next = current + item.incrementBy // removed the upper cap idhar se so i can add as many as i want
                                            userQuantities[item.id] = next
                                        } label: {
                                            Image(systemName: "minus")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color("secondaryText"))
                                        }
                                        Text(String(format: "%.1f", userQuantities[item.id, default: item.required]))
                                            .frame(width: 40)
                                            .foregroundColor(Color("primaryText"))
                                        Button {
                                            let current = userQuantities[item.id, default: item.required]
                                            let next = current + item.incrementBy
                                            userQuantities[item.id] = next
                                        } label: {
                                            Image(systemName: "plus")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color("secondaryText"))
                                        }
                                    }
                                    .padding(4)
                                    .background(Color("secondaryButton").opacity(0.7))
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }

                    Button {
                        logItems()
                    } label: {
                        Text("Log Items")
                            .font(.headline)
                            .foregroundColor(itemsToShop.isEmpty || checkedItems.isEmpty ? Color("secondaryText") : Color("primaryButtonText"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(itemsToShop.isEmpty || checkedItems.isEmpty ? Color("primaryCard") : Color("primaryAccent"))
                            .cornerRadius(16)
                    }
                    .padding()
                    .disabled(itemsToShop.isEmpty || checkedItems.isEmpty)
                }
                .navigationTitle("Shopping List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
        .onAppear {
            for item in itemsToShop {
                if userQuantities[item.id] == nil {
                    userQuantities[item.id] = item.required
                }
            }
        }
    }

    private func logItems() {
        for item in itemsToShop where checkedItems.contains(item.id) {
            let amount = userQuantities[item.id, default: item.required]
            viewModel.incrementPantryItemWithoutSorting(id: item.id, by: amount)
        }
        checkedItems.removeAll()
        userQuantities.removeAll()
        dismiss()
    }

    struct ShoppingItem: Identifiable {
        let id: UUID
        let name: String
        let category: String
        let required: Double
        let incrementBy: Double
    }
}
