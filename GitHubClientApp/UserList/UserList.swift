import Foundation

@Observable
class UserList {
    var users: [User]
    var nextPageLink: String?
    
    var lastUser: User? {
        users.last
    }
    
    func append(userList: UserList) {
        users = users + userList.users
        nextPageLink = userList.nextPageLink
    }
    
    init(users: [User], nextPageLink: String? = nil) {
        self.users = users
        self.nextPageLink = nextPageLink
    }
}

struct User: Decodable, Identifiable, Hashable {
    let id: Int
    let login: String
    let avatar_url: String
    
    var avatarImageURL: URL? {
        URL(string: avatar_url)
    }
}
