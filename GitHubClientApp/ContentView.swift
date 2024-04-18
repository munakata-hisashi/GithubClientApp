import SwiftUI

struct ContentView: View {
    let userListClient: UserListClient = UserListClientImpl()
    @State var userList: UserList = .init(users: [])
    var body: some View {
        NavigationStack {
            List(userList.users) { user in
                NavigationLink(
                    value: user,
                    label: {
                        UserView(user: user)
                    }
                )
            }
            .navigationDestination(for: User.self) { user in
                Text("UserDetail \(user.login)")
            }
        }
        .task {
            do {
                userList = try await userListClient.fetch()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
}

struct UserView: View {
    let user: User
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(
                url: user.avatarImageURL,
                content: { image in
                    image.resizable()
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
    ContentView()
}
