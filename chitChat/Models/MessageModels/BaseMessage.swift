//
//  BaseMessage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation

class BaseMessage {
    
    // MARK:- Properties
    let toID: String
    let fromID: String
    let date: Date
    let messageID: String
    let isIncoming: Bool
    let chatPartner: String
    let startOfDay: Date
    let type: chatLogViewModelItemType
    
    // MARK:- Init
    init(toID: String, fromID: String, date: Date, messageID: String, type: chatLogViewModelItemType) {
        self.toID = toID
        self.fromID = fromID
        self.date = date
        self.messageID = messageID
        self.type = type
        if fromID == AuthManager.sharedInstance.getCurrentUser()?.uid {
            self.chatPartner = toID
        } else {
            self.chatPartner = fromID
        }
        if fromID != self.chatPartner {
            self.isIncoming = false
        } else {
           self.isIncoming = true
        }
        self.startOfDay = Calendar.current.startOfDay(for: self.date)
    }
    
}

extension BaseMessage: CustomStringConvertible {
    var description: String {
        return messageID
    }
}
