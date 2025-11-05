import Foundation

enum Config {
    // Cloudinary Configuration
    static var cloudinaryCloudName: String {
        guard let cloudName = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_CLOUD_NAME") as? String else {
            fatalError("CLOUDINARY_CLOUD_NAME not found in Info.plist")
        }
        return cloudName
    }
    
    static var cloudinaryUploadPreset: String {
        guard let preset = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_UPLOAD_PRESET") as? String else {
            fatalError("CLOUDINARY_UPLOAD_PRESET not found in Info.plist")
        }
        return preset
    }
}
