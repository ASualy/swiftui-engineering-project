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
    let message: String
    let imgUrl: String?
    let likes: [String]
    let createdAt: String?
    let createdBy: CreatedBy

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message
        case imgUrl
        case likes
        case createdAt
        case createdBy
    }
}

struct CreatedBy: Codable {
    let id: String
    let username: String
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case profilePicture // ON: Deleted = "imgUrl" as it should refer to the profilePicture in JSON structure
    }
}
    
//    init(id: String, username: String, message: String, userId: String, imgUrl: String, likes: [String]) {
//        self.id = id
//        self.username = username
//        self.message = message
//        self.userId = userId
//        self.imgUrl = imgUrl
//        self.likes = likes
//    }
    
    
