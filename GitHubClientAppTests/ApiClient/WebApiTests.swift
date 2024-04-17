import XCTest
@testable import GitHubClientApp

final class WebApiTests: XCTestCase {
    
    func testRequestAndResponse() async throws {
        let input: Request = .init(
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let output = try await WebApi.call(with: input)
        XCTAssertNoThrow(try GitHubZen.from(response: output))
    }
}

/// WebApiテスト用
struct GitHubZen {
    let text: String
    
    static func from(response: Response) throws -> GitHubZen {
        switch response.statusCode {
        case .ok:
            guard let string = String(data: response.payload, encoding: .utf8) else {
                throw TransformError.malformedData(debugInfo: "not UTF-8 string")
            }
            return GitHubZen(text: string)
        case .notFound:
            throw TransformError.unexpectedStatusCode(debugInfo: "not found")
        case .unsupported(let code):
            throw TransformError.unexpectedStatusCode(debugInfo: "unsupported code: \(code)")
        }
    }
    
    static func fetch() async throws -> GitHubZen {
        let urlString = "https://api.github.com/zen"
        guard let url = URL(string: urlString) else {
            throw ConnectionError.malformedURL(debugInfo: urlString)
        }
        
        let request: Request = .init(
            url: url,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await WebApi.call(with: request)
        return try .from(response: response)
    }
    
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
}
