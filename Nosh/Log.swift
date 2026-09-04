import Foundation
import OSLog

/// App-wide loggers.
///
/// `print` writes unconditionally in release builds and has no privacy
/// controls; these replace the debug prints that were shipping user data —
/// item names, meal names, emails — into the device log.
enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.NoshApp.Nosh"

    static let auth = Logger(subsystem: subsystem, category: "auth")
    static let pantry = Logger(subsystem: subsystem, category: "pantry")
    static let mealPlanner = Logger(subsystem: subsystem, category: "mealPlanner")
    static let recipes = Logger(subsystem: subsystem, category: "recipes")
    static let profile = Logger(subsystem: subsystem, category: "profile")
    static let notifications = Logger(subsystem: subsystem, category: "notifications")
}
