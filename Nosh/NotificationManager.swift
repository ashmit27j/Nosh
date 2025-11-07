import Foundation
import UserNotifications

struct NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule dummy motivational notifications at a specified time
    func scheduleMotivationalNotifications(date: Date, mealType: String) {
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
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule reminders for breakfast, lunch, dinner 30 mins before
    func scheduleMealNotifications(mealTimes: MealTimes) {
        let calendar = Calendar.current
        let types: [(MealType, Date)] = [
            (.breakfast, mealTimes.breakfastTime),
            (.lunch, mealTimes.lunchTime),
            (.dinner, mealTimes.dinnerTime)
        ]
        
        for (mealType, mealDate) in types {
            if let notifyDate = calendar.date(byAdding: .minute, value: -30, to: mealDate) {
                scheduleMotivationalNotifications(date: notifyDate, mealType: mealType.rawValue)
            }
        }
    }
}
