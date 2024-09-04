//
//  Post.swift
//  MobileAcebook
//
//  Created by Anna Gwozdz on 03/09/2024.
//

import Foundation

class Post: ObservableObject {
    @Published var posts: [Post] = []
    
    let id: Int
    let username: String
    let message: String
    let imgUrl: String
    let likes: Int
    
    init(id: Int, username: String, message: String, imgUrl: String, likes: Int) {
        self.id = id
        self.username = username
        self.message = message
        self.imgUrl = imgUrl
        self.likes = likes
    }
    
    func getPost() {
        let post1 = Post(id: 0, username: "Archie", message: "woof", imgUrl: "", likes: 3)
        posts.append(post1)
    }
}
