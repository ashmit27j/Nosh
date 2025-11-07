import Foundation
import Cloudinary
import UIKit

class CloudinaryManager {
    static let shared = CloudinaryManager()
    
    private let cloudinary: CLDCloudinary
    private let uploadPreset = Config.cloudinaryUploadPreset
    
    private init() {
        let config = CLDConfiguration(
            cloudName: Config.cloudinaryCloudName,
            secure: true
        )
        self.cloudinary = CLDCloudinary(configuration: config)
    }
    
    // Upload profile photo to Cloudinary
    // Uses timestamp-based naming to ensure unique filenames
    func uploadProfilePhoto(
        image: UIImage,
        userId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // Compress image before upload to reduce file size
        guard let imageData = compressImage(image, maxSizeKB: 500) else {
            completion(.failure(NSError(
                domain: "CloudinaryManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"]
            )))
            return
        }
        
        // Setup upload parameters
        let params = CLDUploadRequestParams()
        params.setUploadPreset(uploadPreset)
        params.setFolder("profile_photos")
        
        // Create unique filename with timestamp
        // Format: user_[userId]_[timestamp].jpg
        // Example: user_abc123_1699200000.jpg
        let timestamp = Int(Date().timeIntervalSince1970)
        params.setPublicId("user_\(userId)_\(timestamp)")
        params.setResourceType(.image)
        
        // Perform upload to Cloudinary
        let request = cloudinary.createUploader().upload(
            data: imageData,
            uploadPreset: uploadPreset,
            params: params
        )
        
        request.response { result, error in
            if let error = error {
                print(" Cloudinary upload error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let result = result,
                  let secureUrl = result.secureUrl else {
                print(" No URL returned from Cloudinary")
                completion(.failure(NSError(
                    domain: "CloudinaryManager",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "No URL returned from Cloudinary"]
                )))
                return
            }
            
            print(" Photo uploaded successfully to: \(secureUrl)")
            completion(.success(secureUrl))
        }
    }
    
    /// Compress image to target file size
    /// - Parameters:
    ///   - image: The UIImage to compress
    ///   - maxSizeKB: Maximum size in kilobytes (default 500KB)
    /// - Returns: Compressed image data, or nil if compression failed
    private func compressImage(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        // Progressively reduce quality until file size is acceptable
        while let data = imageData, data.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        if let finalData = imageData {
            let finalSizeKB = finalData.count / 1024
            print(" Image compressed to \(finalSizeKB)KB (quality: \(Int(compression * 100))%)")
        }
        
        return imageData
    }
}
