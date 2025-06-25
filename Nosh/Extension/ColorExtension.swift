////// Extend Color to produce darker variant:
////
////import SwiftUICore
////import UIKit
////
////extension Color {
////    func darker(by percentage: Double = 30.0) -> Color {
////        let uiColor = UIColor(self)
////        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
////        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
////        return Color(red: max(Double(r) - percentage/100, 0),
////                     green: max(Double(g) - percentage/100, 0),
////                     blue: max(Double(b) - percentage/100, 0))
////    }
////}
//
//
//import SwiftUI
//
//extension Color {
//    // Alternate Accents
//    static let pastelGreen = Color("pastelGreen")
//    static let pastelPurple = Color("pastelPurple")
//    static let pastelRed = Color("pastelRed")
//    static let pastelYellow = Color("pastelYellow")
//    
//    // Body
//    static let primaryAccent = Color("primaryAccent")
//    static let primaryBackground = Color("primaryBackground")
//    static let primaryOutline = Color("primaryOutline")
//    static let secondaryAccent = Color("secondaryAccent")
//    static let secondaryBackground = Color("secondaryBackground")
//    
//    // Component
//    static let buttonPrimary = Color("buttonPrimary")
//    static let buttonSecondary = Color("buttonSecondary")
//    static let navbarBackground = Color("navbarBackground")
//    static let navbarIcon = Color("navbarIcon")
//    
//    // Text
//    static let textPrimary = Color("textPrimary")
//    static let textSecondary = Color("textSecondary")
//}
