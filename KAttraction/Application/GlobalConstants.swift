import Foundation

struct GlobalConstants {
    
    /// Server host string
    static var baseUrl = "https://api.openweathermap.org"
    
    // MARK: - Weather API
    struct WeatherAPI {
        static let api = "2db3c57ff9b75e40ba734e02ba73aa25"
        static let exclude = "current,minutely,daily,alerts"
    }
}
