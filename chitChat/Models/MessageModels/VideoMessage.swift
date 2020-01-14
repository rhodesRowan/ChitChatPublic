//
//  VideoMessage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

class VideoMessage: BaseMessage {
    
    // MARK:- Properties
    var videoURL: String
    var thumbnailURL: String
    var thumbnailAspect: Double
    
    // MARK:- Init
    init(toID: String, fromID: String, date: Double, messageID: String, videoURL: String, thumbnailURL: String, thumbnailAspect: Double, type: chatLogViewModelItemType) {
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.thumbnailAspect = thumbnailAspect
        super.init(toID: toID, fromID: fromID, date: Date(timeIntervalSince1970: TimeInterval(exactly: date)!)
            , messageID: messageID, type: type)
    }
    
}
