//
//  PostManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import AVFoundation

class MessageManager {
    
    // MARK:- Properties
    private let databaseRef = Database.database().reference()
    private var conversations = [TextMessage]()
    private let storageRef = Storage.storage().reference()
    static let sharedInstance = MessageManager()
    
    
    // MARK:- Public
    
    /// places a message in the firebase database, aswell as updating the user-messages node for both the current user and the chat partner
    /// - Parameters:
    ///   - payload: a dictionary of [String: Any], should contain a messageID, fromID, toID, and a timestamp
    ///   - completion: boolean value indicating whether the update was successful
    public func sendMessage(payload: [String: Any], completion: @escaping (_ success: Bool) -> Void) {
        guard let user = AuthManager.sharedInstance.getCurrentUser() else { return }
        let toID = payload["toID"] as! String
        let timestamp = payload["timestamp"] as! Int
        let messageID = UUID().uuidString
        let messagesUpdate: [String: Any] = ["messages/\(messageID)": payload,
                                             "user-messages/\(user.uid)/\(toID)/messages/\(messageID)/timestamp": timestamp,
                                             "user-messages/\(toID)/\(user.uid)/messages/\(messageID)/timestamp": timestamp,
                                             "user-messages/\(user.uid)/\(toID)/metaData" : ["lastMessageID": messageID, "lastMessage": payload, "lastMessageSeen": false],
                                             "user-messages/\(toID)/\(user.uid)/metaData" : ["lastMessageID": messageID, "lastMessage": payload, "lastMessageSeen": false]
                                            ]
        self.databaseRef.updateChildValues(messagesUpdate) { (err, ref) in
            if let error = err {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    /// uploads an image to firebase storage
    /// - Parameters:
    ///   - imgData: the data of the image  to be stored
    ///   - completion: bolean value indicating whether the update was succesful or not
    public func uploadImage(imgData: Data, completion: @escaping (_ success: String?) -> Void) {
        let uid = NSUUID().uuidString
        let ImagesPath = storageRef.child("messageImages").child(uid)
        ImagesPath.putData(imgData, metadata: nil) { (metaData, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
            } else {
                    ImagesPath.downloadURL(completion: { (url, err) in
                    if let err = error {
                        print(err.localizedDescription)
                        completion(nil)
                    } else {
                        completion(url?.absoluteString)
                    }
                })
            }
        }
    }
    
    
    /// uploads a video to firebase storage
    /// - Parameters:
    ///   - videoData: the data of the video to be stored
    ///   - completion: bolean value indicating whether the upload was successful or not
    public func uploadVideo(videoData: Data, completion: @escaping (_ success: String?,_ thumbnailImageURL: String?, _ thumbnailAspect: Double?) -> Void) {
        let uid = NSUUID().uuidString + ".mov"
        let videoPath = storageRef.child("messageVideos").child(uid)
        videoPath.putData(videoData, metadata: nil) { (metaData, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil, nil, nil)
            } else {
                videoPath.downloadURL(completion: { [weak self] (url, err) in
                    guard let self = self else { return }
                    if let err = error {
                        print(err.localizedDescription)
                        completion(nil, nil, nil)
                    } else {
                        if let img = self.fetchThumbnailForVideoFile(url: url!) {
                            let imgData = img.jpegData(compressionQuality: 0.1)
                            self.uploadImage(imgData: imgData!) { (downloadURL) in
                                if error != nil {
                                    print(error?.localizedDescription ?? "there was an error uploading the image")
                                    completion(nil, nil, nil)
                                } else {
                                    let aspect = img.size.width / img.size.height
                                    completion(url?.absoluteString, downloadURL, Double(aspect))
                                }
                            }
                        } else {
                            completion(nil, nil, nil)
                        }
                    }
                })
            }
        }
    }
    
    
    /// sets the last message in the thread to be read if the sender is not the current user
    /// - Parameters:
    ///   - chatPartnerID: the id of the other used in the thread
    ///   - lastMessageSender: the id of the last message sender in the thread
    public func setLastMessageRead(chatPartnerID: String, lastMessageSender: String) {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        guard currentUser.uid != lastMessageSender else { return }
        let readUpdates: [String: Any] = ["user-messages/\(chatPartnerID)/\(currentUser.uid)/metaData/lastMessageSeen": true,
                "user-messages/\(currentUser.uid)/\(chatPartnerID)/metaData/lastMessageSeen": true]
        self.databaseRef.updateChildValues(readUpdates)
    }
    
    // MARK:- Private
    fileprivate func fetchThumbnailForVideoFile(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}


