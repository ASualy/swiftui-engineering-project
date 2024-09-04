import SwiftUI

struct PostsView: View {
    let post: Post
    
    var welcome: some View {
        VStack(alignment: .center) {
            Text("Welcome, \(post.username)") // need to change to user.username
                .padding(20)
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Recent Posts")
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
        }
    }
    
    var header: some View {
        HStack {
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(post.username)
                    .font(.title)
                    .bold()
            }
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .padding()
        }
    }
    
    var imageContainer: some View {
        VStack {
            Image("Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 10)
    }
    
    var messageContainer: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.message)
                .font(.system(size: 25))
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
        }
    }
    
    var actionButtons: some View {
        HStack {
            Image(systemName: "heart")
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                Text("3") // needs updating to likes count once handlelike added
            
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                welcome
                
                header
                
                imageContainer
                
                messageContainer
                
                actionButtons
                
                Spacer()
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(post: Post(id: "", username: "Archie", message: "I am a cat and I am ADORABLE", userId: "", imgUrl: "", likes: [""]))
    }
}
