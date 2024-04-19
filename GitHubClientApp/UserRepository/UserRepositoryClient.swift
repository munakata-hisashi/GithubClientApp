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
    
    func fetch(userRepositoriesURL: URL) async throws -> [Repository] {
        let request: Request = .init(
            url: userRepositoriesURL,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await gitHubApiClient.call(with: request)
        let repositories: [Repository] = try ResponseTranslator.from(response: response)
        
        return repositories
    }
}
