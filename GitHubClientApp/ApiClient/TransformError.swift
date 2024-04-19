import Foundation

enum TransformError: LocalizedError {
    case unexpectedStatusCode(debugInfo: String)
    case malformedData(debugInfo: String)
    
    var errorDescription: String? {
        switch self {
        case .unexpectedStatusCode(debugInfo: let debugInfo):
            return "unexpectedStatusCode: \(debugInfo)"
        case .malformedData(debugInfo: let debugInfo):
            return "malformedData: \(debugInfo)"
        }
    }
}
