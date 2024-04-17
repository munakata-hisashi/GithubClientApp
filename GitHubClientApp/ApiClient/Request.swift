import Foundation

struct Request {
    let url: URL
    let queries: [URLQueryItem]
    let headers: [String: String]
    let methodAndPayload: HTTPMethodAndPayload
}

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
