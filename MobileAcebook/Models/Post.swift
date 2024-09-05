//
//  Post.swift
//  MobileAcebook
//
//  Created by Anna Gwozdz on 03/09/2024.
//

import Foundation

//struct Post: Identifiable, Codable {
//    @Published var posts: [Post] = []  // need to add date below and to init
struct Post: Identifiable, Codable {
    let id: String
    let username: String
    let message: String
    let userId: String
    let imgUrl: String
    let likes: [String]
    
//    init(id: String, username: String, message: String, userId: String, imgUrl: String, likes: [String]) {
//        self.id = id
//        self.username = username
//        self.message = message
//        self.userId = userId
//        self.imgUrl = imgUrl
//        self.likes = likes
//    }
    
    
}
