struct WeatherResponse: Decodable {
    let hourly: [Hourly]
}

struct Hourly: Decodable {
    let dateTime: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case weather
    }
}

struct Weather: Decodable {
    let main: String
}
