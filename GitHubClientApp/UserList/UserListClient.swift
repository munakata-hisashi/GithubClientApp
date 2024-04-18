import Foundation

protocol UserListClient {
    func fetch() async throws ->  UserList
}

struct UserListClientImpl: UserListClient {
    
    func fetch() async throws -> UserList {
        let urlString = "https://api.github.com/users"
        guard let url = URL(string: urlString) else {
            throw ConnectionError.malformedURL(debugInfo: urlString)
        }
        guard let token = Env["PERSONAL_ACCESS_TOKEN"] else {
            throw ConnectionError.notFoundToken
        }
        
        let request: Request = .init(
            url: url,
            queries: [.init(name: "per_page", value: "3")],
            headers: [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)",
                "X-GitHub-Api-Version": "2022-11-28"
            ],
            methodAndPayload: .get
        )
        
        let response = try await WebApi.call(with: request)
        let users: [User] = try ResponseTranslator.from(response: response)
        
        return .init(users: users)
    }
    
    
}
