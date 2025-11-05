import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: UserProfileViewModel
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showImagePicker: Bool = false
    @State private var newUsername: String = ""
    @State private var newEmail: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    
    @State private var showPasswordResetView: Bool = false
    @State private var showUpdateEmailView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("primaryBackground").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        buildProfilePhotoSection()
                        buildPersonalInfoSection()
                        buildAccountActionsSection()
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color("primaryAccent"))
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
            .sheet(isPresented: $showPasswordResetView) {
                UpdatePasswordView()
            }
            .sheet(isPresented: $showUpdateEmailView) {
                UpdateEmailView()
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
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func buildProfilePhotoSection() -> some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                if let photoURL = viewModel.photoURL {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color("secondaryButton").opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(Color("secondaryText"))
                        )
                }
                
                Button {
                    showImagePicker = true
                } label: {
                    Circle()
                        .fill(Color("primaryAccent"))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color("primaryText"))
                                .font(.system(size: 16))
                        )
                }
            }
            
            Text("Tap to change photo")
                .font(.caption)
                .foregroundColor(Color("secondaryText"))
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func buildPersonalInfoSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.headline)
                .foregroundColor(Color("primaryText"))
            
            buildUsernameField()
            buildEmailField()
            buildSaveButton()
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func buildUsernameField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .font(.subheadline)
                .foregroundColor(Color("secondaryText"))
            
            TextField("Enter your name", text: $newUsername)
                .padding()
                .background(Color("primaryBackground"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("secondaryButton").opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private func buildEmailField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.subheadline)
                .foregroundColor(Color("secondaryText"))
            
            TextField("Enter your email", text: $newEmail)
                .padding()
                .background(Color("primaryBackground"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("secondaryButton").opacity(0.3), lineWidth: 1)
                )
                .disabled(true)
                .opacity(0.6)
        }
    }
    
    @ViewBuilder
    private func buildSaveButton() -> some View {
        Button {
            updateProfile()
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(Color("primaryText"))
                } else {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("primaryAccent"))
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
    
    @ViewBuilder
    private func buildAccountActionsSection() -> some View {
        VStack(spacing: 0) {
            buildActionButton(
                icon: "lock.rotation",
                title: "Change Password"
            ) {
                showPasswordResetView = true
            }
            
            Divider()
                .background(Color("secondaryButton").opacity(0.3))
            
            buildActionButton(
                icon: "envelope.fill",
                title: "Update Email Address"
            ) {
                showUpdateEmailView = true
            }
            
            Divider()
                .background(Color("secondaryButton").opacity(0.3))
            
            buildActionButton(
                icon: "paperplane.fill",
                title: "Send Password Reset Email",
                chevron: "arrow.up.right"
            ) {
                sendPasswordReset()
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func buildActionButton(
        icon: String,
        title: String,
        chevron: String = "chevron.right",
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color("primaryAccent"))
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(Color("primaryText"))
                
                Spacer()
                
                Image(systemName: chevron)
                    .font(.system(size: 14))
                    .foregroundColor(Color("secondaryText"))
            }
            .padding(.vertical, 12)
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
                } else {
                    alertTitle = "Success"
                    alertMessage = "Profile updated successfully"
                    viewModel.fetchUserProfile()
                }
                showAlert = true
            }
        } else {
            isLoading = false
            alertTitle = "No Changes"
            alertMessage = "No changes were made"
            showAlert = true
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
                alertMessage = "Password reset link sent to \(email)"
            }
            showAlert = true
        }
    }
    
    private func uploadProfilePhoto(_ image: UIImage) async {
        alertTitle = "Coming Soon"
        alertMessage = "Photo upload will be implemented"
        showAlert = true
    }
}
