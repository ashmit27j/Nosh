import SwiftUI

struct FoodPreferenceSelector: View {
    @Binding var selectedPreference: String?
    
    let preferences = [
        (name: "Veg", icon: "leaf.fill", color: Color("pastelGreen")),
        (name: "Both", icon: "fork.knife", color: Color("pastelYellow")),
        (name: "Non-Veg", icon: "fish.fill", color: Color("pastelRed"))
    ]

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text("Food Preference")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(preferences.indices, id: \.self) { index in
                        let preference = preferences[index]
                        VStack(spacing: 10) {
                            Button(action: {
                                selectedPreference = preference.name
                            }) {
                                Image(systemName: preference.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .foregroundColor(.white)
                                    .background(
                                        selectedPreference == preference.name
                                        ? preference.color
                                        : Color.clear
                                    )
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(preference.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}
