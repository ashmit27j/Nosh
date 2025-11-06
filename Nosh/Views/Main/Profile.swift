import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Profile: View {
    @ObservedObject var pantryViewModel: PantryViewModel
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var showEditProfile = false
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
                            // Tappable Profile Card
                            ProfileCard
                                .padding(.horizontal)
                                .onTapGesture {
                                    showEditProfile = true
                                }

                            // Your Account Section
                            SettingsSection(
                                title: "Your Account",
                                items: [
                                    ProfileItem(icon: "creditcard.fill", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
                                    ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
                                    ProfileItem(icon: "lock.shield.fill", iconColor: .blue, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
                                ]
                            )

                            // Meal Preferences Section
                            SettingsSection(
                                title: "Meal Preferences",
                                items: [
//                                    ProfileItem(icon: "leaf.fill", iconColor: .green, title: "Diet Type", enabled: true, destination: AnyView(dietTypeView())),
                                    ProfileItem(icon: "exclamationmark.triangle.fill", iconColor: .orange, title: "Allergens", enabled: true, destination: AnyView(allergensView())),
//                                    ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true, destination: AnyView(mealScheduleView())),
                                    ProfileItem(icon: "cart.fill", iconColor: .green, title: "Grocery Preferences", enabled: true, destination: AnyView(groceryPreferencesView()))
                                ]
                            )

                            // App Settings Section
                            SettingsSection(
                                title: "App Settings",
                                items: [
                                    ProfileItem(icon: "figure.walk", iconColor: .purple, title: "Accessibility", enabled: true, destination: AnyView(accessibilityView())),
                                    ProfileItem(icon: "paintbrush.fill", iconColor: .purple, title: "Theme", enabled: true, destination: AnyView(themeView())),
                                    ProfileItem(icon: "arrow.counterclockwise", iconColor: .purple, title: "Reset to Defaults", enabled: true, action: {
                                        popupTitle = "Reset to Defaults"
                                        popupMessage = "Are you sure you want to reset all app settings?"
                                        popupAction = { print("Reset action") }
                                        showPopup = true
                                    })
                                ]
                            )

                            // Support & Information Section
                            SettingsSection(
                                title: "Support",
                                items: [
                                    ProfileItem(icon: "headphones", iconColor: .gray, title: "Customer Support", enabled: true, destination: AnyView(customerSupportView())),
                                    ProfileItem(icon: "doc.text.fill", iconColor: .gray, title: "Terms of Use", enabled: true, destination: AnyView(termsOfUseView())),
                                    ProfileItem(icon: "lock.doc.fill", iconColor: .gray, title: "Privacy Policy", enabled: true, destination: AnyView(privacyPolicyView()))
                                ]
                            )

                            // Account Actions Section (formerly Danger Zone)
                            SettingsSection(
                                title: "Account Actions",
                                items: [
                                    ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, action: {
                                        popupTitle = "Log Out"
                                        popupMessage = "Are you sure you want to log out?"
                                        popupAction = {
                                            do {
                                                pantryViewModel.clearPantry()
                                                try Auth.auth().signOut()
                                                print("✅ Logged out and pantry cleared")
                                            } catch {
                                                print("Error signing out: \(error.localizedDescription)")
                                            }
                                        }
                                        showPopup = true
                                    }),
                                    ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, action: {
                                        popupTitle = "Delete Account"
                                        popupMessage = "This action is permanent and cannot be undone. All your data will be deleted."
                                        popupAction = {
                                            guard let user = Auth.auth().currentUser else {
                                                popupTitle = "Error"
                                                popupMessage = "No user is currently signed in."
                                                showPopup = true
                                                return
                                            }

                                            let db = Firestore.firestore()
                                            
                                            db.collection("users").document(user.uid).delete { firestoreError in
                                                if let firestoreError = firestoreError {
                                                    popupTitle = "Error"
                                                    popupMessage = "Failed to delete user data: \(firestoreError.localizedDescription)"
                                                    showPopup = true
                                                    return
                                                }

                                                user.delete { authError in
                                                    if let authError = authError {
                                                        popupTitle = "Error"
                                                        popupMessage = "Failed to delete account: \(authError.localizedDescription)"
                                                        showPopup = true
                                                    } else {
                                                        popupTitle = "Account Deleted"
                                                        popupMessage = "Your account has been deleted successfully."
                                                        showPopup = true
                                                    }
                                                }
                                            }
                                        }
                                        showPopup = true
                                    })
                                ],
                                isActionSection: true
                            )
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
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(viewModel: viewModel)
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
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.username)
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                if let email = Auth.auth().currentUser?.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text("Free Plan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("secondaryButton"))
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
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
                .font(.body)

            Spacer()

            if item.destination != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("secondaryButton"))
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

struct SettingsSection: View {
    let title: String
    let items: [ProfileItem]
    var isActionSection: Bool = false

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 4)

                ForEach(items) { item in
                    Group {
                        if let destination = item.destination {
                            NavigationLink(destination: destination) {
                                SettingsRow(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            SettingsRow(item: item)
                                .onTapGesture {
                                    item.action?()
                                }
                        }
                    }
                }
            }
        }
    }
}
