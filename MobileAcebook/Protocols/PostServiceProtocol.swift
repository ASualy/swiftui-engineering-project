//
//  PostServiceProtocol.swift
//  MobileAcebook
//
//  Created by Abdallah Harun on 04/09/2024.
//

import Foundation

protocol PostServiceProtocol {
    func createPost(post: Post, completion: @escaping (Bool) -> Void)
}
