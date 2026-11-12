import Alamofire

final class NetworkRequestManager {
    static func request<T: Decodable>(
        _ target: Target,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, AppError>) -> Void
    ) {
        AF.request(
            target.url,
            method: target.method,
            parameters: target.parameters,
            headers: target.headers
        )
        .validate(statusCode: 200..<300)
        .responseData(queue: .main) { response in
            let result: Result<T, AppError>

            switch response.result {
            case let .success(data):
                do {
                    result = .success(try decoder.decode(T.self, from: data))
                } catch {
                    LoggerService.error("Unable to decode response: \(error.localizedDescription)")
                    result = .failure(.decoding(error))
                }
            case let .failure(error):
                result = .failure(AppError.from(error: error, statusCode: response.response?.statusCode))
            }

            completion(result)
        }
    }
}

enum AppError: Error, LocalizedError {
    case configuration
    case resourceNotFound(String)
    case transport(Error)
    case server(statusCode: Int)
    case decoding(Error)
    case emptyResponse
    case notFound

    var errorDescription: String? {
        switch self {
        case .configuration:
            return NSLocalizedString("Weather service is not configured.", comment: "Missing weather configuration")
        case let .resourceNotFound(resource):
            return String(
                format: NSLocalizedString("Resource %@ was not found.", comment: "Missing bundled resource"),
                resource
            )
        case .transport:
            return NSLocalizedString("Unable to connect to the server. Please try again.", comment: "Network error")
        case let .server(statusCode):
            return String(
                format: NSLocalizedString("The server returned error %d.", comment: "Server error"),
                statusCode
            )
        case .decoding:
            return NSLocalizedString("The server returned unsupported data.", comment: "Decoding error")
        case .emptyResponse:
            return NSLocalizedString("No forecast is available for this city.", comment: "Empty forecast")
        case .notFound:
            return NSLocalizedString("The requested attraction was not found.", comment: "Attraction not found")
        }
    }

    static func from(error: AFError, statusCode: Int?) -> AppError {
        if let statusCode {
            return .server(statusCode: statusCode)
        }
        return .transport(error)
    }
}
