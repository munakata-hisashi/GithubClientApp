import Foundation

enum ResponseTranslator {
    private static let decoder = JSONDecoder()
    
    static func from<T: Decodable>(response: Response) throws -> T {
        switch response.statusCode {
        case .ok:
            return try decoder.decode(T.self, from: response.payload)
        case .notFound:
            throw TransformError.unexpectedStatusCode(debugInfo: "not found")
        case .unsupported(let code):
            throw TransformError.unexpectedStatusCode(debugInfo: "unsupported code: \(code)")
        }
    }
}
