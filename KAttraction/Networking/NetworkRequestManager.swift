import Alamofire

final class NetworkRequestManager {
    
    class func request<T: Decodable>(
        _ target: Target,
        completion: @escaping (Result<T, AppError>) -> Void
    ) {
        
        let afRequest = AF.request(
            target.urlPath,
            method: target.method,
            parameters: target.parameters,
            headers: NetworkRequestManager.headers(targetHeaders: target.headers)
        )
        
        afRequest.response { responseJSON in
            if let debugRequestString = responseJSON.request?.debugDescription {
                LoggerService.network("\nResponse for \"\(debugRequestString)")
            }
            
            switch responseJSON.result {
            case .success:
                
                if let debugData = responseJSON.value, let debugRequestString = debugData?.prettyPrintedJSONString {
                    LoggerService.network("\nResponse for \"\(debugRequestString)")
                }
                
                if let data = responseJSON.data,
                   let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(decodedData))
                } else {
                    completion(.failure(.dataError))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    class func headers(targetHeaders: [String: String]?) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        headers["Content-Type"] = "application/json"
        
        if let targetHeaders = targetHeaders {
            for (key, value) in targetHeaders {
                headers[key] = value
            }
        }
        
        return headers
    }
}

enum AppError: Error {
    case networkError
    case dataError
}
