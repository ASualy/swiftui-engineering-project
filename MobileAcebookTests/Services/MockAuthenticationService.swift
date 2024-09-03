//
//  MockAuthenticationService.swift
//  MobileAcebookTests
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

@testable import MobileAcebook

class MockAuthenticationService: AuthenticationServiceProtocol {
    func signUp(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Mocked logic for unit tests
        return // placeholder
    }
}
