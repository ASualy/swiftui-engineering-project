//
//  PostsView.swift
//  MobileAcebook
//
//  Created by Avni Sualy on 03/09/2024.
import SwiftUI

struct PostsView: View {
    let post: Post
    
    var welcome: some View {
        VStack {
            Text("Welcome User")
                .padding(20)
                .font(.largeTitle)
                .padding(.bottom, 20)
//            Text("Recent Posts")
//                .padding(.leading, 20)
//                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    var header: some View {
        HStack {
            Image("profile")
            // Image(post.imgUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(post.username)
                    .font(.system(size: 30))
                    .bold()
            }
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .padding()
        }
    }
    
    var actionButtons: some View {
        HStack {
            Image(systemName: "heart")
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .onTapGesture {
                    print("Handle like toggle.")
                }
            
            Image(systemName: "bubble.left")
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .onTapGesture {
                    print("Handle comment.")
                }
            
        }
        .padding()
    }
    
    var message: some View {
        VStack(alignment: .leading, spacing: 4) {
            Group {
                Text(post.message)
                    .font(.system(size: 40))
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                welcome
                
                header
                
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: 300, height: 300)
                
                actionButtons
                
                message
                
                Spacer()
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(post: Post(id: 0, username: "Archie", message: "woof", imgUrl: "", likes: 3))
    }
}
