//
//  AccessibilityEnvironment.swift
//  Nosh
//
//  Created by MacBook on 06/11/25.
//


import SwiftUI

// MARK: - Accessibility Environment
class AccessibilityEnvironment: ObservableObject {
    static let shared = AccessibilityEnvironment()
    
    @AppStorage("textSize") var textSize: TextSizeOption = .medium
    @AppStorage("highContrast") var highContrast = false
    @AppStorage("reduceMotion") var reduceMotion = false
    @AppStorage("boldText") var boldText = false
    @AppStorage("hapticFeedback") var hapticFeedback = true
    @AppStorage("voiceOverEnabled") var voiceOverEnabled = false
    
    // Computed font sizes for different text types
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
    
    // Animation helper
    var animation: Animation? {
        reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)
    }
    
    // Color helpers
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
    
    // Haptic feedback
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard hapticFeedback else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func success() {
        guard hapticFeedback else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func error() {
        guard hapticFeedback else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - View Extension for Easy Access
extension View {
    var accessibility: AccessibilityEnvironment {
        AccessibilityEnvironment.shared
    }
}
