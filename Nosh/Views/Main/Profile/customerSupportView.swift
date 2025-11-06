//
//  customerSupportView.swift
//  Nosh
//
//  Created by MacBook on 21/07/25.
//

import SwiftUI
import MessageUI

struct customerSupportView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var expandedFAQs: Set<Int> = []
    @State private var showMailComposer = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Primary accent color - Lime Green
    private let primaryAccent = Color(red: 150/255, green: 229/255, blue: 23/255)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customer Support")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("We're here to help! Choose how you'd like to reach us.")
                        .font(.system(size: 15))
                        .foregroundColor(secondaryTextColor)
                }
                .padding(.top, 8)
                
                // Contact Methods
                VStack(spacing: 16) {
                    ContactCard(
                        icon: "envelope.fill",
                        title: "Email Us",
                        description: "support@noshapp.com",
                        accent: primaryAccent,
                        action: { handleEmailContact() }
                    )
                    
                    ContactCard(
                        icon: "phone.fill",
                        title: "Call Us",
                        description: "+1 (800) 555-NOSH",
                        accent: primaryAccent,
                        action: { handlePhoneContact() }
                    )
                    
                    ContactCard(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "Live Chat",
                        description: "Chat with our support team",
                        accent: primaryAccent,
                        action: { handleChatContact() }
                    )
                    
                    ContactCard(
                        icon: "at",
                        title: "Social Media",
                        description: "@NoshApp on Twitter & Instagram",
                        accent: primaryAccent,
                        action: { handleSocialContact() }
                    )
                }
                
                // FAQ Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Frequently Asked Questions")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    VStack(spacing: 12) {
                        FAQItem(
                            question: "How do I reset my password?",
                            answer: "Go to Settings > Account > Change Password. You can also use \"Forgot Password\" on the login screen to reset via email.",
                            isExpanded: expandedFAQs.contains(0),
                            onTap: { toggleFAQ(0) }
                        )
                        
                        FAQItem(
                            question: "How does the AI Chef feature work?",
                            answer: "The AI Chef analyzes your pantry items and dietary preferences to recommend personalized meal suggestions. It searches our database and online sources for recipes with ingredients, steps, and cook times.",
                            isExpanded: expandedFAQs.contains(1),
                            onTap: { toggleFAQ(1) }
                        )
                        
                        FAQItem(
                            question: "Can I share recipes with friends?",
                            answer: "Yes! Tap the share icon on any recipe to send it via message, email, or social media. Your friends don't need the app to view shared recipes.",
                            isExpanded: expandedFAQs.contains(2),
                            onTap: { toggleFAQ(2) }
                        )
                        
                        FAQItem(
                            question: "How do I manage my pantry items?",
                            answer: "Go to the Pantry tab to add, edit, or remove items. You can organize items by category and set expiration date reminders.",
                            isExpanded: expandedFAQs.contains(3),
                            onTap: { toggleFAQ(3) }
                        )
                        
                        FAQItem(
                            question: "Is my data secure?",
                            answer: "Absolutely. We use Firebase for secure data storage with encryption. Your personal information and recipes are protected and never shared without your permission.",
                            isExpanded: expandedFAQs.contains(4),
                            onTap: { toggleFAQ(4) }
                        )
                    }
                }
                
                // Support Hours
                VStack(alignment: .leading, spacing: 16) {
                    Text("Support Hours")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    VStack(spacing: 12) {
                        HoursRow(day: "Monday - Friday", time: "9:00 AM - 8:00 PM EST")
                        HoursRow(day: "Saturday", time: "10:00 AM - 6:00 PM EST")
                        HoursRow(day: "Sunday", time: "Closed")
                    }
                }
                .padding(20)
                .background(surfaceColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(cardBorderColor, lineWidth: 1)
                )
            }
            .padding(20)
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(
                subject: "Nosh App Support Request",
                recipients: ["support@noshapp.com"],
                body: """
                Hi Nosh Support Team,
                
                I need help with:
                
                
                
                ---
                App Version: 1.0
                Device: iOS
                User ID: [Auto-generated]
                """
            )
        }
        .alert("Contact Support", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Helper Functions
    
    private func toggleFAQ(_ index: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if expandedFAQs.contains(index) {
                expandedFAQs.remove(index)
            } else {
                expandedFAQs.insert(index)
            }
        }
    }
    
    private func handleEmailContact() {
        if MFMailComposeViewController.canSendMail() {
            showMailComposer = true
        } else {
            if let url = URL(string: "mailto:support@noshapp.com") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func handlePhoneContact() {
        if let url = URL(string: "tel://18005556674") {
            UIApplication.shared.open(url)
        }
    }
    
    private func handleChatContact() {
        alertMessage = "Opening live chat...\n\nIn a real app, this would open a chat interface with your support team."
        showAlert = true
    }
    
    private func handleSocialContact() {
        alertMessage = "Opening social media...\n\nIn a real app, this would link to your social media profiles."
        showAlert = true
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

// MARK: - Contact Card Component

struct ContactCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let description: String
    let accent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(secondaryBackgroundColor)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(accent)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(secondaryTextColor)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(secondaryTextColor)
            }
            .padding(20)
            .background(surfaceColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cardBorderColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
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
    
    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 119/255, green: 124/255, blue: 124/255).opacity(0.15) : Color(red: 94/255, green: 82/255, blue: 64/255).opacity(0.12)
    }
    
    private var cardBorderColor: Color {
        colorScheme == .dark ? Color(red: 119/255, green: 124/255, blue: 124/255).opacity(0.2) : Color(red: 94/255, green: 82/255, blue: 64/255).opacity(0.12)
    }
}

// MARK: - FAQ Item Component

struct FAQItem: View {
    @Environment(\.colorScheme) var colorScheme
    let question: String
    let answer: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Question
            Button(action: onTap) {
                HStack {
                    Text(question)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(textColor)
                        .rotationEffect(.degrees(isExpanded ? 45 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                .padding(16)
                .background(surfaceColor)
            }
            
            // Answer
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(secondaryTextColor)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(surfaceColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
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

// MARK: - Hours Row Component

struct HoursRow: View {
    @Environment(\.colorScheme) var colorScheme
    let day: String
    let time: String
    
    var body: some View {
        HStack {
            Text(day)
                .font(.system(size: 14))
                .foregroundColor(secondaryTextColor)
            
            Spacer()
            
            Text(time)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
        }
        .padding(.vertical, 4)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 167/255, green: 169/255, blue: 169/255).opacity(0.7) : Color(red: 98/255, green: 108/255, blue: 113/255)
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Mail Composer

struct MailComposeView: UIViewControllerRepresentable {
    let subject: String
    let recipients: [String]
    let body: String
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setSubject(subject)
        composer.setToRecipients(recipients)
        composer.setMessageBody(body, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    customerSupportView()
}
