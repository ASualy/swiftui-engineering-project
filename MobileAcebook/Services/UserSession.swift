//
//  UserSession.swift
//  MobileAcebook
//
//  Created by Abdallah Harun on 04/09/2024.
//

import Foundation
import Combine

class UserSession: ObservableObject {
    @Published var userId: String? = nil
    @Published var isLoggedIn: Bool = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        // Load saved session state on initialization
        self.userId = userDefaults.string(forKey: "userId")
        self.isLoggedIn = userDefaults.bool(forKey: "isLoggedIn")
    }
    
    func logIn(userId: String) {
        self.userId = userId
        self.isLoggedIn = true
        
        // Save session state
        userDefaults.set(userId, forKey: "userId")
        userDefaults.set(true, forKey: "isLoggedIn")
    }
    
    func logOut() {
        self.userId = nil
        self.isLoggedIn = false
        
        // Clear saved session state
        userDefaults.removeObject(forKey: "userId")
        userDefaults.set(false, forKey: "isLoggedIn")
    }
}
