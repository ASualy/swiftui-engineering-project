import XCTest
@testable import MobileAcebook

class LoginViewTests: XCTestCase {
    var sut: LoginView!
    var mockAuthService: MockAuthenticationService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthenticationService()
        sut = LoginView(authService: mockAuthService)
    }
    
    override func tearDown() {
        sut = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    func testLoginActionCallsAuthServiceWithCorrectParameters() {
        let expectation = XCTestExpectation(description: "AuthService's logIn method should be called")
        
        // Set up the mock auth service before setting the email and password
        mockAuthService.logInHandler = { user, completion in
            XCTAssertEqual(user.email, "test@example.com")
            XCTAssertEqual(user.password, "password123")
            expectation.fulfill()
            completion(true)
        }
        
        // Use a custom initializer for LoginView that allows us to set initial values
        sut = LoginView(email: "test@example.com", password: "password123", authService: mockAuthService)
        
        sut.loginAction()
        
        wait(for: [expectation], timeout: 2.0)
    }

    
//    func testLoginActionInvokesCompletionHandlerOnSuccess() {
//        sut.email = "test@example.com"
//        sut.password = "password123"
//        
//        let expectation = XCTestExpectation(description: "Completion handler should be invoked with success = true")
//        
//        mockAuthService.logInResult = true
//        
//        mockAuthService.logInHandler = { _, completion in
//            completion(true)
//        }
//        
//        sut.loginAction()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//            XCTAssertTrue(self.mockAuthService.logInResult)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
//    }
    
//    func testLoginActionInvokesCompletionHandlerOnFailure() {
//        sut.email = "test@example.com"
//        sut.password = "wrongpassword"
//        
//        let expectation = XCTestExpectation(description: "Completion handler should be invoked with success = false")
//        
//        mockAuthService.logInResult = false
//        
//        mockAuthService.logInHandler = { _, completion in
//            completion(false)
//        }
//        
//        sut.loginAction()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//            XCTAssertFalse(self.mockAuthService.logInResult)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
//    }
}
