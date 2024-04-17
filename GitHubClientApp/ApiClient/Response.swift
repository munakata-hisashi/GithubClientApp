import Foundation

struct Response {
    let statusCode: HTTPStatus
    
    let headers: [String: String]
    
    let payload: Data
}

enum HTTPStatus {
    case ok
    
    case notFound
    
    case unsupported(code: Int)
    
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .ok
        case 404:
            return .notFound
        default:
            return .unsupported(code: code)
        }
    }
}
