//
//  TokenManager.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 05/09/2024.
//

import Foundation

class TokenManager {
    private let defaults = UserDefaults.standard
    private let tokenKey = "jwt_token"
    
    // Save token to UserDefaults
    func saveToken(_ token: String) {
        defaults.set(token, forKey: tokenKey)
    }
    
    // Get token from UserDefaults
    func getToken() -> String? {
        return defaults.string(forKey: tokenKey)
    }
    
    // Remove token from UserDefaults
    func deleteToken() {
        defaults.removeObject(forKey: tokenKey)
    }
}
