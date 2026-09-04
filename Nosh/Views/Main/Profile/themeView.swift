import SwiftUI

struct themeView: View {
    @EnvironmentObject private var accessibility: AccessibilityEnvironment

    private var primaryAccentHex: String { accessibility.accentHex }
    let accentColors: [ColorOption] = [
        ColorOption(name: "Teal", hex: "#20CBCB"),
        ColorOption(name: "Blue", hex: "#4682F4"),
        ColorOption(name: "Green", hex: "#71CE56"),
        ColorOption(name: "Orange", hex: "#FFA23E"),
        ColorOption(name: "Pink", hex: "#F973C6"),
        ColorOption(name: "Purple", hex: "#A978F5"),
        ColorOption(name: "Red", hex: "#F75B54"),
        ColorOption(name: "Yellow", hex: "#F5D451")
    ]

    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Theme & Accent Color")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color("primaryText"))
                        Text("Personalize how Nosh looks and feels. Select your favorite accent color to be reflected throughout the app.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("secondaryText"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)

                    SectionContainer(spacing: 18) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Choose Accent Color")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color("primaryText"))
                            ColorPaletteGrid(
                                colorOptions: accentColors,
                                selectedHex: primaryAccentHex,
                                onSelect: { newHex in
                                    withAnimation(accessibility.animation) {
                                        accessibility.accentHex = newHex
                                    }
                                }
                            )
                            Text("Preview Accent")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("primaryText"))
                                .padding(.top, 12)
                            AccentPreviewCard(accent: selectedAccentColor)
                        }
                    }
                    Spacer(minLength: 56)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var selectedAccentColor: ColorOption {
        accentColors.first(where: { $0.hex == primaryAccentHex }) ?? accentColors[0]
    }
}

// ---- Reuse SectionContainer, ColorOption, ColorPaletteGrid, AccentPreviewCard as above ----


struct ColorOption: Identifiable {
    let id = UUID()
    let name: String
    let hex: String
    var color: Color { Color(hex: hex) ?? Color("primaryAccent") }
}

// MARK: - Color Extensions
extension Color {
    /// Parses `#RRGGBB` / `RRGGBB`. Failable so malformed input surfaces as a
    /// fallback rather than silently rendering black.
    init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("#") { cleaned.removeFirst() }
        guard cleaned.count == 6, let value = UInt32(cleaned, radix: 16) else { return nil }

        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - Palette Grid
struct ColorPaletteGrid: View {
    let colorOptions: [ColorOption]
    let selectedHex: String
    let onSelect: (String) -> Void

    private let gridLayout = [GridItem(.adaptive(minimum: 54, maximum: 64), spacing: 20)]
    var body: some View {
        LazyVGrid(columns: gridLayout, spacing: 22) {
            ForEach(colorOptions) { option in
                Button(action: { onSelect(option.hex) }) {
                    ZStack {
                        Circle()
                            .fill(option.color)
                            .frame(width: 54, height: 54)
                            .overlay(
                                Circle()
                                    .stroke(selectedHex == option.hex ? option.color.opacity(0.8) : Color.clear, lineWidth: 3)
                            )
                            .shadow(color: selectedHex == option.hex ? option.color.opacity(0.33) : .clear, radius: 8)
                        if selectedHex == option.hex {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.title3.bold())
                        }
                    }
                }
                .buttonStyle(.plain)
                .scaleEffect(selectedHex == option.hex ? 1.12 : 1.0)
                .animation(.easeInOut(duration: 0.18), value: selectedHex)
                Text(option.name)
                    .font(.caption)
                    .fontWeight(selectedHex == option.hex ? .semibold : .regular)
                    .frame(width: 54)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Preview Card
struct AccentPreviewCard: View {
    let accent: ColorOption
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Circle()
                    .fill(accent.color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    )
                Text("Sample with \(accent.name)")
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(.bottom, 2)
            Button(action: {}) {
                Text("Accent Button")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(accent.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            Text("Nosh recipe cards, highlights, and key actions use your accent color for a personalized look.")
                .font(.system(size: 13))
                .foregroundColor(Color("secondaryText"))
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 7, y: 2)
    }
}

