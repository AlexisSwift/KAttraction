import Alamofire

enum BasicEndpoints {
    case weatherTimeline(latitude: Double, longitude: Double, apiKey: String)
}

extension BasicEndpoints: Target {
    var url: URL {
        switch self {
        case .weatherTimeline:
            return AppConfiguration.weatherBaseURL
                .appendingPathComponent("data/4.0/onecall/timeline/1h")
        }
    }

    var method: HTTPMethod { .get }

    var headers: HTTPHeaders? {
        [.accept("application/json")]
    }

    var parameters: Parameters? {
        switch self {
        case let .weatherTimeline(latitude, longitude, apiKey):
            return [
                "lat": latitude,
                "lon": longitude,
                "appid": apiKey,
                "units": "metric",
                "lang": AppConfiguration.languageCode
            ]
        }
    }
}
