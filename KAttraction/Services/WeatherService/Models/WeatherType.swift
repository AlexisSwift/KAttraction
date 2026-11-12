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
    case unknown

    init(apiValue: String?) {
        self = apiValue.flatMap(WeatherType.init(rawValue:)) ?? .unknown
    }
    
    var weatherIcon: UIImage? {
        switch self {
        case .clear:
            return R.image.clear()
        case .clouds:
            return R.image.clouds()
        case .thunderstorm:
            return R.image.thunderstorm()
        case .drizzle:
            return R.image.drizzle()
        case .rain:
            return R.image.rain()
        case .snow:
            return R.image.snow()
        case .mist:
            return R.image.mist()
        case .tornado:
            return R.image.mist()
        case .unknown:
            return R.image.clouds()
        }
    }
    var description: String {
        switch self {
        case .clear:
            return R.string.localizable.weatherClear()
        case .clouds:
            return R.string.localizable.weatherClouds()
        case .thunderstorm:
            return R.string.localizable.weatherThunderstorm()
        case .drizzle:
            return R.string.localizable.weatherDrizzle()
        case .rain:
            return R.string.localizable.weatherRain()
        case .snow:
            return R.string.localizable.weatherSnow()
        case .mist:
            return R.string.localizable.weatherMist()
        case .tornado:
            return R.string.localizable.weatherTornado()
        case .unknown:
            return NSLocalizedString("Unknown", comment: "Unknown weather condition")
        }
    }
    
}
