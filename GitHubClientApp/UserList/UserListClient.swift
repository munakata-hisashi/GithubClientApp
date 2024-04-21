import Foundation


struct UserListClient {
    let gitHubApiClient: GitHubApiClient
    
    /// [List Users](https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#list-users) APIを使ってユーザー一覧を取得する
    /// - Parameters:
    ///   -  nextPageLink: 追加読み込みのためのURL
    /// - Returns: GitHubのユーザーのリスト
    func fetch(nextPageLink: String?) async throws -> UserList {
        let urlString = nextPageLink ?? "https://api.github.com/users"
        guard let url = URL(string: urlString) else {
            throw ConnectionError.malformedURL(debugInfo: urlString)
        }

        let request: Request = .init(
            url: url,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await gitHubApiClient.call(with: request)
        let users: [User] = try ResponseTranslator.from(response: response)
        
        guard let nextPageLink = NextPageLinkExtractor.getNextPageLink(from: response.headers) else {
            return .init(users: users)
        }
        return .init(users: users, nextPageLink: nextPageLink)
    }
}
