//
//  AuthenticationServiceTests.swift
//  MobileAcebookTests
//
//  Created by Abdallah Harun on 03/09/2024.
//

import Foundation
import XCTest
@testable import MobileAcebook

class AuthenticationServiceTests: XCTestCase {
    var mockService: MockAuthenticationService!

    override func setUpWithError() throws {
        mockService = MockAuthenticationService()
    }

    override func tearDownWithError() throws {
        mockService = nil
    }

    func testSignUp() {
        let expectation = self.expectation(description: "A new user being registred")
        let user = User(email: "test@example.com", username: "Mr Test", password: "password123")
        mockService.signUpResult = .success(true)
        
        mockService.signUp(user: user) { result in
            switch result {
                    case .success(let success):
                        XCTAssertTrue(success, "The user should be registered successfully")
                    case .failure(let error):
                        XCTFail("Expected success, but got failure: \(error)")
                    }
                    expectation.fulfill()
                }
            waitForExpectations(timeout: 5.0, handler: nil)
        }
    
    func testLogIn_Success() {
        let expectation = self.expectation(description: "Login successful")
        let user = User(email: "test@example.com", password: "password123")
        mockService.logInResult = true

        mockService.logIn(user: user) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLogIn_Failure() {
        let expectation = self.expectation(description: "Login failed")
        let user = User(email: "test@example.com", password: "password123")
        mockService.logInResult = false

        mockService.logIn(user: user) { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
