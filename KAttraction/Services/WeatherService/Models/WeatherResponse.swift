struct WeatherResponse: Decodable {
    let hourly: [Hourly]
    let timezoneOffset: Int

    enum CodingKeys: String, CodingKey {
        case hourly
        case data
        case timezoneOffset = "timezone_offset"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hourly = try container.decodeIfPresent([Hourly].self, forKey: .data)
            ?? container.decodeIfPresent([Hourly].self, forKey: .hourly)
            ?? []
        timezoneOffset = try container.decodeIfPresent(Int.self, forKey: .timezoneOffset) ?? 0
    }
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
