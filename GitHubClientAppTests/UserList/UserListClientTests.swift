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

    let userData = try! JSONEncoder().encode([User(id: 1, login: "name", avatar_url: "dummy")])
    func testFetchUsers() async throws {
        let headers: [String: String] = [:]
        let client = UserListClient(gitHubApiClient: GitHubApiClientMock(response: .init(statusCode: .ok, headers: headers, payload: userData)))
        
        let userList = try await client.fetch(nextPageLink: nil)
        XCTAssertEqual(userList.users, [User(id: 1, login: "name", avatar_url: "dummy")])
        XCTAssertNil(userList.nextPageLink)
    }
    
    func testExtractNextPageLink() async throws {
        let headers = [
            "link": "<https://api.github.com/users?per_page=2&since=2>; rel=\"next\", <https://api.github.com/users{?since}>; rel=\"first\""
        ]
        let client = UserListClient(gitHubApiClient: GitHubApiClientMock(response: .init(statusCode: .ok, headers: headers, payload: userData)))
        
        let userList = try await client.fetch(nextPageLink: nil)
        XCTAssertEqual(userList.nextPageLink, "https://api.github.com/users?per_page=2&since=2")
        
    }
    
    func testNotExtractOtherLink() async throws {
        let headers = [
            "link": "<https://api.github.com/users{?since}>; rel=\"first\""
        ]
        let client = UserListClient(gitHubApiClient: GitHubApiClientMock(response: .init(statusCode: .ok, headers: headers, payload: userData)))
        
        let userList = try await client.fetch(nextPageLink: nil)
        XCTAssertNil(userList.nextPageLink)
    }
}
