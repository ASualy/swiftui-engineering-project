//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

public struct User: Encodable {
    let email: String
    let username: String?
    let password: String
    
    init(email: String, password: String, username: String? = nil) {
         self.email = email
         self.password = password
         self.username = username
     }
}
