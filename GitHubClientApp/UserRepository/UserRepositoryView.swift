import SwiftUI

struct UserRepositoryView: View {
    let userPageURL: URL
    let userReposURL: URL
    let userName: String
    let userRepositoryClient = UserRepositoryClient(gitHubApiClient: GitHubApiClientImpl())
    @State private var userRepository: UserRepository?
    var body: some View {
        VStack {
            if let userRepository {
                VStack {
                    UserDetailView(userDetail: userRepository.userDetail)
                    UserRepositoryListView(repositories: userRepository.originalRepositories)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("\(userName)")
        .task {
            do {
                let user = try await userRepositoryClient.fetch(userPageURL: userPageURL)
                let repositories = try await userRepositoryClient.fetch(userRepositoriesURL: userReposURL)
                userRepository = .init(userDetail: user, repositories: repositories)
            } catch {
                print("\(error.localizedDescription)")
            }
            
        }
    }
}

struct UserDetailView: View {
    let userDetail: UserDetail
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(userDetail.name ?? userDetail.login)")
                        .font(.system(.title3, weight: .bold))
                    Text("\(userDetail.login)")
                        .foregroundStyle(.gray)
                }
            }
            
            HStack(spacing: 8) {
                Text("followers: \(userDetail.followers)")
                Text("following: \(userDetail.following)")
            }
        }
    }
}

struct UserRepositoryListView: View {
    let repositories: [Repository]
    var body: some View {
        List(repositories) { repository in
            NavigationLink(
                value: repository,
                label: {
                    RepositoryView(repository: repository)
                }
            )
            
        }
        .listStyle(.plain)
        .navigationDestination(for: Repository.self) { repository in
            if let repositoryPageURL = repository.repositoryPageURL {
                
                WebView(url: repositoryPageURL)
            }
        }
    }
}

struct RepositoryView: View {
    let repository: Repository
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(repository.name)")
                .font(.system(.headline, weight: .bold))
            if let description = repository.description {
                Text("\(description)")
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.yellow)
                    
                    Text("\(repository.stargazers_count)")
                        .font(.system(.subheadline))
                        .foregroundStyle(.gray)
                }
                if let language = repository.language {
                    Text("\(language)")
                        .font(.system(.subheadline))
                        .foregroundStyle(.gray)
                }
                
            }
        }
    }
}

//#Preview {
//    UserRepositoryView(
//        userPageURL: URL(string: "https://api.github.com/users/octocat")!,
//        userReposURL: URL(string: "https://api.github.com/users/octocat/repos")!, userName: "Rosa"
//    )
//}
