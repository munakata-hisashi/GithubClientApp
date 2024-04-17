import XCTest
@testable import GithubClientApp

final class GithubApiClientTests: XCTestCase {


    func testRequest() throws {
        let input: Request = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        GithubApiClient.call(with: input)
    }

}
