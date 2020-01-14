//
//  GifMessage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

class GifMessage: BaseMessage {
    
    // MARK:- Properties
    var gifID: String
    
    // MARK:- Init
    init(toID: String, fromID: String, date: Double, messageID: String, gifID: String, type: chatLogViewModelItemType) {
        self.gifID = gifID
        super.init(toID: toID, fromID: fromID, date: Date(timeIntervalSince1970: TimeInterval(exactly: date)!)
            , messageID: messageID, type: type)
    }
    
}
