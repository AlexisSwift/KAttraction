import Alamofire

enum BasicEndpoints {
    case getWeather(latitude: Double, longitude: Double)
    case getAttractions
}

extension BasicEndpoints: Target {
    var baseURL: URL {
        switch self {
        case .getAttractions:
            return URL(string: Bundle.main.url(forResource: "Attractions", withExtension: "json")?.absoluteString ?? "")!
        default:
            return URL(string: GlobalConstants.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/onecall?"
        case .getAttractions:
            return ""
        }
    }
    
    var keyPath: String? {
        return nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeather:
            return .get
        default:
            return .post
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .getWeather(latitude, longitude):
            let params: [String: Any] = [
                "lat": latitude,
                "lon": longitude,
                "exclude": WeatherService.GlobalWeatherConstant.exclude,
                "appid": WeatherService.GlobalWeatherConstant.api
            ]
            return params
        default:
            return nil
        }
    }
}
