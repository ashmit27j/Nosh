import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Profile: View {
    @ObservedObject var pantryViewModel: PantryViewModel
    @EnvironmentObject private var accessibility: AccessibilityEnvironment
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var showEditProfile = false
    @State private var showPopup = false
    @State private var popupTitle = ""
    @State private var popupMessage = ""
    @State private var popupAction: (() -> Void)? = nil
    @State private var showReauthSheet = false
    @State private var reauthPassword = ""
    @State private var isWorking = false

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
                                    // Re-enable once StoreKit purchasing is implemented — the
                                    // screen advertises a price and a trial but takes no payment.
                                    // ProfileItem(icon: "creditcard.fill", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
                                    ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
                                    ProfileItem(icon: "lock.shield.fill", iconColor: .blue, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
                                ]
                            )

                            // Meal Preferences section is hidden until Diet Type,
                            // Allergens, Meal Schedule and Grocery Preferences exist.

                            // App Settings Section
                            SettingsSection(
                                title: "App Settings",
                                items: [
                                    ProfileItem(icon: "figure.walk", iconColor: .purple, title: "Accessibility", enabled: true, destination: AnyView(accessibilityView())),
                                    ProfileItem(icon: "paintbrush.fill", iconColor: .purple, title: "Theme", enabled: true, destination: AnyView(themeView())),
                                    ProfileItem(icon: "arrow.counterclockwise", iconColor: .purple, title: "Reset to Defaults", enabled: true, action: {
                                        popupTitle = "Reset to Defaults"
                                        popupMessage = "Are you sure you want to reset all app settings?"
                                        popupAction = { resetToDefaults() }
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
                                        popupAction = { signOut() }
                                        showPopup = true
                                    }),
                                    ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, action: {
                                        popupTitle = "Delete Account"
                                        popupMessage = "This permanently deletes your profile, pantry and meal plans. This cannot be undone."
                                        popupAction = { beginAccountDeletion() }
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
                                    // Dismiss first, then run: the action may
                                    // raise its own alert, and clearing the flag
                                    // afterwards used to swallow it immediately.
                                    let action = popupAction
                                    showPopup = false
                                    popupAction = nil
                                    action?()
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
            .sheet(isPresented: $showReauthSheet) {
                ReauthenticationSheet(password: $reauthPassword) {
                    showReauthSheet = false
                    performDeletion(password: reauthPassword)
                }
            }
        }
    }

    // MARK: - Account actions

    private func signOut() {
        do {
            // Single sign-out path: clears the Google session too, so the next
            // sign-in shows an account chooser instead of silently reusing one.
            try AuthenticationManager.shared.signOut()
            pantryViewModel.clearPantry()
        } catch {
            present(title: "Error", message: error.localizedDescription)
        }
    }

    private func beginAccountDeletion() {
        guard let user = Auth.auth().currentUser else {
            present(title: "Error", message: "No user is currently signed in.")
            return
        }

        // Firebase requires a recent login before deleting an account.
        switch AccountService.shared.reauthMethod(for: user) {
        case .password:
            reauthPassword = ""
            showReauthSheet = true
        case .google, .unknown:
            performDeletion(password: nil)
        }
    }

    private func performDeletion(password: String?) {
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                try await AccountService.shared.reauthenticate(password: password)
                try await AccountService.shared.deleteAccount()
                pantryViewModel.clearPantry()
                // AppState's auth listener drives the return to the sign-in screen.
            } catch {
                present(title: "Couldn't Delete Account", message: error.localizedDescription)
            }
            reauthPassword = ""
        }
    }

    private func resetToDefaults() {
        accessibility.textSize = .medium
        accessibility.highContrast = false
        accessibility.reduceMotion = false
        accessibility.boldText = false
        accessibility.hapticFeedback = true
        accessibility.voiceOverEnabled = false
        accessibility.accentHex = "#16E51D"
    }

    private func present(title: String, message: String) {
        popupTitle = title
        popupMessage = message
        popupAction = nil
        showPopup = true
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

/// Pure presentation. Navigation and tap handling belong to `SettingsSection`;
/// having both build a NavigationLink nested one inside the other, which breaks
/// tap targets and makes each row announce as two buttons to VoiceOver.
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
                    if let destination = item.destination {
                        NavigationLink(destination: destination) {
                            SettingsRow(item: item)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button {
                            item.action?()
                        } label: {
                            SettingsRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

/// Asks for the current password before a destructive account action.
/// Firebase rejects `user.delete()` with `requiresRecentLogin` otherwise.
struct ReauthenticationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var password: String
    let onConfirm: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground").ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Confirm your password")
                        .font(.title3.bold())
                        .foregroundColor(Color("primaryText"))

                    Text("For your security, enter your password to delete your account.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color("primaryCard"))
                        .cornerRadius(12)

                    Button(action: onConfirm) {
                        Text("Delete Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(password.isEmpty ? Color.gray : Color.red)
                            .cornerRadius(12)
                    }
                    .disabled(password.isEmpty)

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        password = ""
                        dismiss()
                    }
                }
            }
        }
    }
}
