import SwiftUI
import Combine

// MARK: - Accessibility Environment

/// Shared accessibility and theme preferences.
///
/// These are deliberately *not* `@AppStorage`. `@AppStorage` is a
/// `DynamicProperty`: SwiftUI only re-evaluates it when it is installed in a
/// `View`. Declared inside an `ObservableObject` it reads and writes
/// UserDefaults but never fires `objectWillChange`, so every screen observing
/// this object stayed frozen on the values it saw at launch.
@MainActor
final class AccessibilityEnvironment: ObservableObject {
    static let shared = AccessibilityEnvironment()

    private enum Key {
        static let textSize = "textSize"
        static let highContrast = "highContrast"
        static let reduceMotion = "reduceMotion"
        static let boldText = "boldText"
        static let hapticFeedback = "hapticFeedback"
        static let voiceOverEnabled = "voiceOverEnabled"
        static let accentHex = "primaryAccentHex"
    }

    private let defaults: UserDefaults

    @Published var textSize: TextSizeOption {
        didSet { defaults.set(textSize.rawValue, forKey: Key.textSize) }
    }
    @Published var highContrast: Bool {
        didSet { defaults.set(highContrast, forKey: Key.highContrast) }
    }
    @Published var reduceMotion: Bool {
        didSet { defaults.set(reduceMotion, forKey: Key.reduceMotion) }
    }
    @Published var boldText: Bool {
        didSet { defaults.set(boldText, forKey: Key.boldText) }
    }
    @Published var hapticFeedback: Bool {
        didSet { defaults.set(hapticFeedback, forKey: Key.hapticFeedback) }
    }
    @Published var voiceOverEnabled: Bool {
        didSet { defaults.set(voiceOverEnabled, forKey: Key.voiceOverEnabled) }
    }

    /// Hex string for the user's chosen accent colour.
    @Published var accentHex: String {
        didSet { defaults.set(accentHex, forKey: Key.accentHex) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Key.hapticFeedback: true,
            Key.accentHex: "#16E51D"
        ])

        textSize = TextSizeOption(rawValue: defaults.string(forKey: Key.textSize) ?? "")
            ?? .medium
        highContrast = defaults.bool(forKey: Key.highContrast)
        reduceMotion = defaults.bool(forKey: Key.reduceMotion)
        boldText = defaults.bool(forKey: Key.boldText)
        hapticFeedback = defaults.bool(forKey: Key.hapticFeedback)
        voiceOverEnabled = defaults.bool(forKey: Key.voiceOverEnabled)
        accentHex = defaults.string(forKey: Key.accentHex) ?? "#16E51D"
    }

    // MARK: - Derived colour

    /// The accent to tint the app with. Falls back to the asset catalogue colour
    /// when the stored hex is unparseable.
    var accent: Color {
        Color(hex: accentHex) ?? Color("primaryAccent")
    }

    // MARK: - Computed fonts

    var titleFont: Font {
        .system(size: textSize.fontSize * 1.5, weight: boldText ? .bold : .semibold)
    }

    var headlineFont: Font {
        .system(size: textSize.fontSize * 1.25, weight: boldText ? .bold : .semibold)
    }

    var bodyFont: Font {
        .system(size: textSize.fontSize, weight: boldText ? .medium : .regular)
    }

    var captionFont: Font {
        .system(size: textSize.fontSize * 0.875, weight: boldText ? .medium : .regular)
    }

    var smallFont: Font {
        .system(size: textSize.fontSize * 0.75, weight: boldText ? .medium : .regular)
    }

    /// Nil when the user has asked for reduced motion, so callers can pass it
    /// straight to `withAnimation(_:)`.
    var animation: Animation? {
        reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.7)
    }

    // MARK: - Colour helpers

    func textColor(primary: Bool = true) -> Color {
        if highContrast {
            return primary ? .primary : .secondary
        }
        return primary ? Color("primaryText") : Color("secondaryText")
    }

    func backgroundColor(card: Bool = false) -> Color {
        if highContrast {
            return card ? Color.black.opacity(0.9) : Color.black
        }
        return card ? Color("primaryCard") : Color("primaryBackground")
    }

    // MARK: - Haptics

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard hapticFeedback else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func success() {
        guard hapticFeedback else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func error() {
        guard hapticFeedback else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
