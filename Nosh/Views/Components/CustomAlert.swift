import SwiftUI

struct CustomAlert: View {
    var title: String
    var message: String
    var confirmText: String = "Confirm"
    var cancelText: String = "Cancel"
    var confirmAction: () -> Void
    var cancelAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)

            Divider()

            HStack(spacing: 0) {
                Button(action: cancelAction) {
                    Text(cancelText)
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .foregroundColor(.primary)
                }
                .contentShape(Rectangle())

                Divider()

                Button(action: confirmAction) {
                    Text(confirmText)
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .foregroundColor(.red)
                }
                .contentShape(Rectangle())
            }
            .frame(height: 44)
        }
        .frame(maxWidth: 300)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(radius: 20)
    }
}
