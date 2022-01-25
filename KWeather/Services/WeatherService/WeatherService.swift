import Foundation

protocol WeatherServiceAbstract {
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void)
}

class WeatherService: WeatherServiceAbstract {
    
    func getWeather(city: City, completion: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        NetworkRequestManager.shared.request(
            to: .weatherApi,
            parameters: ["lat": city.latitude,
                         "lon": city.longitude,
                         "exclude":"current,minutely,daily,alerts",
                         "appid": GlobalWeatherConstant.api],
            completion: completion
        )
    }
}

extension WeatherService {
    private enum GlobalWeatherConstant {
        static let api = "2db3c57ff9b75e40ba734e02ba73aa25"
    }
}
