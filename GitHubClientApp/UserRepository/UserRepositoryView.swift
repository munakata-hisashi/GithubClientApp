import SwiftUI

/// ユーザーリポジトリ画面
///
/// ユーザーの詳細情報としてアイコン、ユーザー名、フルネーム、フォロワー数、フォロイー数を表示する。
/// またユーザーのforkedではないリポジトリを一覧表示する
struct UserRepositoryView: View {
    let userPageURL: URL
    let userReposURL: URL
    let userName: String
    let userRepositoryClient = UserRepositoryClient(gitHubApiClient: GitHubApiClientImpl())
    @State private var userRepository: UserRepository?
    
    var body: some View {
        VStack {
            if let userRepository {
                VStack(alignment: .leading) {
                    UserDetailView(userDetail: userRepository.userDetail)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Repositories")
                            .font(.system(.title3, weight: .bold))
                            .padding(.horizontal, 16)
                        UserRepositoryListView(
                            userRepository: userRepository,
                            userRepositoryClient: userRepositoryClient
                        )
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("\(userName)")
        .task {
            do {
                async let user =  userRepositoryClient.fetch(userPageURL: userPageURL)
                async let (repositories, nextPageLink) = userRepositoryClient.fetch(userRepositoriesURL: userReposURL)
                userRepository = try await .init(userDetail: user, repositories: repositories, nextPageLink: nextPageLink)
            } catch {
                print("\(error.localizedDescription)")
            }
            
        }
    }
}

/// ユーザーの詳細情報を表示するコンポーネント
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

/// ユーザーのリポジトリを一覧表示するコンポーネント
struct UserRepositoryListView: View {
    var userRepository: UserRepository
    let userRepositoryClient: UserRepositoryClient
    
    var body: some View {
        List(userRepository.originalRepositories) { repository in
            NavigationLink(
                value: repository,
                label: {
                    RepositoryView(repository: repository)
                        .task {
                            guard let lastRepo = userRepository.originalRepositories.last,
                                  let _nextPageLink = userRepository.nextPageLink,
                                  repository.id == lastRepo.id else {
                                return
                            }
                            do {
                                let (repositories, nextPageLink) = try await userRepositoryClient.fetch(userRepositoriesURL: _nextPageLink)
                                userRepository.append(new: repositories, nextPageLink: nextPageLink)
                            } catch {
                                print("\(error.localizedDescription)")
                            }
                        }
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

#Preview {
    UserRepositoryView(
        userPageURL: URL(string: "https://api.github.com/users/octocat")!,
        userReposURL: URL(string: "https://api.github.com/users/octocat/repos")!, userName: "Rosa"
    )
}
