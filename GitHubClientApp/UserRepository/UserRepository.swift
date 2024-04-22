import Foundation

/// ユーザーリポジトリ画面で表示するモデル
@Observable
class UserRepository {
    var userDetail: UserDetail
    private var repositories: [Repository]
    var nextPageLink: URL?
    
    var originalRepositories: [Repository] {
        repositories.filter { !$0.fork }
    }
    
    init(userDetail: UserDetail, repositories: [Repository], nextPageLink: URL?) {
        self.userDetail = userDetail
        self.repositories = repositories
        self.nextPageLink = nextPageLink
    }
    
    func append(new: [Repository], nextPageLink: URL?) {
        repositories = repositories + new
        self.nextPageLink = nextPageLink
    }
}

struct UserDetail: Codable {
    let login: String
    let avatar_url: String
    let name: String?
    let followers: Int
    let following: Int
    
    var avatarImageURL: URL? {
        URL(string: avatar_url)
    }
}

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let language: String?
    let stargazers_count: Int
    let description: String?
    let fork: Bool
    let html_url: String
    
    var repositoryPageURL: URL? {
        URL(string: html_url)
    }
}
