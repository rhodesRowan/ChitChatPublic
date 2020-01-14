//
//  ChatLogTableViewController+SendingComponents.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit
import AVFoundation

extension ChatLogTableViewController {
    
    // MARK:- Public
    // setup the payload and send the message
    @objc public func handleSend() {
        guard let text = self.userInputTxt.text else { return }
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        self.userInputTxt.text = ""
        self.sendBtn.isEnabled = false
        let payload: [String: Any] = ["toID": AppUser!.id, "fromID": currentUser.uid, "text": text, "timestamp": Int(Date().timeIntervalSince1970)]
        MessageManager.sharedInstance.sendMessage(payload: payload) { (success) in
            if !success {
                print("there was an error sending the message")
            } else {
                self.scrollToBottom()
                self.userInputTxt.text = nil
                self.playSendSound()
            }
        }
    }
    
    // compress the image and upload the image to firebase storage via the MessageManager, once uploaded, grab the download url and then setup the payload to send the message
    public func setupImageForSending(selectedImageFromPicker: UIImage?) {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        if let selectedImage = selectedImageFromPicker {
            let imgData = selectedImage.jpegData(compressionQuality: 0.1)!
            MessageManager.sharedInstance.uploadImage(imgData: imgData) { (downloadURL) in
                if let url = downloadURL {
                    let payload: [String: Any] = ["toID": self.AppUser!.id, "fromID": currentUser.uid, "imageURL": url, "timestamp": Int(Date().timeIntervalSince1970)]
                    self.handleSendMedia(payload: payload)
                }
            }
        }
    }
    
    // upload the video to firebase storage via the MessageManager, then setup the payload to send the message
    public func setupVideoForSending(dataForVideo: Data) {
        MessageManager.sharedInstance.uploadVideo(videoData: dataForVideo) { (downloadURL, thumbnailImageURL, thumbnailAspect)  in
            guard let user = AuthManager.sharedInstance.getCurrentUser() else { return }
            if let url = downloadURL, let thumbnailURL = thumbnailImageURL, let thumbnailAspect = thumbnailAspect {
                let payload: [String: Any] = ["toID": self.AppUser!.id, "fromID": user.uid, "videoURL": url, "timestamp": Int(Date().timeIntervalSince1970), "thumbnailAspect": thumbnailAspect, "thumbnailURL": thumbnailURL]
                self.handleSendMedia(payload: payload)
            }
        }
    }
    
    // play the send sound once the message has been sent succesfully to the database
    public func playSendSound() {
        let url = Bundle.main.url(forResource: "send", withExtension: "mp3")!
        do {
            sendSoundEffect = try AVAudioPlayer(contentsOf: url)
            sendSoundEffect?.play()
        } catch {
            print("couldnt play message")
        }
    }
    
    // MARK:- Private
    // send the media message payload to firebase via the MessageManager service
    fileprivate func handleSendMedia(payload: [String: Any]) {
        MessageManager.sharedInstance.sendMessage(payload: payload) { (success) in
            if success {
                print("successfully sent image messages")
                self.scrollToBottom()
                self.playSendSound()
            } else {
                print("there was an error sending the message")
            }
        }
    }

    
}
