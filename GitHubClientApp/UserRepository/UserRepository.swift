import Foundation

@Observable
class UserRepository {
    var userDetail: UserDetail
    var repositories: [Repository]
    
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

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let language: String?
    let stargazers_count: Int
    let description: String?
    let fork: Bool
}
