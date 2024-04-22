import SwiftUI

/// ユーザー一覧画面
struct UserListView: View {
    let userListClient: UserListClient = UserListClient(gitHubApiClient: GitHubApiClientImpl())
    @State private var userList: UserList?
    @State private var didFailLoad: Bool = false
    @State private var loadId: UUID = .init()
    @State private var addLoadId: UUID = .init()

    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            if let userList {
                List(userList.users) { user in
                    NavigationLink(
                        value: user,
                        label: {
                            UserView(user: user)
                                .task(id: addLoadId) {
                                    guard let lastUser = userList.lastUser,
                                          let nextPageLink = userList.nextPageLink,
                                          user.id == lastUser.id else {
                                        return
                                    }
                                    do {
                                        let new = try await userListClient.fetch(nextPageLink: nextPageLink)
                                        userList.append(userList: new)
                                    } catch {
                                        didFailLoad = true
                                    }
                                }
                        }
                    )
                }
                .navigationTitle("GitHub Users")
                .navigationDestination(for: User.self) { user in
                    if let userPageURL = user.userPageURL,
                       let userReposURL = user.userReposURL {
                        UserRepositoryView(userPageURL: userPageURL, userReposURL: userReposURL, userName: user.login)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .alert("User fetch failed", isPresented: $didFailLoad, actions: {
            Button("Retry") {
                if userList == nil {
                    loadId = .init()
                } else {
                    addLoadId = .init()

                }
            }
        })
        .task(id: loadId) {
            do {
                userList = try await userListClient.fetch(nextPageLink: nil)
            } catch {
                didFailLoad = true
            }
        }
    }
}

/// ユーザーの情報を表示するコンポーネント
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
