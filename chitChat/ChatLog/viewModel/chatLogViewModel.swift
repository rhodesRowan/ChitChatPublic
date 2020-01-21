//
//  chatLogViewModel.swift
//  chitChat
//
//  Created by Rowan Rhodes on 16/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

enum updateType {
    // MARK:- Update types for incoming message data
    case pagination
    case initialLoad
    case newMessage
}

protocol ChatLogViewModelDelegate: class {
    // MARK:- Delegate Methods
    func apply(changes: SectionChanges, applyType: updateType)
    func cellSelected()
}

class ChatLogViewModel: NSObject {
    
    // MARK:- Properties
    var items = [ChatLogViewModelMessagesItem]()
    var textMessages = [BaseMessage]()
    weak var delegate: ChatLogViewModelDelegate?
    var initialChatThreadObserver: DatabaseReference?
    var newChatThreadObserver: DatabaseReference?
    var startingFrame: CGRect?
    var backgroundView: UIView?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playButton: UIButton!
    var user: user!
    let refreshControl = UIRefreshControl()
    var isInitialLoad = true

    
    // MARK:- Init
    override init() {
        super.init()
    }
    
    // MARK:- Deinit
    
    deinit {
        print("CHAT LOG VIEW MODEL DEINIT")
    }
    
    // MARK:- Public
    
    public func observeInitialMessages(User: user) {
        self.user = User
        self.initialChatThreadObserver = ChatLogObserverManager.sharedInstance.observeInitialMessagesForThread(chatPartnerID: User.id, completion: { [weak self] (messages) in
            guard let self = self else { return }
            self.textMessages = messages
            self.attemptToAssembleGroupedMessages(updateType: .initialLoad)
            self.observeNewMesages(User: User)
        })
    }
    
    public func observeNewMesages(User: user) {
        self.newChatThreadObserver = ChatLogObserverManager.sharedInstance.observeNewMessagesForThread(chatPartnerID: User.id, completion: { (message) in
            guard self.isInitialLoad == false else { return }
            guard !(self.textMessages.contains(where: {$0.messageID == message?.messageID})) else { return }
            self.textMessages.append(message!)
            self.attemptToAssembleGroupedMessages(updateType: .newMessage)
        })
    }
    
    public func removeObserverForChatLog() {
        self.initialChatThreadObserver?.removeAllObservers()
        self.newChatThreadObserver?.removeAllObservers()
    }
    
    public func attemptToAssembleGroupedMessages(updateType: updateType) {
        var newItems = [ChatLogViewModelMessagesItem]()
        self.textMessages.sort { (textMessage1, textMessage2) -> Bool in
            return textMessage1.date < textMessage2.date
        }
        let groupedMessages = Dictionary(grouping: self.textMessages) { (element) -> Date in
            return element.startOfDay
        }
        let sortedSections = groupedMessages.sorted { (dict1, dict2) -> Bool in
            return dict1.key < dict2.key
        }
        for (key, _) in sortedSections {
            let values = groupedMessages[key]
            let chatLogViewModel = ChatLogViewModelMessagesItem(messages: values ?? [], startOfDay: key)
            newItems.append(chatLogViewModel)
        }
        self.setup(newItems: newItems, applyType: updateType)
    }
    
    // MARK:- Private
    
    private func flatten(items: [ChatLogViewModelMessagesItem]) -> [ReloadableSection<CellItem>] {
        let reloadableItems = items.enumerated().map { ReloadableSection(key: $0.element.startOfDay, value: $0.element.cellItems.enumerated().map { ReloadableCell(key: $0.element.id, value: $0.element, index: $0.offset)}, index: $0.offset)}
        return reloadableItems
    }
    
    private func setup(newItems: [ChatLogViewModelMessagesItem], applyType: updateType) {
        let oldData = self.flatten(items: self.items)
        let newData = self.flatten(items: newItems)
        let sectionChanges = DiffCalculator.calculate(oldSectionItems: oldData, newSectionItems: newData)
        self.items = newItems
        delegate?.apply(changes: sectionChanges, applyType: applyType)
    }
    
}
