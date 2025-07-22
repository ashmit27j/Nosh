import SwiftUI

struct notificationsView: View {
    @State private var pushNotifications = true
    @State private var emailUpdates = false
    @State private var appSounds = true
    @State private var productAnnouncements = false
    @State private var reminderAlerts = true

    var body: some View {
        VStack(spacing: 20) {
//            Text("Notifications")
//                .font(.title2.bold())
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)

            SectionContainer {
                Toggle("Push Notifications", isOn: $pushNotifications)
                Toggle("Email Updates", isOn: $emailUpdates)
                Toggle("In-App Sounds", isOn: $appSounds)
                Toggle("Product Announcements", isOn: $productAnnouncements)
                Toggle("Reminders & Alerts", isOn: $reminderAlerts)
            }

            Spacer()
        }
        .padding(.top)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("primaryBackground").ignoresSafeArea())
    }
}
