import Foundation
import UserNotifications

struct NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    /// Schedules one reminder for a meal slot.
    private func scheduleReminder(at date: Date, mealType: String) {
        let messages = [
            "Hey, it's been a while! Ready to cook something tasty?",
            "Nosh Reminder: Don't forget to fuel up with a great meal.",
            "Hungry? Check your Nosh meal plan for ideas!",
            "Cooking time! Open Nosh for quick recipes.",
            "It's time to make your kitchen the happiest place!"
        ]
        let content = UNMutableNotificationContent()
        content.title = mealType + " Reminder"
        content.body = messages.randomElement() ?? "Ready for your next meal?"
        content.sound = .default
        
        // Set notification trigger for given date
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    /// Schedules reminders 30 minutes before each meal time.
    ///
    /// Clears previously scheduled reminders first, otherwise every appearance
    /// of MainTabView queues another three.
    func scheduleMealNotifications(mealTimes: MealTimes) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let calendar = Calendar.current
        let types: [(MealType, Date)] = [
            (.breakfast, mealTimes.breakfastTime),
            (.lunch, mealTimes.lunchTime),
            (.dinner, mealTimes.dinnerTime)
        ]
        
        for (mealType, mealDate) in types {
            if let notifyDate = calendar.date(byAdding: .minute, value: -30, to: mealDate) {
                scheduleReminder(at: notifyDate, mealType: mealType.rawValue)
            }
        }
    }
}
