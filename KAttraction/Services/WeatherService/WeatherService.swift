import Foundation

protocol WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void)
}

final class WeatherService: WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        guard let apiKey = AppConfiguration.weatherAPIKey else {
            completion(.failure(.configuration))
            return
        }

        let endpoint = BasicEndpoints.weatherTimeline(
            latitude: city.latitude,
            longitude: city.longitude,
            apiKey: apiKey
        )
        NetworkRequestManager.request(endpoint, completion: completion)
    }
}
