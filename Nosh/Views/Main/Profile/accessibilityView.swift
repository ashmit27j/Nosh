import SwiftUI

struct accessibilityView: View {
    @AppStorage("textSize") private var textSize: TextSizeOption = .medium
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("reduceMotion") private var reduceMotion = false
    @AppStorage("boldText") private var boldText = false
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("voiceOverEnabled") private var voiceOverEnabled = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            ScrollView {
                VStack(spacing: 28) {
                    // Header as Card
                    SectionCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Accessibility")
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(Color("primaryText"))
                            Text("Customize Nosh for comfort and usability. Enable accessibility options for better vision, motion control, and interaction.")
                                .font(.system(size: 15))
                                .foregroundColor(Color("secondaryText"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    // Vision Section
                    SectionCard {
                        SectionHeader(icon: "eye.fill", title: "Vision")
                        Divider().opacity(0.3)
                        VStack(spacing: 16) {
                            // Text Size
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Text Size")
                                    .font(.system(size: 17, weight: .semibold))

                                Picker("Text Size", selection: $textSize) {
                                    ForEach(TextSizeOption.allCases, id: \.self) { size in
                                        Text(size.rawValue).tag(size)
                                    }
                                }
                                .pickerStyle(.segmented)

                                // Preview
                                VStack(spacing: 8) {
                                    Text("Preview: Recipe Title")
                                        .font(.system(size: textSize.fontSize, weight: .semibold))
                                    Text("This is how regular text will appear in the app.")
                                        .font(.system(size: textSize.fontSize * 0.88))
                                        .foregroundColor(Color("secondaryText"))
                                }
                                .padding()
                                .background(Color("secondaryButton").opacity(0.25))
                                .cornerRadius(8)
                            }
                            SettingToggle(
                                icon: "circle.lefthalf.filled",
                                title: "High Contrast",
                                description: "Increase color contrast for better visibility.",
                                isOn: $highContrast
                            )
                            SettingToggle(
                                icon: "bold",
                                title: "Bold Text",
                                description: "Make all text bolder and easier to read.",
                                isOn: $boldText
                            )
                        }
                    }
                    // Motion Section
                    SectionCard {
                        SectionHeader(icon: "wand.and.stars", title: "Motion")
                        Divider().opacity(0.3)
                        SettingToggle(
                            icon: "speedometer",
                            title: "Reduce Motion",
                            description: "Minimize animations and movement.",
                            isOn: $reduceMotion
                        )
                    }
                    // Interaction Section
                    SectionCard {
                        SectionHeader(icon: "hand.tap.fill", title: "Interaction")
                        Divider().opacity(0.3)
                        VStack(spacing: 16) {
                            SettingToggle(
                                icon: "iphone.radiowaves.left.and.right",
                                title: "Haptic Feedback",
                                description: "Feel vibrations when interacting with the app.",
                                isOn: $hapticFeedback
                            )
                            SettingToggle(
                                icon: "speaker.wave.3.fill",
                                title: "VoiceOver Support",
                                description: "Enhance screen reader compatibility.",
                                isOn: $voiceOverEnabled
                            )
                        }
                    }
                    // Reset Button as Card
                    SectionCard {
                        Button(action: resetToDefaults) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset to Default Settings")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("primaryAccent"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("secondaryButton").opacity(0.5))
                            .cornerRadius(10)
                        }
                    }
                    Spacer().frame(height: 100)
                }
                .padding(.vertical, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color("primaryAccent"))
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func resetToDefaults() {
        textSize = .medium
        highContrast = false
        reduceMotion = false
        boldText = false
        hapticFeedback = true
        voiceOverEnabled = false
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Section Card Container
struct SectionCard<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color("primaryCard"))
            .cornerRadius(18)
            .shadow(color: Color(.black).opacity(0.04), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
    }
}

enum TextSizeOption: String, CaseIterable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"
    var fontSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 16
        case .large: return 18
        case .extraLarge: return 20
        }
    }
}

// MARK: - Setting Toggle Row
struct SettingToggle: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color("primaryAccent"))
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color("primaryText"))
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color("secondaryText"))
                    .lineLimit(2)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color("primaryAccent"))
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(10)
    }
}
