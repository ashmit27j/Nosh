import Foundation

/// Reads configuration from `Secrets.plist`, which is gitignored.
/// Copy `Secrets.example.plist` to `Nosh/Secrets.plist` and fill in the values.
///
/// NOTE: a bundled plist keeps secrets out of git, but it still ships inside the
/// app and can be read out of the IPA. `GEMINI_API_KEY` should ultimately move
/// behind a Cloud Function that holds the key server-side and authenticates the
/// caller with their Firebase ID token.
enum Config {

    // MARK: - Loading

    private static let values: [String: String] = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(
                  from: data, format: nil
              ) as? [String: String]
        else {
            assertionFailure("Secrets.plist is missing or malformed. Copy Secrets.example.plist to Nosh/Secrets.plist.")
            return [:]
        }
        return plist
    }()

    /// Returns nil rather than trapping, so a missing key disables one feature
    /// instead of crashing the app on launch.
    private static func value(for key: String) -> String? {
        guard let value = values[key], !value.isEmpty, !value.hasPrefix("YOUR_") else {
            return nil
        }
        return value
    }

    // MARK: - Keys

    static var geminiAPIKey: String? { value(for: "GEMINI_API_KEY") }

    static var cloudinaryCloudName: String? { value(for: "CLOUDINARY_CLOUD_NAME") }

    static var cloudinaryUploadPreset: String? { value(for: "CLOUDINARY_UPLOAD_PRESET") }

    /// True when photo upload is configured. Callers should degrade gracefully
    /// rather than assuming Cloudinary is available.
    static var isCloudinaryConfigured: Bool {
        cloudinaryCloudName != nil && cloudinaryUploadPreset != nil
    }
}
