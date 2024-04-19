import SwiftUI

struct UserListView: View {
    let userListClient: UserListClient = UserListClient()
    @State private var userList: UserList?
    
    var body: some View {
        NavigationStack {
            if let userList {
                List(userList.users) { user in
                    NavigationLink(
                        value: user,
                        label: {
                            UserView(user: user)
                                .task {
                                    guard let lastUser = userList.lastUser,
                                          let nextPageLink = userList.nextPageLink,
                                          user.id == lastUser.id else {
                                        return
                                    }
                                    do {
                                        let new = try await userListClient.fetch(nextPageLink: nextPageLink)
                                        userList.append(userList: new)
                                    } catch {
                                        print("\(error.localizedDescription)")
                                    }
                                }
                        }
                    )
                }
                .navigationDestination(for: User.self) { user in
                    Text("UserDetail \(user.login)")
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                userList = try await userListClient.fetch(nextPageLink: nil)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
}

struct UserView: View {
    let user: User
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(
                url: user.avatarImageURL,
                content: { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 50, height: 50)
            
            Text("\(user.login)")
        }
    }
}

#Preview {
    UserListView()
}