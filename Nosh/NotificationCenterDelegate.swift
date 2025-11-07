//
//  NotificationCenterDelegate.swift
//  Nosh
//
//  Created by MacBook on 06/11/25.
//


import UserNotifications

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Show banner and sound even if foregrounded
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}
