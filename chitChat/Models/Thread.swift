//
//  Thread.swift
//  chitChat
//
//  Created by Rowan Rhodes on 10/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation

protocol ThreadDelegate: NSObject {
    func reloadCell(messageID: String)
}

class Thread {
    
    // MARK:- Properties
    var chatPartner: user
    var lastMessage: BaseMessage
    var showUnread: Bool
    weak var delegate: ThreadDelegate?
    
    // MARK:- Init
    init(chatPartner: user, lastMessage: BaseMessage, lastMessageSeen: Bool) {
        self.chatPartner = chatPartner
        self.lastMessage = lastMessage
        if !lastMessageSeen && lastMessage.fromID == chatPartner.id {
            self.showUnread = true
        } else {
            self.showUnread = false
        }
        self.listenForLastMessageChanges()
    }
    
    // MARK:- Private
    fileprivate func checkIfThreadNeedsToDisplayUnread(lastMessageSeen: Bool, chatPartnerID: String) -> Bool {
        if !lastMessageSeen && lastMessage.fromID == chatPartnerID {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func listenForLastMessageChanges() {
        ConversationObserverManager.sharedInstance.listenForChangesInLastMessage(chatPartner: self.chatPartner.id) { [weak self] (message, lastMessageSeen)  in
            guard let self = self else { return }
            self.lastMessage = message
            self.showUnread = (self.checkIfThreadNeedsToDisplayUnread(lastMessageSeen: lastMessageSeen, chatPartnerID: (self.chatPartner.id)!))!
            self.delegate?.reloadCell(messageID: ((self.lastMessage.messageID)!))
        }
    }
    
}
