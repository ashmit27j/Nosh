import SwiftUI
import FirebaseAuth

struct UpdatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Update Password")
                            .font(.title2.bold())
                            .foregroundColor(Color("primaryText"))
                        
                        Text("Enter your current password and choose a new one.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        // Current Password Field
                        PasswordFieldWithToggle(
                            placeholder: "Current Password",
                            text: $currentPassword,
                            isSecure: $showCurrentPassword
                        )
                        
                        // New Password Field
                        PasswordFieldWithToggle(
                            placeholder: "New Password",
                            text: $newPassword,
                            isSecure: $showNewPassword
                        )
                        
                        // Confirm Password Field
                        PasswordFieldWithToggle(
                            placeholder: "Confirm New Password",
                            text: $confirmPassword,
                            isSecure: $showConfirmPassword
                        )
                        
                        // Password Requirements
                        if !newPassword.isEmpty {
                            PasswordRequirementsView(password: newPassword)
                        }
                        
                        // Confirmation Match Error
                        if !confirmPassword.isEmpty && newPassword != confirmPassword {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Button(action: updatePassword) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Update Password")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color("primaryButton") : Color.gray)
                    .cornerRadius(12)
                    .disabled(!isFormValid || isLoading)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                if alertTitle == "Success" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isFormValid: Bool {
        !currentPassword.isEmpty &&
        PasswordValidator.isValid(newPassword) &&
        newPassword == confirmPassword
    }
    
    private func updatePassword() {
        isLoading = true
        
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            alertTitle = "Error"
            alertMessage = "No user is currently signed in."
            showAlert = true
            isLoading = false
            return
        }
        
        // Re-authenticate user first
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = "Current password is incorrect: \(error.localizedDescription)"
                showAlert = true
                isLoading = false
                return
            }
            
            // Update password
            user.updatePassword(to: newPassword) { error in
                isLoading = false
                
                if let error = error {
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                } else {
                    alertTitle = "Success"
                    alertMessage = "Your password has been updated successfully."
                }
                showAlert = true
            }
        }
    }
}

// MARK: - Password Field With Toggle
struct PasswordFieldWithToggle: View {
    let placeholder: String
    @Binding var text: String
    @Binding var isSecure: Bool
    
    var body: some View {
        HStack {
            if isSecure {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .textContentType(.password)
            } else {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .textContentType(.password)
            }
            
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(12)
    }
}

// MARK: - Password Requirements View
struct PasswordRequirementsView: View {
    let password: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Password Requirements:")
                .font(.subheadline.bold())
                .foregroundColor(Color("primaryText"))
                .padding(.bottom, 4)
            
            RequirementRow(
                text: "At least 6 characters",
                isMet: password.count >= 6
            )
            
            RequirementRow(
                text: "One uppercase letter (A-Z)",
                isMet: password.range(of: "[A-Z]", options: .regularExpression) != nil
            )
            
            RequirementRow(
                text: "One lowercase letter (a-z)",
                isMet: password.range(of: "[a-z]", options: .regularExpression) != nil
            )
            
            RequirementRow(
                text: "One number (0-9)",
                isMet: password.range(of: "[0-9]", options: .regularExpression) != nil
            )
            
            RequirementRow(
                text: "One special character (!@#$%^&*)",
                isMet: password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color("primaryCard"))
        .cornerRadius(12)
    }
}

struct RequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isMet ? .green : .red)
                .font(.system(size: 16))
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(isMet ? .primary : .secondary)
            
            Spacer()
        }
    }
}

// MARK: - Password Validator
struct PasswordValidator {
    static func isValid(_ password: String) -> Bool {
        guard password.count >= 6 else { return false }
        
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        
        return hasUppercase && hasLowercase && hasNumber && hasSpecialChar
    }
}
