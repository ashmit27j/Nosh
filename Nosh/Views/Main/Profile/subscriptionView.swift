//
//  subscriptionView.swift
//  Nosh
//
//  Created by MacBook on 21/07/25.
//

import SwiftUI

struct subscriptionView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedPlan: SubscriptionPlan = .monthly
    @State private var showPaymentSheet = false
    
    // Primary accent color - Lime Green
    private let primaryAccent = Color(red: 150/255, green: 229/255, blue: 23/255)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nosh Premium")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    Text("Unlock unlimited recipes and AI-powered meal planning")
                        .font(.system(size: 15))
                        .foregroundColor(secondaryTextColor)
                }
                .padding(.top, 8)
                
                // Free Trial Banner
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 24))
                            .foregroundColor(primaryAccent)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Your Free Trial")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(textColor)
                            
                            Text("14 days free, then your subscription starts")
                                .font(.system(size: 13))
                                .foregroundColor(secondaryTextColor)
                        }
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [
                            primaryAccent.opacity(0.15),
                            primaryAccent.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(primaryAccent.opacity(0.3), lineWidth: 1)
                )
                
                // Premium Features
                VStack(alignment: .leading, spacing: 16) {
                    Text("Premium Features")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    VStack(spacing: 12) {
                        FeatureRow(icon: "sparkles", text: "Unlimited AI Chef recommendations", accent: primaryAccent)
                        FeatureRow(icon: "book.fill", text: "Access to 10,000+ premium recipes", accent: primaryAccent)
                        FeatureRow(icon: "chart.bar.fill", text: "Advanced meal planning and scheduling", accent: primaryAccent)
                        FeatureRow(icon: "cart.fill", text: "Smart grocery list generation", accent: primaryAccent)
                        FeatureRow(icon: "leaf.fill", text: "Nutritional tracking and analysis", accent: primaryAccent)
                        FeatureRow(icon: "arrow.triangle.2.circlepath", text: "Sync across all your devices", accent: primaryAccent)
                        FeatureRow(icon: "person.2.fill", text: "Family sharing (up to 6 members)", accent: primaryAccent)
                        FeatureRow(icon: "rectangle.stack.badge.minus", text: "Ad-free experience", accent: primaryAccent)
                    }
                }
                
                // Subscription Plans
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Your Plan")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    VStack(spacing: 12) {
                        SubscriptionCard(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly,
                            accent: primaryAccent,
                            onTap: { selectedPlan = .monthly }
                        )
                        
                        SubscriptionCard(
                            plan: .halfYearly,
                            isSelected: selectedPlan == .halfYearly,
                            accent: primaryAccent,
                            onTap: { selectedPlan = .halfYearly }
                        )
                        
                        SubscriptionCard(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly,
                            accent: primaryAccent,
                            onTap: { selectedPlan = .yearly }
                        )
                    }
                }
                
                // Subscribe Button
                Button(action: { showPaymentSheet = true }) {
                    HStack {
                        Text("Start Free Trial")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(buttonTextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(primaryAccent)
                    .cornerRadius(12)
                }
                .shadow(color: primaryAccent.opacity(0.3), radius: 8, y: 4)
                
                // Terms Text
                Text("Cancel anytime. After your free trial, you'll be charged \(selectedPlan.priceText) per \(selectedPlan.billingPeriod). Auto-renews unless cancelled 24 hours before period ends.")
                    .font(.system(size: 12))
                    .foregroundColor(secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                // Additional Info
                VStack(spacing: 12) {
                    InfoRow(icon: "checkmark.shield.fill", text: "Secure payment via App Store", accent: primaryAccent)
                    InfoRow(icon: "arrow.clockwise", text: "Cancel anytime, no questions asked", accent: primaryAccent)
                    InfoRow(icon: "lock.fill", text: "Your data is always encrypted", accent: primaryAccent)
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showPaymentSheet) {
            PaymentSheetView(selectedPlan: selectedPlan, accent: primaryAccent)
        }
    }
    
    // MARK: - Color Scheme
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 31/255, green: 33/255, blue: 33/255) : Color(red: 252/255, green: 252/255, blue: 249/255)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 167/255, green: 169/255, blue: 169/255).opacity(0.7) : Color(red: 98/255, green: 108/255, blue: 113/255)
    }
    
    private var buttonTextColor: Color {
        colorScheme == .dark ? Color(red: 19/255, green: 52/255, blue: 59/255) : Color(red: 252/255, green: 252/255, blue: 249/255)
    }
}

// MARK: - Subscription Plan Enum

enum SubscriptionPlan {
    case monthly
    case halfYearly
    case yearly
    
    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .halfYearly: return "6 Months"
        case .yearly: return "Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .monthly: return "₹199"
        case .halfYearly: return "₹999"
        case .yearly: return "₹1,799"
        }
    }
    
    var priceText: String {
        switch self {
        case .monthly: return "₹199"
        case .halfYearly: return "₹999"
        case .yearly: return "₹1,799"
        }
    }
    
    var billingPeriod: String {
        switch self {
        case .monthly: return "month"
        case .halfYearly: return "6 months"
        case .yearly: return "year"
        }
    }
    
    var monthlyEquivalent: String {
        switch self {
        case .monthly: return "₹199/month"
        case .halfYearly: return "₹167/month"
        case .yearly: return "₹150/month"
        }
    }
    
    var savings: String? {
        switch self {
        case .monthly: return nil
        case .halfYearly: return "Save 16%"
        case .yearly: return "Save 25%"
        }
    }
    
    var badge: String? {
        switch self {
        case .monthly: return nil
        case .halfYearly: return "Popular"
        case .yearly: return "Best Value"
        }
    }
}

// MARK: - Subscription Card Component

struct SubscriptionCard: View {
    @Environment(\.colorScheme) var colorScheme
    let plan: SubscriptionPlan
    let isSelected: Bool
    let accent: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Badge
                if let badge = plan.badge {
                    HStack {
                        Spacer()
                        Text(badge)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(buttonTextColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(accent)
                            .cornerRadius(6, corners: [.topRight])
                    }
                }
                
                HStack(alignment: .center, spacing: 16) {
                    // Radio Button
                    ZStack {
                        Circle()
                            .stroke(isSelected ? accent : borderColor, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Circle()
                                .fill(accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    // Plan Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(plan.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(textColor)
                            
                            if let savings = plan.savings {
                                Text(savings)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(accent.opacity(0.15))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(plan.monthlyEquivalent)
                            .font(.system(size: 13))
                            .foregroundColor(secondaryTextColor)
                    }
                    
                    Spacer()
                    
                    // Price
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(plan.price)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                        
                        Text("per \(plan.billingPeriod)")
                            .font(.system(size: 11))
                            .foregroundColor(secondaryTextColor)
                    }
                }
                .padding(20)
            }
            .background(surfaceColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? accent : borderColor, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? accent.opacity(0.15) : Color.clear, radius: 8, y: 4)
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
    
    private var borderColor: Color {
        colorScheme == .dark ? Color(red: 119/255, green: 124/255, blue: 124/255).opacity(0.2) : Color(red: 94/255, green: 82/255, blue: 64/255).opacity(0.12)
    }
    
    private var buttonTextColor: Color {
        colorScheme == .dark ? Color(red: 19/255, green: 52/255, blue: 59/255) : Color(red: 252/255, green: 252/255, blue: 249/255)
    }
}

// MARK: - Feature Row Component

struct FeatureRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let text: String
    let accent: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(accent)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(textColor)
            
            Spacer()
        }
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255) : Color(red: 19/255, green: 52/255, blue: 59/255)
    }
}

// MARK: - Info Row Component

struct InfoRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let text: String
    let accent: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(accent)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(secondaryTextColor)
            
            Spacer()
        }
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 167/255, green: 169/255, blue: 169/255).opacity(0.7) : Color(red: 98/255, green: 108/255, blue: 113/255)
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


// MARK: - Payment Sheet View

struct PaymentSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    let selectedPlan: SubscriptionPlan
    let accent: Color
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(accent)
                
                Text("Complete Purchase")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(textColor)
                
                Text("Confirm your subscription to Nosh Premium")
                    .font(.system(size: 15))
                    .foregroundColor(secondaryTextColor)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Plan:")
                            .foregroundColor(secondaryTextColor)
                        Spacer()
                        Text(selectedPlan.title)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor)
                    }
                    
                    HStack {
                        Text("Price:")
                            .foregroundColor(secondaryTextColor)
                        Spacer()
                        Text(selectedPlan.price)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor)
                    }
                    
                    HStack {
                        Text("Free Trial:")
                            .foregroundColor(secondaryTextColor)
                        Spacer()
                        Text("14 days")
                            .fontWeight(.semibold)
                            .foregroundColor(accent)
                    }
                }
                .padding(20)
                .background(surfaceColor)
                .cornerRadius(12)
                
                Spacer()
                
                Button(action: {
                    // Handle payment via StoreKit
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Subscribe with App Store")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(buttonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(accent)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.system(size: 15))
                        .foregroundColor(secondaryTextColor)
                }
            }
            .padding(20)
            .background(backgroundColor.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
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
    
    private var buttonTextColor: Color {
        colorScheme == .dark ? Color(red: 19/255, green: 52/255, blue: 59/255) : Color(red: 252/255, green: 252/255, blue: 249/255)
    }
}

