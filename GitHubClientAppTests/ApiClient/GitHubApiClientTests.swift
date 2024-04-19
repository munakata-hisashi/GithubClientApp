import XCTest
@testable import GitHubClientApp

final class GitHubApiClientTests: XCTestCase {
    
    func testRequestAndResponse() async throws {
        let input: Request = .init(
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let output = try await GitHubApiClient.call(with: input)
        let zen = try GitHubZen.from(response: output)
        XCTAssertFalse(zen.text.isEmpty)
    }
}

/// GitHubApiClientテスト用
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
}
