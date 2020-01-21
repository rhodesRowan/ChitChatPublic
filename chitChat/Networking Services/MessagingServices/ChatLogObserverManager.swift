//
//  MessageObserverManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation
import Firebase

class ChatLogObserverManager {
    
    // MARK:- Properties
    private let databaseRef = Database.database().reference()
    static let sharedInstance = ChatLogObserverManager()
    
    // MARK:- Public
    
    /// get the previous 30 messages for the thread, the messages are from before the current first meessage  in the array's timestamp, used for a pagination update
    /// - Parameters:
    ///   - chatPartnerID: the user id of the other used in the thread
    ///   - firstTimeStamp: the timestamp of the current first message in the thread
    ///   - completion: an array of the last messages that appeard in the thread
    public func getPreviousMessagesForThread(chatPartnerID: String, firstTimestamp: Double, completion: @escaping (_ messages: [BaseMessage]) -> Void) {
        guard let user = AuthManager.sharedInstance.getCurrentUser() else { return }
        var tempMessages = [BaseMessage]()
        let group = DispatchGroup()
        let threadRef = databaseRef.child("user-messages").child(user.uid).child(chatPartnerID).child("messages").queryOrdered(byChild: "timestamp").queryEnding(atValue: firstTimestamp).queryLimited(toLast: 30)
        threadRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            threadRef.removeAllObservers()
            if let messagesDict = snapshot.value as? [String: Any] {
                for message in messagesDict {
                    group.enter()
                    self.fetchMessage(messageID: message.key) { (message) in
                        if (message.date != Date(timeIntervalSince1970: firstTimestamp)) {
                            tempMessages.append(message)
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion(tempMessages)
            }
        }
    }
    
    
    /// Returns the last 30 messages in the thread, used for an initial load update so the tableview can be populated
    /// - Parameters:
    ///   - chatPartnerID: the user id of the other used in the thread
    ///   - completion: an array of messages and a reference which can be used later for removing the observer.
    public func observeInitialMessagesForThread(chatPartnerID: String, completion: @escaping (_ message: [BaseMessage]) -> Void) -> DatabaseReference? {
        guard let user = AuthManager.sharedInstance.getCurrentUser() else { return nil}
        let threadRef = databaseRef.child("user-messages").child(user.uid).child(chatPartnerID).child("messages")
        let group = DispatchGroup()
        var messages = [BaseMessage]()
        threadRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 30).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            if let messagesArray = snapshot.value as? [String: Any] {
                for message in messagesArray {
                    group.enter()
                    self.fetchMessage(messageID: message.key) { (message) in
                        messages.append(message)
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion(messages)
            }
        }
        return threadRef
    }
    
    
    /// Observes any new messages added to the user messages node and fetches the node
    /// - Parameters:
    ///   - chatPartnerID: the user id of the other used in the thread
    ///   - completion: a single base message
    public func observeNewMessagesForThread(chatPartnerID: String, completion: @escaping (_ message: BaseMessage?) -> Void) -> DatabaseReference? {
        guard let user = AuthManager.sharedInstance.getCurrentUser() else { return nil}
        let threadRef = databaseRef.child("user-messages").child(user.uid).child(chatPartnerID).child("messages")
        threadRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            self.fetchMessage(messageID: snapshot.key, completion: { (message) in
                completion(message)
            })
        }
        return threadRef
    }
    
    
    // MARK:- Private
    private func fetchMessage(messageID: String, completion: @escaping(_ message: BaseMessage) -> Void) {
        let messageRef = databaseRef.child("messages").child(messageID)
        messageRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any], let toID = dict["toID"] as? String, let fromID = dict["fromID"] as? String, let date = dict["timestamp"] as? Double {
                if let text = dict["text"] as? String {
                    let textMessage = TextMessage(toID: toID, fromID: fromID, text: text, date: date, messageID: messageID, type: .textMessageCell)
                    completion(textMessage)
                } else if let imageURL = dict["imageURL"] as? String {
                    let photoMessage = PhotoMessage(toID: toID, fromID: fromID, date: date, messageID: messageID, imageURL: imageURL, type: .imageMessageCell)
                    completion(photoMessage)
                } else if let gifID = dict["gifID"] as? String {
                    let gifMessage = GifMessage(toID: toID, fromID: fromID, date: date, messageID: messageID, gifID: gifID, type: .gifMessageCell)
                    completion(gifMessage)
                } else if let videoURL = dict["videoURL"] as? String, let thumbnailImage = dict["thumbnailURL"] as? String, let thumbnailAspect = dict["thumbnailAspect"] as? Double {
                    let videoMessage = VideoMessage(toID: toID, fromID: fromID, date: date, messageID: messageID, videoURL: videoURL, thumbnailURL: thumbnailImage, thumbnailAspect: thumbnailAspect, type: .videoMessageCell)
                    completion(videoMessage)
                }
            }
        }
    }

}
