//
//  termsOfUseView.swift
//  Nosh
//
//  Created by MacBook on 21/07/25.
//

import SwiftUI

struct termsOfUseView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms of Use")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("Last Updated: November 6, 2025")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryTextColor)
                }
                .padding(.top, 8)
                
                // Introduction
                PolicySection(
                    title: "Agreement to Terms",
                    content: "By accessing or using Nosh, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use our application. These terms constitute a legally binding agreement between you and Nosh."
                )
                
                // Account Terms
                PolicySection(
                    title: "Account Registration",
                    content: """
                    To use Nosh, you must create an account:
                    
                    • You must be at least 13 years old to create an account
                    • Provide accurate and complete registration information
                    • Maintain the security of your account credentials
                    • You are responsible for all activities under your account
                    • Notify us immediately of any unauthorized access
                    • One person or entity may maintain only one free account
                    """
                )
                
                // Acceptable Use
                PolicySection(
                    title: "Acceptable Use",
                    content: """
                    You agree to use Nosh only for lawful purposes. You must not:
                    
                    • Violate any applicable laws or regulations
                    • Infringe on intellectual property rights
                    • Upload malicious code or viruses
                    • Attempt to gain unauthorized access to our systems
                    • Harass, abuse, or harm other users
                    • Scrape or extract data using automated means
                    • Use the app for any commercial purpose without permission
                    • Share your account with others
                    """
                )
                
                // Intellectual Property
                PolicySection(
                    title: "Intellectual Property Rights",
                    content: """
                    All content and features in Nosh are protected by intellectual property laws:
                    
                    • Nosh owns all rights to the app, design, and AI Chef technology
                    • You retain ownership of recipes and content you create
                    • By uploading content, you grant us license to store and display it
                    • You may not copy, modify, or distribute our app or content
                    • Our trademarks and logos may not be used without permission
                    • Third-party recipe sources retain their original copyrights
                    """
                )
                
                // Subscriptions and Payments
                PolicySection(
                    title: "Subscriptions and Payments",
                    content: """
                    Premium features require a paid subscription:
                    
                    • Free trial periods are available for new users
                    • Subscriptions auto-renew unless cancelled
                    • Prices are subject to change with notice
                    • Cancellation takes effect at end of current billing period
                    • Refunds are provided according to our refund policy
                    • You are responsible for applicable taxes
                    • Payment processed through Apple App Store or Google Play
                    """
                )
                
                // User Content
                PolicySection(
                    title: "User-Generated Content",
                    content: """
                    You are responsible for content you create or share:
                    
                    • You own the recipes and content you create
                    • You grant us license to display and store your content
                    • You represent that you have rights to share any content
                    • We may remove content that violates these terms
                    • We are not responsible for user-generated content
                    • Backup your important recipes - we're not liable for data loss
                    """
                )
                
                // AI Chef Disclaimer
                PolicySection(
                    title: "AI Chef and Recipe Recommendations",
                    content: """
                    Our AI Chef feature provides recipe suggestions:
                    
                    • Recommendations are for informational purposes only
                    • We don't guarantee accuracy of nutritional information
                    • Always verify recipes and ingredients for allergies
                    • Follow safe food handling and cooking practices
                    • We're not liable for results from following recipes
                    • AI suggestions may not suit all dietary restrictions
                    """
                )
                
                // Disclaimers
                PolicySection(
                    title: "Disclaimers and Limitations",
                    content: """
                    Nosh is provided "as is" without warranties:
                    
                    • We don't guarantee uninterrupted or error-free service
                    • Features may change or be discontinued
                    • We're not liable for indirect or consequential damages
                    • Our total liability is limited to subscription fees paid
                    • Some jurisdictions don't allow liability limitations
                    • You use the app at your own risk
                    """
                )
                
                // Termination
                PolicySection(
                    title: "Termination",
                    content: """
                    We may suspend or terminate your account:
                    
                    • For violation of these terms
                    • For fraudulent or illegal activity
                    • At our discretion for any reason
                    • You may delete your account anytime in Settings
                    • Upon termination, your license to use Nosh ends
                    • Some provisions survive termination (privacy, disputes)
                    """
                )
                
                // Changes to Terms
                PolicySection(
                    title: "Changes to Terms",
                    content: "We may modify these terms at any time. Significant changes will be notified via email or in-app notification. Continued use after changes constitutes acceptance of new terms. If you don't agree, stop using Nosh."
                )
                
                // Governing Law
                PolicySection(
                    title: "Governing Law",
                    content: "These terms are governed by the laws of [Your Jurisdiction]. Disputes will be resolved in courts of [Your Jurisdiction]. If any provision is unenforceable, remaining terms stay in effect."
                )
                
                // Contact Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Us")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("Questions about these terms?")
                        .font(.system(size: 14))
                        .foregroundColor(secondaryTextColor)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ContactInfoRow(icon: "envelope.fill", text: "legal@noshapp.com")
                        ContactInfoRow(icon: "globe", text: "www.noshapp.com/terms")
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
                Text("By continuing to use Nosh, you acknowledge that you have read and agree to these Terms of Use.")
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

#Preview {
    termsOfUseView()
}
