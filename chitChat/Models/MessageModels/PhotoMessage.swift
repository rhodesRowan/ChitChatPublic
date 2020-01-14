//
//  photoMessage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

class PhotoMessage: BaseMessage {
    
    // MARK:- Properties
    var imageURL: String
    
    // MARK:- Init
    init(toID: String, fromID: String, date: Double, messageID: String, imageURL: String, type: chatLogViewModelItemType) {
        self.imageURL = imageURL
        super.init(toID: toID, fromID: fromID, date: Date(timeIntervalSince1970: TimeInterval(exactly: date)!)
            , messageID: messageID, type: type)
    }
}
