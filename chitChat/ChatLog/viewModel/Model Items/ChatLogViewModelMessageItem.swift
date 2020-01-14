//
//  ChatLogViewModelMessageItem.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

class ChatLogViewModelMessagesItem: ChatLogViewModelItem {
    
    // MARK:- Properties
    var startOfDay: String
    var messages: [BaseMessage]
    var cellItems: [CellItem] {
        return messages.map { CellItem(value: $0, id: $0.messageID)}
    }
    var sectionTitle: String {
        return self.startOfDay
    }
    var rowCount: Int {
        return self.messages.count
    }
    
    // MARK:- Init
    init(messages: [BaseMessage], startOfDay: Date) {
        self.messages = messages
        self.startOfDay = Date.convertDateToDayDateString(date: startOfDay)
    }
    
}
