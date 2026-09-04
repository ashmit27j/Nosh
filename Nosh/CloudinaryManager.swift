import Foundation
import Cloudinary
import UIKit

/// The single Cloudinary entry point. `EditProfileView` used to build its own
/// client with a `"YOUR_CLOUD_NAME"` placeholder, which is why photo upload
/// silently failed while this correctly-configured type went unused.
final class CloudinaryManager {
    static let shared = CloudinaryManager()

    enum UploadError: LocalizedError {
        case notConfigured
        case compressionFailed
        case noURLReturned

        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Photo upload isn't configured. Add your Cloudinary details to Secrets.plist."
            case .compressionFailed:
                return "That image couldn't be processed. Try a different photo."
            case .noURLReturned:
                return "The upload finished but no image URL came back. Try again."
            }
        }
    }

    private let cloudinary: CLDCloudinary?
    private let uploadPreset: String?

    private init() {
        // Degrades to "upload unavailable" rather than trapping when the config
        // is missing, so a bad Secrets.plist can't crash the app on launch.
        if let cloudName = Config.cloudinaryCloudName,
           let preset = Config.cloudinaryUploadPreset {
            cloudinary = CLDCloudinary(
                configuration: CLDConfiguration(cloudName: cloudName, secure: true)
            )
            uploadPreset = preset
        } else {
            cloudinary = nil
            uploadPreset = nil
        }
    }

    var isConfigured: Bool { cloudinary != nil && uploadPreset != nil }

    /// Uploads a profile photo and returns its secure URL.
    ///
    /// The public ID is derived from the user ID alone with `overwrite`, so a
    /// user has exactly one profile image rather than accumulating one per
    /// upload as the previous timestamped naming did.
    func uploadProfilePhoto(image: UIImage, userId: String) async throws -> String {
        guard let cloudinary, let uploadPreset else {
            throw UploadError.notConfigured
        }

        guard let imageData = Self.compressImage(image, maxSizeKB: 500) else {
            throw UploadError.compressionFailed
        }

        let params = CLDUploadRequestParams()
        params.setUploadPreset(uploadPreset)
        params.setFolder("profile_photos")
        params.setPublicId("user_\(userId)")
        params.setOverwrite(true)
        params.setResourceType(.image)

        return try await withCheckedThrowingContinuation { continuation in
            cloudinary.createUploader()
                .upload(data: imageData, uploadPreset: uploadPreset, params: params)
                .response { result, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let secureUrl = result?.secureUrl {
                        continuation.resume(returning: secureUrl)
                    } else {
                        continuation.resume(throwing: UploadError.noURLReturned)
                    }
                }
        }
    }

    /// Compresses to roughly `maxSizeKB`, giving up at quality 0.1.
    static func compressImage(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)

        while let data = imageData, data.count > maxBytes, compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }

        return imageData
    }
}
