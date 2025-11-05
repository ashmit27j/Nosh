import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI
import PhotosUI
import Cloudinary // Add this import

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
    @State private var isUploadingPhoto: Bool = false // New state for photo upload
    
    @State private var showPasswordResetView: Bool = false
    @State private var showUpdateEmailView: Bool = false
    
    // Cloudinary configuration
    private let cloudinary = CLDCloudinary(configuration: CLDConfiguration(
        cloudName: "YOUR_CLOUD_NAME", // Replace with your Cloudinary cloud name
        secure: true
    ))
    private let uploadPreset = "nosh_profile_photos" // Replace with your upload preset name
    
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
                // Show loading overlay when uploading
                ZStack {
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
                    
                    // Upload progress overlay
                    if isUploadingPhoto {
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            )
                    }
                }
                
                Button {
                    showImagePicker = true
                } label: {
                    Circle()
                        .fill(Color("primaryAccent"))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: isUploadingPhoto ? "hourglass" : "camera.fill")
                                .foregroundColor(Color("primaryText"))
                                .font(.system(size: 16))
                        )
                }
                .disabled(isUploadingPhoto)
            }
            
            Text(isUploadingPhoto ? "Uploading..." : "Tap to change photo")
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
    
    // MARK: - Cloudinary Upload
    
    private func uploadProfilePhoto(_ image: UIImage) async {
        guard let user = Auth.auth().currentUser else { return }
        
        // Start loading state
        await MainActor.run {
            isUploadingPhoto = true
        }
        
        // Compress image before upload (optional but recommended)
        guard let imageData = compressImage(image, maxSizeKB: 1000) else {
            await MainActor.run {
                isUploadingPhoto = false
                alertTitle = "Error"
                alertMessage = "Failed to process image"
                showAlert = true
            }
            return
        }
        
        // Create upload parameters
        let params = CLDUploadRequestParams()
        params.setUploadPreset(uploadPreset)
        params.setFolder("profile_photos") // Optional: organize photos in folder
        params.setPublicId("user_\(user.uid)") // Use user ID as public ID for easy retrieval
        params.setOverwrite(true) // Allow replacing existing photo
        params.setResourceType(.image)
        
        // Perform upload
        let request = cloudinary.createUploader().upload(
            data: imageData,
            uploadPreset: uploadPreset,
            params: params
        )
        
        request.response { result, error in
            Task { @MainActor in
                isUploadingPhoto = false
                
                if let error = error {
                    alertTitle = "Upload Failed"
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }
                
                guard let result = result,
                      let secureUrl = result.secureUrl else {
                    alertTitle = "Upload Failed"
                    alertMessage = "Could not get image URL"
                    showAlert = true
                    return
                }
                
                // Save the Cloudinary URL to Firestore
                savePhotoURLToFirestore(secureUrl)
            }
        }
    }
    
    private func savePhotoURLToFirestore(_ urlString: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "photoURL": urlString
        ]) { error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = "Photo uploaded but failed to save: \(error.localizedDescription)"
            } else {
                alertTitle = "Success"
                alertMessage = "Profile photo updated successfully!"
                // Refresh the user profile to show new photo
                viewModel.fetchUserProfile()
            }
            showAlert = true
        }
    }
    
    // Helper function to compress image
    private func compressImage(_ image: UIImage, maxSizeKB: Int) -> Data? {
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
}
