//
//  MockAuthenticationService.swift
//  MobileAcebookTests
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation
@testable import MobileAcebook

class MockAuthenticationService: AuthenticationServiceProtocol {
    
    // For controlling the behavior of signUp
        var signUpResult: Result<Bool, Error> = .success(true)
        var signUpHandler: ((User, @escaping (Result<Bool, Error>) -> Void) -> Void)?
        
        func signUp(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
            if let signUpHandler = signUpHandler {
                signUpHandler(user, completion)
            } else {
                // Simulate asynchronous behavior
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion(self.signUpResult)
                }
            }
        }
    
    var logInResult: Bool = true
    var logInHandler: ((User, @escaping (Bool) -> Void) -> Void)?
    
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

