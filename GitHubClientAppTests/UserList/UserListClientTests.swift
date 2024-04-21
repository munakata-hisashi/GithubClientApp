import XCTest
@testable import GitHubClientApp

struct GitHubApiClientMock: GitHubApiClient {
    var response: Response?
    func call(with input: Request) async throws -> Response {
        guard let response else { throw ConnectionError.noDataOrNoResponse(debugInfo: "no response")}
        return response
    }
}
class UserListClientTests: XCTestCase {

    let userData = try! JSONEncoder().encode([User(id: 1, login: "name", avatar_url: "dummy", url: "dummy", repos_url: "dummy")])
    func testFetchUsers() async throws {
        let headers: [String: String] = [:]
        let client = UserListClient(gitHubApiClient: GitHubApiClientMock(response: .init(statusCode: .ok, headers: headers, payload: userData)))
        
        let userList = try await client.fetch(nextPageLink: nil)
        XCTAssertEqual(userList.users, [User(id: 1, login: "name", avatar_url: "dummy", url: "dummy", repos_url: "dummy")])
        XCTAssertNil(userList.nextPageLink)
    }
    
}
