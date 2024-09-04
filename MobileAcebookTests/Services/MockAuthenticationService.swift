//
//  MockAuthenticationService.swift
//  MobileAcebookTests
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation
@testable import MobileAcebook

class MockAuthenticationService: AuthenticationServiceProtocol {
    
    var logInResult: Bool = true
    var logInHandler: ((User, @escaping (Bool) -> Void) -> Void)?
    
    func signUp(user: User) -> Bool {
        // Mocked logic for unit tests
        return true // placeholder
    }
    
    func logIn(user: User, completion: @escaping (Bool) -> Void) {
        if let logInHandler = logInHandler {
            logInHandler(user, completion)
        } else {
            // Simulate some async behavior
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(self.logInResult)
            }
        }
    }
}

