//
//  User.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation

struct user {
    
    // MARK:- Properties
    let id: String
    let name: String
    let email: String
    let photoURL: String?
    var lastOnline: String?
    
    // MARK:- Init
    init(id: String, name: String, email: String, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.photoURL = photoURL
    }
}
