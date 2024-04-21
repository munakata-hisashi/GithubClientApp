import Foundation

@Observable
class UserRepository {
    var userDetail: UserDetail
    private var repositories: [Repository]
    
    var originalRepositories: [Repository] {
        repositories.filter { !$0.fork }
    }
    
    init(userDetail: UserDetail, repositories: [Repository]) {
        self.userDetail = userDetail
        self.repositories = repositories
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
}
