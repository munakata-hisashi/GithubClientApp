import Foundation

struct UserRepositoryClient {
    let gitHubApiClient: GitHubApiClient
    
    func fetch(userPageURL: URL) async throws -> UserDetail {
        let request: Request = .init(
            url: userPageURL,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await gitHubApiClient.call(with: request)
        let user: UserDetail = try ResponseTranslator.from(response: response)
        
        return user
        
    }
    
    func fetch(userRepositoriesURL: URL) async throws -> ([Repository], String?) {
        let request: Request = .init(
            url: userRepositoriesURL,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await gitHubApiClient.call(with: request)
        let repositories: [Repository] = try ResponseTranslator.from(response: response)
        
        
        return (repositories, extractNextPageLink(response.headers))
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
