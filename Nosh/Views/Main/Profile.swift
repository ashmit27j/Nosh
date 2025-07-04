//import SwiftUI
//
//struct Profile: View {
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//
//                    // Profile Header
//                    HStack(alignment: .center) {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(.gray)
//
//                        VStack(alignment: .leading) {
//                            Text("User Name")
//                                .font(.headline)
//
//                            Text("Plan: ") + Text("Freemium").foregroundColor(.green)
//                        }
//
//                        Spacer()
//
//                        Button("Edit") {
//                            // Handle edit action
//                        }
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                    }
//                    .padding()
//                    .background(Color(uiColor: .secondarySystemBackground))
//                    .cornerRadius(16)
//
//                    // Settings Sections
//                    VStack(spacing: 16) {
//                        ProfileSection(title: "Account", items: [
//                            ProfileItem(icon: "person.crop.circle", iconColor: .orange, title: "Edit Profile", enabled: true),
//                            ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true),
//                            ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true)
//                        ])
//
//
//                        ProfileSection(title: "Meal Preferences", items: [
//                            ProfileItem(icon: "leaf", iconColor: .green, title: "Diet Type", enabled: true),
//                            ProfileItem(icon: "exclamationmark.triangle", iconColor: .red, title: "Allergens", enabled: true),
//                            ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true),
//                            ProfileItem(icon: "cart", iconColor: .blue, title: "Grocery Preferences", enabled: true)
//                        ])
//
//                        
//                        ProfileSection(title: "App Settings", items: [
//                            ProfileItem(icon: "figure", iconColor: .blue, title: "Accessibility", enabled: true),
//                            ProfileItem(icon: "paintbrush", iconColor: .blue, title: "Theme", enabled: true),
//                            ProfileItem(icon: "textformat.size", iconColor: .gray, title: "Text Size", enabled: true)
//                        ])
//
//                        ProfileSection(title: "Support", items: [
//                            ProfileItem(icon: "headphones", iconColor: .blue, title: "Customer Support", enabled: true),
//                            ProfileItem(icon: "doc.text", iconColor: .gray, title: "Terms of Use", enabled: true),
//                            ProfileItem(icon: "lock", iconColor: .gray, title: "Privacy Policy", enabled: true)
//                        ])
//
//                        ProfileSection(title: "Danger Zone", items: [
//                            ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true),
//                            ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true),
//                            ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true)
//                        ])
//                        
//                        Spacer()
//                            .padding(.bottom, 60)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.large)
//            .scrollIndicators(.hidden)
//        }
//    }
//}
//
//struct ProfileSection: View {
//    let title: String
//    let items: [ProfileItem]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text(title)
//                .font(.headline)
//                .padding(.bottom, 10)
//
//            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
//                HStack(spacing: 12) {
//                    ZStack {
//                        Circle()
//                            .fill(item.iconColor.opacity(0.15))
//                            .frame(width: 30, height: 30)
//                        Image(systemName: item.icon)
//                            .foregroundColor(item.iconColor)
//                    }
//
//                    Text(item.title)
//                        .foregroundColor(item.enabled ? .primary : .gray)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray)
//                }
//                .padding(.vertical, 10)
//
//                if index < items.count - 1 {
//                    Divider()
//                }
//            }
//        }
//        .padding(.top)
//        .padding(.leading)
//        .padding(.trailing)
//        .background(Color(uiColor: .secondarySystemBackground))
//        .cornerRadius(16)
//    }
//}
//
//struct ProfileItem: Identifiable, Hashable {
//    let id = UUID()
//    let icon: String
//    let iconColor: Color
//    let title: String
//    let enabled: Bool
//}
//

import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Profile Header
                        HStack(alignment: .center) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading) {
                                Text("User Name")
                                    .font(.headline)

                                Text("Plan: ") + Text("Freemium").foregroundColor(.green)
                            }

                            Spacer()

                            Button("Edit") {
                                // Handle edit action
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .padding()
                        .background(Color("primaryCard"))
                        .cornerRadius(16)

                        // Settings Sections
                        VStack(spacing: 16) {
                            ProfileSection(title: "Account", items: [
                                ProfileItem(icon: "person.crop.circle", iconColor: .orange, title: "Edit Profile", enabled: true),
                                ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true),
                                ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true)
                            ])

                            ProfileSection(title: "Meal Preferences", items: [
                                ProfileItem(icon: "leaf", iconColor: .green, title: "Diet Type", enabled: true),
                                ProfileItem(icon: "exclamationmark.triangle", iconColor: .red, title: "Allergens", enabled: true),
                                ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true),
                                ProfileItem(icon: "cart", iconColor: .blue, title: "Grocery Preferences", enabled: true)
                            ])

                            ProfileSection(title: "App Settings", items: [
                                ProfileItem(icon: "figure", iconColor: .blue, title: "Accessibility", enabled: true),
                                ProfileItem(icon: "paintbrush", iconColor: .blue, title: "Theme", enabled: true),
                                ProfileItem(icon: "textformat.size", iconColor: .gray, title: "Text Size", enabled: true)
                            ])

                            ProfileSection(title: "Support", items: [
                                ProfileItem(icon: "headphones", iconColor: .blue, title: "Customer Support", enabled: true),
                                ProfileItem(icon: "doc.text", iconColor: .gray, title: "Terms of Use", enabled: true),
                                ProfileItem(icon: "lock", iconColor: .gray, title: "Privacy Policy", enabled: true)
                            ])

                            ProfileSection(title: "Danger Zone", items: [
                                ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true),
                                ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true),
                                ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true)
                            ])

                            Spacer()
                                .padding(.bottom, 60)
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

struct ProfileSection: View {
    let title: String
    let items: [ProfileItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 10)

            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(item.iconColor.opacity(0.15))
                            .frame(width: 30, height: 30)
                        Image(systemName: item.icon)
                            .foregroundColor(item.iconColor)
                    }

                    Text(item.title)
                        .foregroundColor(item.enabled ? .primary : .gray)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)

                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        .background(Color("primaryCard"))
        .cornerRadius(16)
    }
}

struct ProfileItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let enabled: Bool
}
