import SwiftUI

struct PantryItemView: View {
    let item: PantryItem
    let category: String
    @ObservedObject var viewModel: PantryViewModel

    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.gray)
                .padding(.trailing, 8)

            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                Button(action: {
                    viewModel.decrement(item, in: category)
                }) {
                    Image(systemName: "minus.circle")
                }

                Text("\(item.quantity)")
                    .frame(width: 24)

                Button(action: {
                    viewModel.increment(item, in: category)
                }) {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
