import Foundation

struct UserList: Decodable {
    let users: [User]
}

struct User: Decodable, Identifiable, Hashable {
    let id: Int
    let login: String
    let avatar_url: String
    
    var avatarImageURL: URL? {
        URL(string: avatar_url)
    }
}
