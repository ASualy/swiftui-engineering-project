//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

// The main response containing user data and token
public struct UserResponse: Codable {
    let userData: [User]
    let token: String
}

public struct User: Codable {
    let _id: String?
    let email: String
    let username: String?
    let imageUrl: String?
    let password: String
    
    init(_id: String? = nil, email: String, username: String? = nil, imageUrl: String? = nil, password: String) {
        self._id = _id
         self.email = email
         self.username = username
         self.imageUrl = imageUrl
         self.password = password
     }
}
