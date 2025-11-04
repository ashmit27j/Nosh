import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: UserProfileViewModel
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showImagePicker = false
    @State private var newUsername = ""
    @State private var newEmail = ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Profile Photo Section
                        VStack(spacing: 16) {
                            ZStack(alignment: .bottomTrailing) {
                                if let photoURL = viewModel.photoURL {
                                    WebImage(url: photoURL)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 120, height: 120)
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                    }
                                }
                            }
                            
                            Text("Tap to change photo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Personal Information
                        SectionContainer {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Personal Information")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Username")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Enter your name", text: $newUsername)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Enter your email", text: $newEmail)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                
                                Button(action: updateProfile) {
                                    if isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                    } else {
                                        Text("Save Changes")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(12)
                                    }
                                }
                                .disabled(isLoading)
                            }
                        }
                        
                        // Change Password
                        SectionContainer {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Change Password")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Current Password")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    SecureField("Enter current password", text: $currentPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("New Password")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    SecureField("Enter new password", text: $newPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm New Password")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    SecureField("Confirm new password", text: $confirmPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                Button(action: changePassword) {
                                    Text("Update Password")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        // Quick Actions
                        SectionContainer {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quick Actions")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                NavigationLink(destination: UpdateEmailView()) {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.blue)
                                        Text("Update Email Address")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Button(action: sendPasswordReset) {
                                    HStack {
                                        Image(systemName: "lock.rotation")
                                            .foregroundColor(.blue)
                                        Text("Send Password Reset Email")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "paperplane.fill")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)
            .onChange(of: selectedPhoto) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await uploadProfilePhoto(uiImage)
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                newUsername = viewModel.username
                newEmail = Auth.auth().currentUser?.email ?? ""
            }
        }
    }
    
    // MARK: - Functions
    
    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        
        let db = Firestore.firestore()
        
        var updates: [String: Any] = [:]
        
        if !newUsername.isEmpty && newUsername != viewModel.username {
            updates["username"] = newUsername
        }
        
        if !updates.isEmpty {
            db.collection("users").document(user.uid).updateData(updates) { error in
                isLoading = false
                
                if let error = error {
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    alertTitle = "Success"
                    alertMessage = "Profile updated successfully"
                    showAlert = true
                    viewModel.fetchUserProfile()
                }
            }
        } else {
            isLoading = false
            alertTitle = "No Changes"
            alertMessage = "No changes were made to your profile"
            showAlert = true
        }
    }
    
    private func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty else {
            alertTitle = "Missing Information"
            alertMessage = "Please fill in all password fields"
            showAlert = true
            return
        }
        
        guard newPassword == confirmPassword else {
            alertTitle = "Password Mismatch"
            alertMessage = "New passwords do not match"
            showAlert = true
            return
        }
        
        guard newPassword.count >= 6 else {
            alertTitle = "Invalid Password"
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                alertTitle = "Authentication Error"
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    alertTitle = "Success"
                    alertMessage = "Password updated successfully"
                    showAlert = true
                    currentPassword = ""
                    newPassword = ""
                    confirmPassword = ""
                }
            }
        }
    }
    
    private func sendPasswordReset() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "Email Sent"
                alertMessage = "A password reset link has been sent to \(email)"
            }
            showAlert = true
        }
    }
    
    private func uploadProfilePhoto(_ image: UIImage) async {
        // Implement photo upload logic here
        // This would typically involve uploading to Firebase Storage
        // and updating the user's photoURL in Firestore
        
        alertTitle = "Coming Soon"
        alertMessage = "Photo upload functionality will be implemented"
        showAlert = true
    }
}
