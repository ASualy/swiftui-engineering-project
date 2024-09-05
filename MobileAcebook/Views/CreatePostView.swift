import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var postContent: String = ""
    @State private var postMessage: String = ""
    @State private var isLoading: Bool = false
    
    private let postService: PostServiceProtocol
    
    init(postContent: String = "", postService: PostServiceProtocol = PostService()) {
        self._postContent = State(initialValue: postContent)
        self.postService = postService
    }
    
    var body: some View {
        VStack {
            Text("Acebook Mobile")
                .padding(50)
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Post Content:")
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextEditor(text: $postContent)
                .padding()
                .frame(width: 350, height: 200)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .accessibilityIdentifier("postContentTextEditor")
            
            Button("Create Post") {
                createPostAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5.0)
            .accessibilityIdentifier("createPostButton")
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            }
            
            Text(postMessage)
                .padding()
                .foregroundColor(postMessage == "Post Created Successfully" ? .green : .red)
            
            Spacer()
        }
    }
    
    func createPostAction() {
        guard let userId = userSession.userId else {
            self.postMessage = "Error: User not logged in"
            return
        }
        
        isLoading = true
        postMessage = ""
        
        let post = Post(id: UUID().uuidString, username: "", message: postContent, userId: userId, imgUrl: "", likes: [])
        
        postService.createPost(post: post) { success in
            DispatchQueue.main.async {
                self.isLoading = false
                self.postMessage = success ? "Post Created Successfully" : "Post Creation Failed"
                if success {
                    self.postContent = ""
                }
                
                print(success ? "Post created successfully" : "Unable to create post")
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
            .environmentObject(UserSession())
    }
}
