import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Profile: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var navigateToEdit = false
    @State private var showPopup = false
    @State private var popupTitle = ""
    @State private var popupMessage = ""
    @State private var popupAction: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("primaryBackground").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(spacing: 20) {
                            ProfileCard
                                .padding(.horizontal)

                            SettingsSection(
                                title: "Account",
                                items: [
                                    ProfileItem(icon: "creditcard", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
                                    ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
                                    ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
                                ]
                            )

                            SettingsSection(title: "Meal Preferences", items: [
                                ProfileItem(icon: "leaf", iconColor: .green, title: "Diet Type", enabled: true, destination: AnyView(dietTypeView())),
                                ProfileItem(icon: "exclamationmark.triangle", iconColor: .red, title: "Allergens", enabled: true, destination: AnyView(allergensView())),
                                ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true, destination: AnyView(mealScheduleView())),
                                ProfileItem(icon: "cart", iconColor: .blue, title: "Grocery Preferences", enabled: true, destination: AnyView(groceryPreferencesView()))
                            ])

                            SettingsSection(title: "App Settings", items: [
                                ProfileItem(icon: "figure", iconColor: .blue, title: "Accessibility", enabled: true, destination: AnyView(accessibilityView())),
                                ProfileItem(icon: "paintbrush", iconColor: .blue, title: "Theme", enabled: true, destination: AnyView(themeView()))
                            ])

                            SettingsSection(title: "Support", items: [
                                ProfileItem(icon: "headphones", iconColor: .blue, title: "Customer Support", enabled: true, destination: AnyView(customerSupportView())),
                                ProfileItem(icon: "doc.text", iconColor: .gray, title: "Terms of Use", enabled: true, destination: AnyView(termsOfUseView())),
                                ProfileItem(icon: "lock", iconColor: .gray, title: "Privacy Policy", enabled: true, destination: AnyView(privacyPolicyView()))
                            ])

                            SettingsSection(title: "Danger Zone", items: [
                                ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true, action: {
                                    popupTitle = "Reset to Defaults"
                                    popupMessage = "Are you sure you want to reset all settings?"
                                    popupAction = { print("Reset action") }
                                    showPopup = true
                                }),
                                ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, action: {
                                    popupTitle = "Log Out"
                                    popupMessage = "Are you sure you want to log out?"
                                    popupAction = { print("Logout action") }
                                    showPopup = true
                                }),
                                ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, action: {
                                    popupTitle = "Delete Account"
                                    popupMessage = "This cannot be undone. Are you sure?"
                                    popupAction = { print("Delete action") }
                                    showPopup = true
                                })
                            ], isActionSection: true)
                        }
                        .padding(.top, 100)

                        Spacer().padding(.bottom, 80)
                    }
                }
                .overlay(
                    Group {
                        if showPopup {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()

                            CustomAlert(
                                title: popupTitle,
                                message: popupMessage,
                                confirmAction: {
                                    popupAction?()
                                    showPopup = false
                                },
                                cancelAction: {
                                    showPopup = false
                                }
                            )
                        }
                    }
                )

                ProfileHeader
            }
        }
    }

    // MARK: Profile header
    private var ProfileHeader: some View {
        HStack {
            Text("Profile")
                .font(.largeTitle.bold())
                .foregroundColor(Color("primaryText"))
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(Color("primaryCard"))
    }

    // MARK: User Profile card
    private var ProfileCard: some View {
        HStack(alignment: .center, spacing: 16) {
            if let photoURL = viewModel.photoURL {
                WebImage(url: photoURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.username)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 4) {
                    Text("Plan:")
                        .foregroundColor(.secondary)
                    Text("Freemium")
                        .foregroundColor(.green)
                }
            }

            Spacer()

            NavigationLink(destination: editProfileView(), isActive: $navigateToEdit) {
                EmptyView()
            }

            Button(action: {
                navigateToEdit = true
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("secondaryButton"))
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(16)
    }
}


struct ProfileItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let enabled: Bool
    let destination: AnyView?
    let action: (() -> Void)?

    init(icon: String, iconColor: Color, title: String, enabled: Bool, destination: AnyView) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.enabled = enabled
        self.destination = destination
        self.action = nil
    }

    init(icon: String, iconColor: Color, title: String, enabled: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.enabled = enabled
        self.destination = nil
        self.action = action
    }
}


struct SettingsRow: View {
    let item: ProfileItem

    var body: some View {
        Group {
            if let destination = item.destination {
                NavigationLink(destination: destination) {
                    RowContent
                }
            } else {
                RowContent
                    .onTapGesture {
                        item.action?()
                    }
            }
        }
    }

    private var RowContent: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.iconColor.opacity(0.2))
                    .frame(width: 36, height: 36)

                Image(systemName: item.icon)
                    .foregroundColor(item.iconColor)
                    .font(.system(size: 16, weight: .medium))
            }

            Text(item.title)
                .foregroundColor(.primary)

            Spacer()

            if item.destination != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("secondaryButton"))
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
       
    }
    
}

// MARK: attemp to bring the line back,, kinda cooked abhi
//struct SettingsRow: View {
//    let item: ProfileItem
//
//    var body: some View {
//        Group {
//            if let destination = item.destination {
//                NavigationLink(destination: destination) {
//                    RowWithDivider
//                }
//            } else {
//                RowWithDivider
//                    .onTapGesture {
//                        item.action?()
//                    }
//            }
//        }
//    }
//
//    private var RowWithDivider: some View {
//        VStack(spacing: 0) {
//            RowContent
//                .padding(.bottom)
//            Divider()
//                .padding(.leading, 48)
//        }
//    }
//
//    private var RowContent: some View {
//        HStack(spacing: 12) {
//            ZStack {
//                Circle()
//                    .fill(item.iconColor.opacity(0.2))
//                    .frame(width: 36, height: 36)
//
//                Image(systemName: item.icon)
//                    .foregroundColor(item.iconColor)
//                    .font(.system(size: 16, weight: .medium))
//            }
//
//            Text(item.title)
//                .foregroundColor(.primary)
//
//            Spacer()
//
//            if item.destination != nil {
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(Color("secondaryButton"))
//            }
//        }
//        .padding(.vertical, 2)
//        .contentShape(Rectangle())
//    }
//}
