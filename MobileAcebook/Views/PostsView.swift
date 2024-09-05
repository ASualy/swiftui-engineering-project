import SwiftUI

//struct PostsView: View {
//    let post: Post
////    @StateObject private var viewModel =
////    PostViewModel()
//    
//    var welcome: some View {
//        VStack(alignment: .center) {
//            Text("Welcome, \(post.username)") // need to change to user.username
//                .padding(20)
//                .font(.largeTitle)
//                .padding(.bottom, 20)
//            
//            Text("Recent Posts")
//                .padding(.leading, 20)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.title)
//            
//        }
//    }
//}
//    
//    var header: some View {
//        HStack {
//            Image("profile")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .clipped()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .padding(.leading)
//            
//            VStack(alignment: .leading) {
//                Text(post.username)
//                    .font(.title)
//                    .bold()
//            }
//            
//            Spacer()
//            
//            Image(systemName: "ellipsis")
//                .padding()
//        }
//    }
//    
//    var imageContainer: some View {
//        VStack {
//            Image("Image")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .clipped()
//                .frame(maxWidth: .infinity)
//        }
//        .padding(.bottom, 10)
//    }
//    
//    var messageContainer: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(post.message)
//                .font(.system(size: 25))
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
//                .padding(.bottom, 10)
//        }
//    }
//    
//    var actionButtons: some View {
//        HStack {
//            Image(systemName: "heart")
//                .renderingMode(.template)
//                .foregroundColor(Color(.label))
//                Text("3") // needs updating to likes count once handlelike added with toggle and add colour
//            
//            Image(systemName: "bubble.left")
//                .renderingMode(.template)
//                .foregroundColor(Color(.label))
//                .onTapGesture {
//                    print("Handle comment.")
//                }
//        }
//        .padding(.leading, 20)
//        .padding(.bottom, 20)
//    }
//    
//    var body: some View {
//        ScrollView {
//            List(viewModel.post) {post in
//                VStack(alignment: .leading) {
//                    welcome
//                    
//                    header
//                    
//                    imageContainer
//                    
//                    messageContainer
//                    
//                    actionButtons
//                    
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//struct PostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsView(post: Post(id: "", username: "Archie", message: "I am a cat and I am ADORABLE", userId: "", imgUrl: "", likes: [""]))
//    }
//}
struct PostsView: View {
    @State private var posts: [Post] = []
    @State private var isLoading: Bool = true // Track loading state
    @State private var errorMessage: String? = nil // Track error message
    
    private let authenticationService = AuthenticationService()

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
            Image("Image") // Placeholder, replace with image loading for post.imgUrl
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(maxWidth: .infinity)
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
        authenticationService.fetchPosts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPosts):
                    self.posts = fetchedPosts // fetchedPosts should be an array of `Post`
                    self.isLoading = false
                case .failure(let error):
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
