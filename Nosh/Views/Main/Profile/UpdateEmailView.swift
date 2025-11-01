import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UpdateEmailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword = ""
    @State private var newEmail = ""
    @State private var confirmEmail = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var currentEmail: String {
        Auth.auth().currentUser?.email ?? "No email"
    }
    
    var body: some View {
        ZStack {
            Color("primaryBackground").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Update Email")
                            .font(.title2.bold())
                            .foregroundColor(Color("primaryText"))
                        
                        HStack {
                            Text("Current Email:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(currentEmail)
                                .font(.subheadline.bold())
                                .foregroundColor(Color("primaryText"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        SecureField("Current Password", text: $currentPassword)
                            .padding()
                            .background(Color("primaryCard"))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                        
                        // Password Requirements for Email Update
                        if !currentPassword.isEmpty {
                            PasswordRequirementsView(password: currentPassword)
                        }
                        
                        TextField("New Email", text: $newEmail)
                            .padding()
                            .background(Color("primaryCard"))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        TextField("Confirm New Email", text: $confirmEmail)
                            .padding()
                            .background(Color("primaryCard"))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        // Email Validation Errors
                        if !newEmail.isEmpty && !newEmail.contains("@") {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Invalid email format")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !newEmail.isEmpty && newEmail == currentEmail {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("New email must be different from current email")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !confirmEmail.isEmpty && newEmail != confirmEmail {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Emails do not match")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Button(action: updateEmail) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Update Email")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color("primaryButton") : Color.gray)
                    .cornerRadius(12)
                    .disabled(!isFormValid || isLoading)
                    
                    Text("A verification email will be sent to your new address.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
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
        PasswordValidator.isValid(currentPassword) &&
        !newEmail.isEmpty &&
        newEmail == confirmEmail &&
        newEmail.contains("@") &&
        newEmail != currentEmail
    }
    
    private func updateEmail() {
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
            
            // Update email in Firebase Auth
            user.updateEmail(to: newEmail) { error in
                if let error = error {
                    isLoading = false
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }
                
                // Update email in Firestore
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).updateData([
                    "email": newEmail
                ]) { firestoreError in
                    isLoading = false
                    
                    if let firestoreError = firestoreError {
                        alertTitle = "Warning"
                        alertMessage = "Email updated in Auth but failed to update in Firestore: \(firestoreError.localizedDescription)"
                    } else {
                        // Send verification email
                        user.sendEmailVerification { verificationError in
                            if let verificationError = verificationError {
                                print("Failed to send verification: \(verificationError.localizedDescription)")
                            }
                        }
                        
                        alertTitle = "Success"
                        alertMessage = "Your email has been updated. Please verify your new email address."
                    }
                    showAlert = true
                }
            }
        }
    }
}
