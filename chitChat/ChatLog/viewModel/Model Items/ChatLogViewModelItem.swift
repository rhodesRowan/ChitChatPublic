//
//  ChatLogViewModel+Helpers.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

enum chatLogViewModelItemType: Int {
    // MARK:- Types of model items
    case textMessageCell 
    case imageMessageCell
    case videoMessageCell
    case gifMessageCell
}

protocol ChatLogViewModelItem {
    // MARK:- Properties
    var cellItems: [CellItem] { get }
    var sectionTitle: String { get }
}

extension ChatLogViewModelItem {
    // MARK:- Properties
    var rowCount: Int {
        return 1
    }
}
