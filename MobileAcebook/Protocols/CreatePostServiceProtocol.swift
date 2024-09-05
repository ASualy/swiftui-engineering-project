//
//  CreatePostServiceProtocol.swift
//  MobileAcebook
//
//  Created by Abdallah Harun on 05/09/2024.
//

import Foundation

protocol CreatePostServiceProtocol {
    func createPost(post: Post, completion: @escaping (Bool) -> Void)
}
