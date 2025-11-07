import SwiftUI

struct privacyView: View {
    @State private var isPrivateAccount = false
    @State private var allowPersonalizedSuggestions = true
    @State private var useLocation = true

    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy & Security")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color("primaryText"))
                        Text("Review and adjust your privacy controls including data sharing, personalization, and location. Nosh never shares your personal info without your consent.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("secondaryText"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)

                    SectionContainer(spacing: 16) {
                        VStack(alignment: .leading, spacing: 18) {
                            ColoredToggle(isOn: $isPrivateAccount, title: "Private Account")
                            Text("Only approved followers can view your recipes and reviews.")
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                            ColoredToggle(isOn: $allowPersonalizedSuggestions, title: "Personalized Suggestions")
                            Text("Allow tailored recommendations based on your Nosh activity.")
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                            ColoredToggle(isOn: $useLocation, title: "Location Access")
                            Text("Show dining spots and local events using your location.")
                                .font(.caption)
                                .foregroundColor(Color("secondaryText"))
                        }
                    }
                    SectionContainer(spacing: 12) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Clear Your Data")
                                .font(.system(size: 17, weight: .semibold))
                            Button(action: {
                                // Add clear data logic
                            }) {
                                Text("Clear My Data")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color(.red))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    Spacer(minLength: 56)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ColoredToggle: View {
    @Binding var isOn: Bool
    let title: String

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .foregroundColor(.primary)
        }
        .tint(Color("primaryAccent"))
        .padding(.vertical, 2)
    }
}

