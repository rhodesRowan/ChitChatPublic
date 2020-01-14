//
//  textMessage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation

class TextMessage: BaseMessage {
    
    // MARK:- Properties
    var text: String
    
    // MARK:- Init
    init(toID: String, fromID: String, text: String, date: Double, messageID: String, type: chatLogViewModelItemType) {
        self.text = text
        super.init(toID: toID, fromID: fromID, date: Date(timeIntervalSince1970: TimeInterval(exactly: date)!)
            , messageID: messageID, type: type)
    }
}
