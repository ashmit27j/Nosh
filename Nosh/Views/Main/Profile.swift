import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI // make sure this package is added via SPM

struct Profile: View {
    @StateObject private var viewModel = UserProfileViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("primaryBackground").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(spacing: 20) {
                            ProfileCard

                            ProfileSection(title: "Account", items: [
                                ProfileItem(icon: "person.crop.circle", iconColor: .orange, title: "Edit Profile", enabled: true),
                                ProfileItem(icon: "creditcard", iconColor: .blue, title: "Subscription & Billing", enabled: true),
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
                        }
                        .padding(.horizontal, 16)
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
//        HStack(alignment: .center) {
//            if let photoURL = viewModel.photoURL {
//                WebImage(url: photoURL)
//                    .resizable()
//                    .onFailure { error in
//                        print("Image failed to load:", error.localizedDescription)
//                    }
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.25))
//                    .frame(width: 60, height: 60)
//                    .clipShape(Circle())
//                    .overlay(
//                        Group {
//                            if photoURL == nil {
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    )
//            } else {
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 60, height: 60)
//                    .foregroundColor(.gray)
//            }
//
//            VStack(alignment: .leading) {
//                Text(viewModel.username)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//
//                Text("Plan: ") + Text("Freemium").foregroundColor(.green)
//            }
//
//            Spacer()
//
//            Button("Edit") {
//                // Handle edit action
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(Color.green)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//        }
//        .padding()
//        .background(Color("primaryCard"))
//        .cornerRadius(16)

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
                Button {
                    handleItemAction(title: item.title)
                } label: {
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
                }
                .disabled(!item.enabled)

                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(16)
    }
}

private func handleItemAction(title: String) {
    switch title {
    case "Log Out":
        do {
            try Auth.auth().signOut()
            print("Successfully signed out")
            // Optionally navigate to login screen
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }

    case "Delete Account":
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Error deleting account: \(error.localizedDescription)")
                } else {
                    print("Account deleted successfully")
                    // Navigate to onboarding or login screen
                }
            }
        }

    default:
        print("Tapped on \(title)")
    }
}

struct ProfileItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let enabled: Bool
}

