//
//  CellItem.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

struct CellItem: Equatable {
    
    // MARK:- Properties
    var value: CustomStringConvertible
    var id: String
    
    // MARK:- Public
    static func == (lhs: CellItem, rhs: CellItem) -> Bool {
        return lhs.id == rhs.id && lhs.value.description == rhs.value.description
    }
}
