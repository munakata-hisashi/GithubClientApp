import Foundation

enum ConnectionError: LocalizedError {
    case noDataOrNoResponse(debugInfo: String)
    case malformedURL(debugInfo: String)
    
    var errorDescription: String? {
        switch self {
        case .noDataOrNoResponse(let debugInfo):
            return "noDataOrNoResponse: \(debugInfo)"
        case .malformedURL(let debugInfo):
            return "malformedURL:; \(debugInfo)"
        }
    }
}
