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
        
        guard let nextPageLink = extractNextPageLink(response.headers) else {
            return .init(users: users)
        }
        return .init(users: users, nextPageLink: nextPageLink)
    }
    
    private func extractNextPageLink(_ headers: [String: String]) -> String? {
        guard let headerValue = headers["link"], headerValue.contains("rel=\"next\"") else {
            return nil
        }
        
        let links = headerValue
            .split(separator: ",")
            .filter { $0.contains("rel=\"next\"")}
        
        let pattern = /<([^>]*)>/
        
        guard let link = links.first, let match = link.firstMatch(of: pattern) else {
            return nil
        }
        
        return String(match.1)
        
    }
    
}
