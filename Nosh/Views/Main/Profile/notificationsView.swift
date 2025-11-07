import SwiftUI
import UserNotifications

struct notificationsView: View {
    @State private var pushNotifications = true
    @State private var reminderAlerts = true

    enum EmailUpdateOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case all = "All updates"
        case billing = "Billing only"
        case marketing = "Marketing only"
    }
    @State private var emailUpdatePreference: EmailUpdateOption = .all

    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notifications")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color("primaryText"))
                        Text("Choose how you want to be notified about recipes, reminders and offers. You control your alerts and emails in Nosh.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("secondaryText"))
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)

                    SectionContainer(spacing: 16) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Push Notifications")
                                .font(.system(size: 17, weight: .semibold))
                            ColoredToggle(isOn: $pushNotifications, title: "App Activity")
                            ColoredToggle(isOn: $reminderAlerts, title: "Reminders & Alerts")
                        }
                    }

                    SectionContainer(spacing: 12) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email Updates")
                                .font(.system(size: 17, weight: .semibold))
                            Picker(selection: $emailUpdatePreference, label: Text("")) {
                                ForEach(EmailUpdateOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.menu)
                            .accentColor(Color("primaryAccent"))
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }

                    SectionContainer(spacing: 12) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Send Test Notification")
                                .font(.system(size: 17, weight: .semibold))
                            Button(action: sendTestNotification) {
                                Text("Send Test Notification")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color("primaryAccent"))
                                    .cornerRadius(12)
                            }
                        }
                    }

                    Spacer(minLength: 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Nosh Notification"
        content.body = "Testing local notification settings"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule test notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled!")
            }
        }
    }
}
