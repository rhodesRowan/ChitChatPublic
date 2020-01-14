//
//  chitChatTests.swift
//  chitChatTests
//
//  Created by Rowan Rhodes on 09/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import XCTest 
import Firebase
@testable import chitChat

class AuthManagerchitChatTests: XCTestCase {

    func testSuccessfulLogin() {
        let testUserEmail = "user@testing.com"
        let testPassword = "testing123"
        let expectation = self.expectation(description: "successfulLoginAttempt")
        var wasSuccess: Bool?
        AuthManager.sharedInstance.Login(email: testUserEmail, password: testPassword) { (success, error) in
            wasSuccess = success
            expectation.fulfill()
        }
        waitForExpectations(timeout: 25, handler: nil)
        guard let loginSuccessful = wasSuccess else { return XCTAssertNotNil(wasSuccess!)}
        XCTAssert(loginSuccessful)
    }
    
    func testFailedLogin() {
        let testUserEmail = "userDoesntExist@testing.com"
        let testPassword = "doesntExist"
        let expectation = self.expectation(description: "failedLoginAttempt")
        var wasSuccess: Bool?
        var errrorMsg: String?
        AuthManager.sharedInstance.Login(email: testUserEmail, password: testPassword) { (success, error) in
            wasSuccess = success
            errrorMsg = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 25, handler: nil)
        guard let loginFailed = wasSuccess else { return XCTAssertNotNil(wasSuccess!)}
        XCTAssertFalse(loginFailed)
        XCTAssertNotNil(errrorMsg!)
    }
    
    func testSuccessfulRegistration() {
        let userEmail = UUID().uuidString + "@email.com"
        let userPassword = UUID().uuidString
        let expectation = self.expectation(description: "successfulRegistrationAttempt")
        var wasSuccess: Bool?
        AuthManager.sharedInstance.Register(email: userEmail, password: userPassword, name: "testUser" + UUID().uuidString) { (success, error) in
            wasSuccess = success
            expectation.fulfill()
        }
        waitForExpectations(timeout: 25, handler: nil)
        guard let registerSuccess = wasSuccess else { return XCTAssertNotNil(wasSuccess!)}
        XCTAssert(registerSuccess)
    }
    
    func testRegistrationFailed() {
        // user credentials that already exist
        let testUserEmail = "user@testing.com"
        let testPassword = "testing123"
        let expectation = self.expectation(description: "successfulRegistrationAttempt")
        var wasSuccess: Bool?
        var errrorMsg: String?
        AuthManager.sharedInstance.Register(email: testUserEmail, password: testPassword, name: "testUser" + UUID().uuidString) { (success, error) in
            wasSuccess = success
            errrorMsg = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 25, handler: nil)
        guard let registerFailed = wasSuccess else { return XCTAssertNotNil(wasSuccess!)}
        XCTAssertFalse(registerFailed)
        XCTAssertNotNil(errrorMsg)
    }
        
}
