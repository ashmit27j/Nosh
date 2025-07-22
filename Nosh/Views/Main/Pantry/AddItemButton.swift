import SwiftUI

struct AddItemButton: View {
    let category: String
    @ObservedObject var viewModel: PantryViewModel

    var body: some View {
        Button(action: {
            viewModel.addCustomItem(to: category, name: "New Item")
        }) {
            HStack {
                Spacer()
                Text("Add New Item")
                Spacer()
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.green)
            )
        }
    }
}
