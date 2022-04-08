import Alamofire

protocol Target {
    var baseURL: URL { get }
    var path: String { get }
    var keyPath: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Target {
    var urlPath: URL {
        return URL(string: baseURL.absoluteString + path)!
    }
}
