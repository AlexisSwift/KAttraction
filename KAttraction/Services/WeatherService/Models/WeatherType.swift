import UIKit

enum WeatherType: String {
    case clear = "Clear"
    case clouds = "Clouds"
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case mist = "Mist"
    case tornado = "Tornado"
    
    var weatherIcon: UIImage? {
        switch self {
        case .clear:
            return Asset.WeatherIcon.clear
        case .clouds:
            return Asset.WeatherIcon.clouds
        case .thunderstorm:
            return Asset.WeatherIcon.thunderstorm
        case .drizzle:
            return Asset.WeatherIcon.drizzle
        case .rain:
            return Asset.WeatherIcon.rain
        case .snow:
            return Asset.WeatherIcon.snow
        case .mist:
            return Asset.WeatherIcon.mist
        case .tornado:
            return Asset.WeatherIcon.tornado
        }
    }
    var description: String {
        switch self {
        case .clear:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.clear
        case .clouds:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.clouds
        case .thunderstorm:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.thunderstorm
        case .drizzle:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.drizzle
        case .rain:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.rain
        case .snow:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.snow
        case .mist:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.mist
        case .tornado:
            return Localization.SearchFlow.CityWeather.WeatherDiscription.tornado
        }
    }
    
}
