import Foundation

enum AppConfiguration {
    static let weatherBaseURL = URL(string: "https://api.openweathermap.org")!
    static let weatherAPIKeyInfoKey = "OPENWEATHER_API_KEY"

    static var weatherAPIKey: String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: weatherAPIKeyInfoKey) as? String else {
            return nil
        }

        let key = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty, !key.hasPrefix("$(") else {
            return nil
        }
        return key
    }

    static var languageCode: String {
        Locale.current.languageCode ?? "en"
    }
}
