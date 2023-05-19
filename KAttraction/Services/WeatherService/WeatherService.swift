import Foundation

protocol WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void)
}

final class WeatherService: WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        NetworkRequestManager.request(BasicEndpoints.getWeather(latitude: city.latitude, longitude: city.longitude), completion: completion)
    }
}
