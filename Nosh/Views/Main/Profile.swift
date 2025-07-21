//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import SDWebImageSwiftUI
//
//struct Profile: View {
//    @StateObject private var viewModel = UserProfileViewModel()
//    @State private var navigateToEdit = false
//    @State private var showCustomAlert = false
//    @State private var showPopup = false
//    @State private var popupTitle = false
//    @State private var popupAction = false
//    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var onConfirm: (() -> Void)? = nil
//
//
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//                Color("primaryBackground").ignoresSafeArea()
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 20) {
//                        VStack(spacing: 20) {
//                            ProfileCard
//                                .padding(.horizontal)
//
//                            SettingsSection(title: "Account", items: [
//                                ProfileItem(icon: "creditcard", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
//                                ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
//                                ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
//                            ])
//
//                            SettingsSection(title: "Meal Preferences", items: [
//                                ProfileItem(icon: "leaf", iconColor: .green, title: "Diet Type", enabled: true, destination: AnyView(dietTypeView())),
//                                ProfileItem(icon: "exclamationmark.triangle", iconColor: .red, title: "Allergens", enabled: true, destination: AnyView(allergensView())),
//                                ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true, destination: AnyView(mealScheduleView())),
//                                ProfileItem(icon: "cart", iconColor: .blue, title: "Grocery Preferences", enabled: true, destination: AnyView(groceryPreferencesView()))
//                            ])
//
//                            SettingsSection(title: "App Settings", items: [
//                                ProfileItem(icon: "figure", iconColor: .blue, title: "Accessibility", enabled: true, destination: AnyView(accessibilityView())),
//                                ProfileItem(icon: "paintbrush", iconColor: .blue, title: "Theme", enabled: true, destination: AnyView(themeView()))
//                            ])
//
//                            SettingsSection(title: "Support", items: [
//                                ProfileItem(icon: "headphones", iconColor: .blue, title: "Customer Support", enabled: true, destination: AnyView(customerSupportView())),
//                                ProfileItem(icon: "doc.text", iconColor: .gray, title: "Terms of Use", enabled: true, destination: AnyView(termsOfUseView())),
//                                ProfileItem(icon: "lock", iconColor: .gray, title: "Privacy Policy", enabled: true, destination: AnyView(privacyPolicyView()))
//                            ])
//
////                            SettingsSection(title: "Danger Zone", items: [
////                                ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true, destination: AnyView(resetDefaultsView())),
////                                ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, destination: AnyView(logOutView())),
////                                ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, destination: AnyView(deleteAccountView()))
////                                ])
//                            DangerSection(
//                                items: [
//                                    ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true, destination: AnyView(EmptyView())),
//                                    ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, destination: AnyView(EmptyView())),
//                                    ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, destination: AnyView(EmptyView()))
//                                ],
//                                showPopup: $showPopup,
//                                popupTitle: $popupTitle,
//                                popupAction: $popupAction
//                            )
//
//                            
//                        }
//                        .padding(.top, 100)
//
//                        Spacer().padding(.bottom, 80)
//                    }
//                }
//                //overlay working this is related to the customAlert
//                .overlay(
//                    Group {
//                        if showCustomAlert {
//                            Color.black.opacity(0.4)
//                                .ignoresSafeArea()
//
//                            CustomAlert(
//                                title: alertTitle,
//                                message: alertMessage,
//                                confirmAction: {
//                                    onConfirm?()
//                                    showCustomAlert = false
//                                },
//                                cancelAction: {
//                                    showCustomAlert = false
//                                }
//                            )
//                        }
//                    }
//                )
//
//
//                
//                ProfileHeader
//            }
//        }
//    }
//
//    private var ProfileHeader: some View {
//        HStack {
//            Text("Profile")
//                .font(.largeTitle.bold())
//                .foregroundColor(Color("primaryText"))
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 20)
//        .background(Color("primaryCard"))
//    }
//
//    private var ProfileCard: some View {
//        HStack(alignment: .center, spacing: 16) {
//            if let photoURL = viewModel.photoURL {
//                WebImage(url: photoURL)
//                    .resizable()
//                    .onFailure { error in
//                        print("Image failed to load:", error.localizedDescription)
//                    }
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.25))
//                    .scaledToFill()
//                    .frame(width: 60, height: 60)
//                    .clipShape(Circle())
//            } else {
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 60, height: 60)
//                    .foregroundColor(.gray)
//            }
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(viewModel.username)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//
//                HStack(spacing: 4) {
//                    Text("Plan:")
//                        .foregroundColor(.secondary)
//                    Text("Freemium")
//                        .foregroundColor(.green)
//                }
//            }
//
//            Spacer()
//
//            NavigationLink(destination: editProfileView(), isActive: $navigateToEdit) {
//                EmptyView()
//            }
//
//            Button(action: {
//                navigateToEdit = true
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Color("secondaryIcon"))
//                    .clipShape(Circle())
//            }
//        }
//        .padding()
//        .background(Color("primaryCard"))
//        .cornerRadius(16)
//    }
//}
//
//struct ProfileItem: Identifiable {
//    let id = UUID()
//    let icon: String
//    let iconColor: Color
//    let title: String
//    let enabled: Bool
//    let destination: AnyView
//}
//
//struct SettingsSection: View {
//    let title: String
//    let items: [ProfileItem]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(Color("primaryText"))
//                .padding(.horizontal)
//                .padding(.top)
//                .padding(.bottom, 10)
//
//            ForEach(items) { item in
//                if item.enabled {
//                    NavigationLink(destination: item.destination) {
//                        HStack(spacing: 12) {
//                            ZStack {
//                                Circle()
//                                    .fill(item.iconColor.opacity(0.2))
//                                    .frame(width: 36, height: 36)
//                                Image(systemName: item.icon)
//                                    .foregroundColor(item.iconColor)
//                            }
//
//                            Text(item.title)
//                                .foregroundColor(.primary)
//
//                            Spacer()
//
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 10)
//                    }
//
//                    Divider()
//                        .padding(.leading, 64)
//                }
//            }
//        }
//        .background(Color("primaryCard"))
//        .cornerRadius(16)
//        .padding(.horizontal, 16)
//    }
//}
//
//struct DangerSection: View {
//    let items: [ProfileItem]
//
//    @Binding var showPopup: Bool
//    @Binding var popupTitle: String
//    @Binding var popupAction: (() -> Void)?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text("Danger Zone")
//                .font(.headline)
//                .foregroundColor(.red)
//                .padding(.horizontal)
//                .padding(.top)
//
//            ForEach(items) { item in
//                Button {
//                    popupTitle = item.title
//                    popupAction = {
//                        // handle item.title here if needed
//                    }
//                    showPopup = true
//                } label: {
//                    HStack(spacing: 12) {
//                        Image(systemName: item.icon)
//                            .foregroundColor(item.iconColor)
//                            .frame(width: 24, height: 24)
//
//                        Text(item.title)
//                            .foregroundColor(.primary)
//
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 10)
//                    .background(Color("primaryCard"))
//                }
//
//                Divider().padding(.leading, 52)
//            }
//        }
//    }
//}
//

// Revised SwiftUI code with proper ProfileItem support for optional actions and navigation
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
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("secondaryIcon"))
                    .clipShape(Circle())
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

struct SettingsSection: View {
    let title: String
    let items: [ProfileItem]
    var isActionSection: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("primaryText"))
//                .foregroundColor(isActionSection ? .red : Color("primaryText"))
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 10)

            ForEach(items) { item in
                if item.enabled {
                    if let action = item.action {
                        Button(action: action) {
                            SettingsRow(item: item)
                        }
                    } else if let destination = item.destination {
                        NavigationLink(destination: destination) {
                            SettingsRow(item: item)
                        }
                    }

                    Divider().padding(.leading, 64)
                }
            }
        }
        .background(Color("primaryCard"))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

struct SettingsRow: View {
    let item: ProfileItem

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.iconColor.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: item.icon)
                    .foregroundColor(item.iconColor)
            }

            Text(item.title)
                .foregroundColor(.primary)

            Spacer()

            if item.destination != nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
