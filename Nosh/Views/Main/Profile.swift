//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import SDWebImageSwiftUI // make sure this package is added via SPM
//
//struct Profile: View {
//    @StateObject private var viewModel = UserProfileViewModel()
//    @State private var navigateToEdit = false
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
//
//                            ProfileSection(title: "Account", items: [
//                                ProfileItem(icon: "creditcard", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
//                                ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
//                                ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
//                            ])
//                            
//                            ProfileSection(title: "Meal Preferences", items: [
//                                ProfileItem(icon: "leaf", iconColor: .green, title: "Diet Type", enabled: true, destination: AnyView(dietTypeView())),
//                                ProfileItem(icon: "exclamationmark.triangle", iconColor: .red, title: "Allergens", enabled: true, destination: AnyView(allergensView())),
//                                ProfileItem(icon: "calendar", iconColor: .purple, title: "Meal Schedule", enabled: true, destination: AnyView(mealScheduleView())),
//                                ProfileItem(icon: "cart", iconColor: .blue, title: "Grocery Preferences", enabled: true, destination: AnyView(groceryPreferencesView()))
//                            ])
//                            
//                            ProfileSection(title: "App Settings", items: [
//                                ProfileItem(icon: "figure", iconColor: .blue, title: "Accessibility", enabled: true, destination: AnyView(accessibilityView())),
//                                ProfileItem(icon: "paintbrush", iconColor: .blue, title: "Theme", enabled: true, destination: AnyView(themeView()))
//                                // Skipping Text Size as requested
//                            ])
//
//                            ProfileSection(title: "Support", items: [
//                                ProfileItem(icon: "headphones", iconColor: .blue, title: "Customer Support", enabled: true, destination: AnyView(customerSupportView())),
//                                ProfileItem(icon: "doc.text", iconColor: .gray, title: "Terms of Use", enabled: true, destination: AnyView(termsOfUseView())),
//                                ProfileItem(icon: "lock", iconColor: .gray, title: "Privacy Policy", enabled: true, destination: AnyView(privacyPolicyView()))
//                            ])
//                            
//                            ProfileSection(title: "Danger Zone", items: [
//                                ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true, destination: <#AnyView#>),
//                                ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, destination: <#AnyView#>),
//                                ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, destination: <#AnyView#>)
//                            ])
//                        }
//                        .padding(.horizontal, 16)
//                        .padding(.top, 100)
//
//                        Spacer().padding(.bottom, 80)
//                    }
//                }
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
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 20)
//        .background(Color("primaryCard"))
//    }
//
//    private var ProfileCard: some View {
//        
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
//            NavigationLink(
//                    destination: editProfileView(),
//                    isActive: $navigateToEdit,
//                    label: { EmptyView() }
//                )
//
//                Button(action: {
//                    navigateToEdit = true
//                }) {
//                    HStack(spacing: 8) {
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color("secondaryButton"))
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color("secondaryIcon"))
//                    .foregroundColor(.white)
//                    .clipShape(Capsule())
//                }
//        }
//        .padding()
//        .background(Color("primaryCard"))
//        .cornerRadius(16)
//    }
//
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
//struct ProfileSection: View {
//    let title: String
//    let items: [ProfileItem]
//
//    var body: some View {
//        Section(header: Text(title).font(.headline)) {
//            ForEach(items) { item in
//                if item.enabled {
//                    NavigationLink(destination: item.destination) {
//                        HStack {
//                            Image(systemName: item.icon)
//                                .foregroundColor(item.iconColor)
//                                .frame(width: 24, height: 24)
//                            Text(item.title)
//                                .foregroundColor(.primary)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.vertical, 8)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//private func handleItemAction(title: String) {
//    switch title {
//    case "Log Out":
//        do {
//            try Auth.auth().signOut()
//            print("Successfully signed out")
//            // Optionally navigate to login screen
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//
//    case "Delete Account":
//        if let user = Auth.auth().currentUser {
//            user.delete { error in
//                if let error = error {
//                    print("Error deleting account: \(error.localizedDescription)")
//                } else {
//                    print("Account deleted successfully")
//                    // Navigate to onboarding or login screen
//                }
//            }
//        }
//
//    default:
//        print("Tapped on \(title)")
//    }
//}
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Profile: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var navigateToEdit = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("primaryBackground").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(spacing: 20) {
                            ProfileCard
                                .padding(.horizontal)

                            SettingsSection(title: "Account", items: [
                                ProfileItem(icon: "creditcard", iconColor: .blue, title: "Subscription & Billing", enabled: true, destination: AnyView(subscriptionView())),
                                ProfileItem(icon: "bell.fill", iconColor: .blue, title: "Notifications", enabled: true, destination: AnyView(notificationsView())),
                                ProfileItem(icon: "lock.shield", iconColor: .gray, title: "Privacy & Security", enabled: true, destination: AnyView(privacyView()))
                            ])

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
                                ProfileItem(icon: "arrow.counterclockwise", iconColor: .orange, title: "Reset to Defaults", enabled: true, destination: AnyView(resetDefaultsView())),
                                ProfileItem(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "Log Out", enabled: true, destination: AnyView(logOutView())),
                                ProfileItem(icon: "trash.fill", iconColor: .red, title: "Delete Account", enabled: true, destination: AnyView(deleteAccountView()))
                            ])
                        }
//                        .padding(.horizontal, )
                        .padding(.top, 100)

                        Spacer().padding(.bottom, 80)
                    }
                }

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
                    .onFailure { error in
                        print("Image failed to load:", error.localizedDescription)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.25))
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
                HStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("secondaryButton"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("secondaryIcon"))
                .foregroundColor(.white)
                .clipShape(Capsule())
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
    let destination: AnyView
}

struct SettingsSection: View {
    let title: String
    let items: [ProfileItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink(destination: item.destination) {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .foregroundColor(item.iconColor)
                            .frame(width: 24, height: 24)

                        Text(item.title)
                            .foregroundColor(.primary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("primaryCard"))
                }

                Divider()
                    .padding(.leading, 52)
            }
        }
        .background(Color("primaryCard"))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}
