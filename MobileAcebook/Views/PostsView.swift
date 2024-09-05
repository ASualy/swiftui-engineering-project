import SwiftUI

struct PostsView: View {
    @State private var posts: [Post] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
    private let feedService = FeedService()

    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView("Loading Posts...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    if posts.isEmpty {
                        Text("No posts available")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(posts) { post in
                            VStack(alignment: .leading) {
                                header(for: post)
                                imageContainer(for: post)
                                messageContainer(for: post)
                                actionButtons(for: post)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .onAppear {
                fetchPosts()
            }
        }
    }
    
    func header(for post: Post) -> some View {
        HStack {
            if let profilePictureUrl = post.createdBy.profilePicture,
               let url = URL(string: profilePictureUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.leading)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.leading)
                    case .failure:
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.leading)
                    @unknown default:
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.leading)
                    }
                }
            }

            VStack(alignment: .leading) {
                Text(post.createdBy.username)
                    .font(.title)
                    .bold()
            }

            Spacer()

            Image(systemName: "ellipsis")
                .padding()
        }
    }
    
    func imageContainer(for post: Post) -> some View {
        VStack {
            if let imageUrl = post.imgUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image("Image") // Placeholder image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(maxWidth: .infinity)
                    case .failure:
                        Image("Image") // Fallback in case of failure
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(maxWidth: .infinity)
                    }
                }
            } else {
                Image("Image") // Placeholder if no image URL
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 10)
    }
    
    func messageContainer(for post: Post) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.message)
            Text(post.createdBy.username)
            Text(post.id)
            Text(post.createdAt ?? "Date unavailable")
                .font(.system(size: 25))
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
        }
    }
    
    func actionButtons(for post: Post) -> some View {
        HStack {
            Image(systemName: "heart")
                .renderingMode(.template)
                .foregroundColor(Color(.label))
            Text("\(post.likes.count)")

            Image(systemName: "bubble.left")
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .onTapGesture {
                    print("Handle comment.")
                }
        }
        .padding(.leading, 20)
        .padding(.bottom, 20)
    }
    
    func fetchPosts() {
        feedService.fetchPosts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPosts):
                    print("Fetched posts: \(fetchedPosts)") // Debug log
                    self.posts = fetchedPosts
                    self.isLoading = false
                case .failure(let error):
                    print("Failed to fetch posts: \(error.localizedDescription)") // Debug log
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
