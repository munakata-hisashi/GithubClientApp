import SwiftUI

struct UserRepositoryView: View {
    let userPageURL: URL
    let userReposURL: URL
    let userRepositoryClient = UserRepositoryClient(gitHubApiClient: GitHubApiClientImpl())
    @State private var userRepository: UserRepository?
    var body: some View {
        VStack(spacing: 32) {
            if let userRepository {
                UserDetailView(userDetail: userRepository.userDetail)
            } else {
                ProgressView()
            }
        }.task {
            do {
                let user = try await userRepositoryClient.fetch(userPageURL: userPageURL)
                userRepository = .init(userDetail: user, repositories: [])
            } catch {
                print("\(error.localizedDescription)")
            }
            
        }
    }
}

struct UserDetailView: View {
    let userDetail: UserDetail
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                AsyncImage(
                    url: userDetail.avatarImageURL,
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
                
                VStack(spacing: 4) {
                    Text("\(userDetail.name ?? userDetail.login)")
                    Text("\(userDetail.login)")
                }
            }
            
            HStack(spacing: 4) {
                Text("followers: \(userDetail.followers)")
                Text("following: \(userDetail.following)")
            }
        }
    }
}
#Preview {
    UserRepositoryView(
        userPageURL: URL(string: "https://api.github.com/users/octocat")!,
        userReposURL: URL(string: "https://api.github.com/users/octocat/repos")!
    )
}
