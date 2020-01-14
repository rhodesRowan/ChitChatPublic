//
//  MessageManagerTests.swift
//  chitChatTests
//
//  Created by Rowan Rhodes on 14/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import XCTest
import Firebase
@testable import chitChat

class MessageManagerTests: XCTestCase {

    var currentUser: User?
    
    override func setUp() {
        AuthManager.sharedInstance.Login(email: "rowandrhodes@gmail.com", password: "rowrhodes12") { (success, error) in
            if success {
                self.currentUser = AuthManager.sharedInstance.getCurrentUser()
            }
        }
    }
    
    override func tearDown() {
        AuthManager.sharedInstance.signOutUser { (success) in
            if success {
                print("successfully logged out")
            }
        }
    }

}
