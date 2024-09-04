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
