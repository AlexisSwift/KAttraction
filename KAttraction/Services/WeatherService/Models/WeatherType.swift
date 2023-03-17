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
            return Image.clear()
        case .clouds:
            return Image.clouds()
        case .thunderstorm:
            return Image.thunderstorm()
        case .drizzle:
            return Image.drizzle()
        case .rain:
            return Image.rain()
        case .snow:
            return Image.snow()
        case .mist:
            return Image.mist()
        case .tornado:
            return Image.mist()
        }
    }
    var description: String {
        switch self {
        case .clear:
            return L10n.weatherClear()
        case .clouds:
            return L10n.weatherClouds()
        case .thunderstorm:
            return L10n.weatherThunderstorm()
        case .drizzle:
            return L10n.weatherDrizzle()
        case .rain:
            return L10n.weatherRain()
        case .snow:
            return L10n.weatherSnow()
        case .mist:
            return L10n.weatherMist()
        case .tornado:
            return L10n.weatherTornado()
        }
    }
    
}
