import SwiftUI

struct notificationsView: View {
    @State private var pushNotifications = true
    @State private var reminderAlerts = true

    enum EmailUpdateOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case all = "All updates"
        case billing = "Billing information only"
        case marketing = "Marketing only"
    }

    @State private var emailUpdatePreference: EmailUpdateOption = .all

    var body: some View {
        VStack(spacing: 24) {
            // Notification Preferences Section
            SectionHeader(icon: "bell.badge.fill", title: "Notification Preferences")
            SectionContainer(spacing: 12) {
                ColoredToggle(
                    isOn: $pushNotifications,
                    title: "Push Notifications"
                )
                .accessibilityIdentifier("pushToggle")

                ColoredToggle(
                    isOn: $reminderAlerts,
                    title: "Reminders & Alerts"
                )
                .accessibilityIdentifier("reminderToggle")
            }

            // Email Updates Section
            SectionHeader(title: "Email Updates")
            SectionContainer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Receive email updates")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Picker("Email update type", selection: $emailUpdatePreference) {
                        ForEach(EmailUpdateOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(Color("primaryAccent"))
                }
                .padding(.vertical, 2)
            }

            // Send Test Notification
            SectionHeader(title: "Test")
            SectionContainer {
                Button {
                    sendTestNotification()
                } label: {
                    Text("Send Test Notification")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("primaryAccent"))
                        .cornerRadius(12)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("primaryBackground").ignoresSafeArea())
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

// MARK: - ColoredToggle (uses primaryAccent for ON)
struct ColoredToggle: View {
    @Binding var isOn: Bool
    let title: String

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .foregroundColor(.primary)
        }
        .tint(Color("primaryAccent"))
        .padding(.vertical, 2)
    }
}
