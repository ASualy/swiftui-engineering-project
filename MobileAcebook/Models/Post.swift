//
//  Post.swift
//  MobileAcebook
//
//  Created by Anna Gwozdz on 03/09/2024.
//

import Foundation

class Post: ObservableObject {
    @Published var posts: [Post] = []
    
    let id: String
    let username: String
    let message: String
    let userId: String
    let imgUrl: String
    let likes: [String]
    
    init(id: String, username: String, message: String, userId: String, imgUrl: String, likes: [String]) {
        self.id = id
        self.username = username
        self.message = message
        self.userId = userId
        self.imgUrl = imgUrl
        self.likes = likes
    }
    
    func fetchPosts() {
            guard let url = URL(string: "http://localhost:3000/posts") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
    }
}
