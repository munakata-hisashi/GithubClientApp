import Foundation

typealias Input = Request

typealias Request = (
    url: URL,
    queries: [URLQueryItem],
    headers: [String: String],
    methodAndPayload: HTTPMethodAndPayload
)


enum HTTPMethodAndPayload {
    case get
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
    
    var body: Data? {
        switch self {
        case .get:
            return nil
        }
    }
}

enum GithubApiClient {
    static func call(with input: Input) {
        
    }
}
