//
//  SectionItem.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

struct SectionItem: Equatable {
    
    // MARK:- Properties
    let cells: [CellItem]
    
    // MARK:- Public
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        return lhs.cells == rhs.cells
    }
    
    
    
}
