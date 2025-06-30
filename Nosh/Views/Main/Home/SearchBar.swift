import SwiftUI

// MARK: - Search Bar with Filter Icon
struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .textFieldStyle(PlainTextFieldStyle())
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            Image("filterIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(
            ZStack {
                Color("secondaryBackground").opacity(0.6) // subtle base color
                .clipShape(RoundedRectangle(cornerRadius: 12))

                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
