import UIKit

enum Asset {
    
    enum GlobalIcon {
        static let backArrow = UIImage(named: "backArrow")
    }
    
    enum WeatherIcon {
        static let clear = UIImage(named: "clear")
        static let clouds = UIImage(named: "clouds")
        static let thunderstorm = UIImage(named: "thunderstorm")
        static let drizzle = UIImage(named: "drizzle")
        static let rain = UIImage(named: "rain")
        static let snow = UIImage(named: "snow")
        static let mist = UIImage(named: "mist")
        static let tornado = UIImage(named: "mist")
    }
    
    enum WeatherBackground {
        static let clear = UIImage(named: "clearBackground")
        static let cloudy = UIImage(named: "cloudyBackground")
        static let rain = UIImage(named: "rainBackground")
        static let snow = UIImage(named: "snowBackground")
    }
    
    enum statusOfLoading {
        static let loading = UIImage(named: "loading")
    }
}
