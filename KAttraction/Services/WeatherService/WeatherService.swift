import Foundation

protocol WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void)
}

class WeatherService: WeatherServiceAbstract {
    
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        NetworkRequestManager.shared.request(BasicEndpoints.getWeather(latitude: city.latitude, longitude: city.longitude), completion: completion)
    }
}

extension WeatherService {
    enum GlobalWeatherConstant {
        static let api = "2db3c57ff9b75e40ba734e02ba73aa25"
        static let exclude = "current,minutely,daily,alerts"
    }
}
