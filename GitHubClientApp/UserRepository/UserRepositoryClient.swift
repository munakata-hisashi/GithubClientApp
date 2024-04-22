import Foundation

struct UserRepositoryClient {
    let gitHubApiClient: GitHubApiClient
    
    /// [Get a User](https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user) APIを使ってユーザーの詳細情報を取得する
    /// - Parameters:
    ///   -  userPageURL: リクエストするURL
    /// - Returns: ユーザーの詳細情報
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
    
    /// [List repositories for a user](https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user) APIを使ってユーザーのリポジトリを取得する
    /// - Parameters:
    ///   -  userRepositoriesURL: リクエストするURL
    /// - Returns: ユーザーのリポジトリと次ページのURLのタプル
    func fetch(userRepositoriesURL: URL) async throws -> ([Repository], URL?) {
        let request: Request = .init(
            url: userRepositoriesURL,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        let response = try await gitHubApiClient.call(with: request)
        let repositories: [Repository] = try ResponseTranslator.from(response: response)
        
       
        return (repositories, NextPageLinkExtractor.getNextPageLink(from: response.headers).flatMap { URL(string: $0) })
    }
}
