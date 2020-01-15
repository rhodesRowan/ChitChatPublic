//
//  ConversationObserverManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class ConversationObserverManager {
    
    // MARK:- Properties
    private let databaseRef = Database.database().reference()
    private let firestoreRef = Firestore.firestore()
    static let sharedInstance = ConversationObserverManager()

    
    // MARK:- Public
    
    /// get the current users message threads
    /// - Parameter completion: a dictionary of [String: Thread]  where string is the chatPartner's ID
    public func observeInitialUserMessages(completion: @escaping (_ threads: [String: Thread]) -> Void) -> DatabaseReference {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return databaseRef }
        var tempThreadArray = [String: Thread]()
        let ref = self.databaseRef.child("user-messages").child(currentUser.uid)
        let group = DispatchGroup()
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if let threads = snapshot.value as? [String: Any] {
                for thread in threads {
                    group.enter()
                    guard let threadValue = thread.value as? [String: Any] else { return }
                    self?.synthesisThread(thread: threadValue) { (thread) in
                        tempThreadArray[thread.chatPartner.id] = thread
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion(tempThreadArray)
            }
        }
        return ref
    }
    
    
    /// Deletes the current thread for the user
    /// - Parameters:
    ///   - chatPartnerID: the id of the other user in the thread
    ///   - completion: a bolean value indicating whether the delete was successful
    public func deleteThreadForUser(chatPartnerID: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        self.databaseRef.child("user-messages").child(currentUser.uid).child(chatPartnerID).removeValue { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    /// listen for new threads
    /// - Parameters:
    ///   - lastDate: the date of the current last thread, this will ensure that only new data after this data is added
    ///   - completion: the new thread that was added
    public func observeUserMessagesAdded(lastDate: Date, completion: @escaping (_ threads: Thread?) -> Void) -> DatabaseReference {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return databaseRef }
        let ref = self.databaseRef.child("user-messages").child(currentUser.uid)
        ref.queryOrdered(byChild: "/metaData/lastMessage/timestamp").queryStarting(atValue: lastDate.timeIntervalSince1970).queryLimited(toLast: 1).observe(.childAdded) { [weak self] (snapshot) in
            if let userThreadsDict = snapshot.value as? [String: Any] {
                self?.synthesisThread(thread: userThreadsDict) { (thread) in
                    completion(thread)
                }
            }
        }
        return ref
    }
    
    
    
    /// listen for changes in the user messages, this can be used for tracking when the last message has changed
    /// - Parameters:
    ///   - lastDate: the date of the current last thread
    ///   - completion: the thread that has changed
    public func observeUserMessagesChanged(completion: @escaping (_ threads: Thread?) -> Void) -> DatabaseReference {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return databaseRef }
        let ref = self.databaseRef.child("user-messages").child(currentUser.uid)
        ref.observe(.childChanged) { [weak self] (snapshot) in
            if let userThreadsDict = snapshot.value as? [String: Any] {
                self?.synthesisThread(thread: userThreadsDict) { (thread) in
                    completion(thread)
                }
            }
        }
        return ref
    }
    
    
    
    /// Listen for when the last message changes in a user-messages node
    /// - Parameters:
    ///   - chatPartner: the partner's id of the chat thread
    ///   - completion: the new last message and a bolean value indicating whether or not the message has been seen or not.
    public func listenForChangesInLastMessage(chatPartner: String, completion: @escaping (_ message: BaseMessage, _ lastMessageSeen: Bool) -> Void) {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        let ref = self.databaseRef.child("user-messages").child(currentUser.uid).child(chatPartner)
        ref.observe(.value) { [weak self] (snapshot) in
            if let lastMessageDict = snapshot.value as? [String: Any] {
                self?.synthesisLast(metaData: lastMessageDict, completion: { (lastMessage, messageSeen)  in
                    completion(lastMessage, messageSeen)
                })
            }
        }
    }
    
    // MARK:- Private
    fileprivate func fetchChatPartner(fromID: String, toID: String, completion: @escaping (_ user: user) -> Void) {
        var id: String!
        if fromID == AuthManager.sharedInstance.getCurrentUser()?.uid {
            id = toID
        } else {
            id = fromID
        }
        UserQueryManager.sharedInstance.fetchUser(userID: id) { (user) in
            completion(user!)
        }
    }
    
    fileprivate func synthesisLast(metaData: [String: Any], completion: @escaping (_ lastMessage: BaseMessage, _ messageSeen: Bool) -> Void) {
        if let metaData = metaData["metaData"] as? [String: Any] {
            guard let lastMessagePayload = metaData["lastMessage"] as? [String: Any], let fromID = lastMessagePayload["fromID"] as? String, let messageID = metaData["lastMessageID"] as? String, let timestamp = lastMessagePayload["timestamp"] as? Double, let toID = lastMessagePayload["toID"] as? String, let messageSeen = metaData["lastMessageSeen"] as? Bool else { return }
            self.fetchChatPartner(fromID: fromID, toID: toID) { (user) in
                if let text = lastMessagePayload["text"] as? String {
                    let textMessage = TextMessage(toID: toID, fromID: fromID, text: text, date: timestamp, messageID: messageID, type: .textMessageCell)
                    completion(textMessage, messageSeen)
                } else if let imageUrl = lastMessagePayload["imageURL"] as? String {
                    let photoMessage = PhotoMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, imageURL: imageUrl, type: .imageMessageCell)
                    completion(photoMessage, messageSeen)
                } else if let gifID = lastMessagePayload["gifID"] as? String {
                    let gifMessage = GifMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, gifID: gifID, type: .gifMessageCell)
                    completion(gifMessage, messageSeen)
                } else if let videoURL = lastMessagePayload["videoURL"] as? String, let thumbnailImage = lastMessagePayload["thumbnailURL"] as? String, let thumbnailAspect = lastMessagePayload["thumbnailAspect"] as? Double {
                    let videoMessage = VideoMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, videoURL: videoURL, thumbnailURL: thumbnailImage, thumbnailAspect: thumbnailAspect,  type: .videoMessageCell)
                    completion(videoMessage, messageSeen)
                }
            }
        }
    }
    
    fileprivate func synthesisThread(thread: [String: Any], completion: @escaping (_ thread: Thread) -> Void) {
        if let metaData = thread["metaData"] as? [String: Any] {
            guard let lastMessagePayload = metaData["lastMessage"] as? [String: Any], let fromID = lastMessagePayload["fromID"] as? String, let messageID = metaData["lastMessageID"] as? String, let messageSeen = metaData["lastMessageSeen"] as? Bool, let timestamp = lastMessagePayload["timestamp"] as? Double, let toID = lastMessagePayload["toID"] as? String else { return }
            self.fetchChatPartner(fromID: fromID, toID: toID) { (user) in
                if let text = lastMessagePayload["text"] as? String {
                    let textMessage = TextMessage(toID: toID, fromID: fromID, text: text, date: timestamp, messageID: messageID, type: .textMessageCell)
                    let thread = Thread(chatPartner: user, lastMessage: textMessage, lastMessageSeen: messageSeen)
                    completion(thread)
                } else if let imageUrl = lastMessagePayload["imageURL"] as? String {
                    let photoMessage = PhotoMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, imageURL: imageUrl, type: .imageMessageCell)
                    let thread = Thread(chatPartner: user, lastMessage: photoMessage, lastMessageSeen: messageSeen)
                    completion(thread)
                } else if let gifID = lastMessagePayload["gifID"] as? String {
                    let gifMessage = GifMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, gifID: gifID, type: .gifMessageCell)
                    let thread = Thread(chatPartner: user, lastMessage: gifMessage, lastMessageSeen: messageSeen)
                    completion(thread)
                } else if let videoURL = lastMessagePayload["videoURL"] as? String, let thumbnailImage = lastMessagePayload["thumbnailURL"] as? String, let thumbnailAspect = lastMessagePayload["thumbnailAspect"] as? Double {
                    let videoMessage = VideoMessage(toID: toID, fromID: fromID, date: timestamp, messageID: messageID, videoURL: videoURL, thumbnailURL: thumbnailImage, thumbnailAspect: thumbnailAspect,  type: .videoMessageCell)
                    let thread = Thread(chatPartner: user, lastMessage: videoMessage, lastMessageSeen: messageSeen)
                    completion(thread)
                }
            }
        }
    }
    
}
