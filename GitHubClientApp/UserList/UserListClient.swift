import Foundation

struct UserListClient {
    
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
        
        let response = try await GitHubApiClient.call(with: request)
        let users: [User] = try ResponseTranslator.from(response: response)
        
        guard let nextPageLink = nextPageLinkExtractor(response.headers) else {
            return .init(users: users)
        }
        return .init(users: users, nextPageLink: nextPageLink)
    }
    
    private func nextPageLinkExtractor(_ headers: [String: String]) -> String? {
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
