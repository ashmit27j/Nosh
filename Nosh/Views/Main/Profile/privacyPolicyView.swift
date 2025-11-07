import SwiftUI

struct privacyPolicyView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Policy")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("Last Updated: November 6, 2025")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryTextColor)
                }
                .padding(.top, 8)
                
                // Introduction
                PolicySection(
                    title: "Introduction",
                    content: "Welcome to Nosh. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use our recipe and meal planning application."
                )
                
                // Information We Collect
                PolicySection(
                    title: "Information We Collect",
                    content: """
                    We collect several types of information to provide and improve our service:
                    
                    • Account Information: Name, email address, and profile details
                    • Recipe Data: Your saved recipes, meal plans, and dietary preferences
                    • Pantry Information: Items you add to your virtual pantry
                    • Usage Data: How you interact with the app and AI Chef features
                    • Device Information: Device type, operating system, and app version
                    • Location Data: Optional, only if you enable location-based features
                    """
                )
                
                // How We Use Your Information
                PolicySection(
                    title: "How We Use Your Information",
                    content: """
                    Your information helps us provide personalized experiences:
                    
                    • Deliver personalized recipe recommendations via AI Chef
                    • Store and sync your recipes and pantry across devices
                    • Improve our meal suggestion algorithms
                    • Send important updates about your account
                    • Analyze app usage to enhance features
                    • Provide customer support when you need help
                    """
                )
                
                // Data Storage and Security
                PolicySection(
                    title: "Data Storage and Security",
                    content: """
                    We take security seriously and implement industry-standard measures:
                    
                    • All data is stored securely using Firebase with encryption
                    • Passwords are encrypted and never stored in plain text
                    • Data transmission uses secure HTTPS protocols
                    • Regular security audits and updates
                    • Access controls to limit who can view your data
                    • Automatic logout after periods of inactivity
                    """
                )
                
                // Data Sharing
                PolicySection(
                    title: "Data Sharing and Third Parties",
                    content: """
                    We do not sell your personal information. We may share data only in these cases:
                    
                    • With your explicit consent
                    • To comply with legal obligations
                    • With service providers who help operate the app (e.g., Firebase, Cloudinary)
                    • In aggregated, anonymized form for analytics
                    • To protect rights, property, or safety of Nosh and our users
                    """
                )
                
                // Your Rights
                PolicySection(
                    title: "Your Privacy Rights",
                    content: """
                    You have control over your personal data:
                    
                    • Access: View all data we have about you
                    • Update: Modify your account information anytime
                    • Delete: Request complete deletion of your account and data
                    • Export: Download your recipes and data in portable format
                    • Opt-out: Unsubscribe from marketing communications
                    • Object: Contest automated decision-making processes
                    """
                )
                
                // Cookies and Tracking
                PolicySection(
                    title: "Cookies and Tracking",
                    content: """
                    We use minimal tracking technologies:
                    
                    • Essential cookies for app functionality
                    • Analytics to understand feature usage
                    • No third-party advertising cookies
                    • You can disable analytics in Settings > Privacy
                    """
                )
                
                // Children's Privacy
                PolicySection(
                    title: "Children's Privacy",
                    content: "Nosh is not intended for children under 13. We do not knowingly collect personal information from children. If you believe a child has provided us with personal data, please contact us immediately."
                )
                
                // Changes to Privacy Policy
                PolicySection(
                    title: "Changes to This Policy",
                    content: "We may update this privacy policy periodically. We will notify you of significant changes via email or app notification. Continued use of Nosh after changes indicates your acceptance of the updated policy."
                )
                
                // Contact Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Us")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("If you have questions about this privacy policy or your data:")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryTextColor)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ContactInfoRow(icon: "envelope.fill", text: "privacy@noshapp.com")
                        ContactInfoRow(icon: "globe", text: "www.noshapp.com/privacy")
                        ContactInfoRow(icon: "location.fill", text: "123 Recipe Lane, Food City, FC 12345")
                    }
                }
                .padding(20)
                .background(surfaceColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(cardBorderColor, lineWidth: 1)
                )
                
                // Footer Note
                Text("By using Nosh, you agree to this privacy policy and our Terms of Service.")
                    .font(.system(size: 13))
                    .foregroundColor(secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            .padding(20)
        }
        .background(backgroundColor.ignoresSafeArea())
    }
    
    // MARK: - Color Scheme
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 31/255, green: 33/255, blue: 33/255) : Color(red: 252/255, green: 252/255, blue: 249/255)
    }
    
    private var surfaceColor: Color {
        colorScheme == .dark ? Color(red: 38/255, green: 40/255, blue: 40/255) : Color(red: 255/255, green: 255/255, blue: 253/255)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 167/255, green: 169/255, blue: 169/255).opacity(0.7) : Color(red: 98/255, green: 108/255, blue: 113/255)
    }
    
    private var cardBorderColor: Color {
        colorScheme == .dark ? Color(red: 119/255, green: 124/255, blue: 124/255).opacity(0.2) : Color(red: 94/255, green: 82/255, blue: 64/255).opacity(0.12)
    }
}

// MARK: - Policy Section Component

struct PolicySection: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
            
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(secondaryTextColor)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(surfaceColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cardBorderColor, lineWidth: 1)
        )
    }
    
    private var surfaceColor: Color {
        colorScheme == .dark ? Color(red: 38/255, green: 40/255, blue: 40/255) : Color(red: 255/255, green: 255/255, blue: 253/255)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 167/255, green: 169/255, blue: 169/255).opacity(0.7) : Color(red: 98/255, green: 108/255, blue: 113/255)
    }
    
    private var cardBorderColor: Color {
        colorScheme == .dark ? Color(red: 119/255, green: 124/255, blue: 124/255).opacity(0.2) : Color(red: 94/255, green: 82/255, blue: 64/255).opacity(0.12)
    }
}

// MARK: - Contact Info Row Component

struct ContactInfoRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(primaryColor)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(textColor)
        }
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
    
    private var primaryColor: Color {
        colorScheme == .dark ? Color(red: 50/255, green: 184/255, blue: 198/255) : Color(red: 33/255, green: 128/255, blue: 141/255)
    }
}
