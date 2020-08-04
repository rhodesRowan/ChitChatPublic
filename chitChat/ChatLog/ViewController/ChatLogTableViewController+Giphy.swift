//
//  ChatLogTableViewController+Giphy.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation
import GiphyUISDK
import GiphyCoreSDK

extension ChatLogTableViewController: GiphyDelegate {
    
    // MARK:- @IBActions
    @IBAction func gifButtonPressed(_ sender: Any) {
        if self.traitCollection.userInterfaceStyle == .dark {
            giphy.theme = .dark
        } else {
            giphy.theme = .light
        }
        giphy.layout = .waterfall
        giphy.mediaTypeConfig = [.gifs, .stickers, .emoji, .text]
        giphy.showConfirmationScreen = true
        self.present(giphy, animated: true, completion: nil)
    }
    
    // MARK:- Giphy Delegate Methods
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        self.dismiss(animated: true, completion: nil)
        self.scrollToBottom()
        let payload: [String: Any] = ["toID": self.AppUser!.id, "fromID": currentUser.uid, "gifID": media.id, "timestamp": Int(Date().timeIntervalSince1970)]
        MessageManager.sharedInstance.sendMessage(payload: payload) { (success) in
            if !success {
                print("error sending gif")
            } else {
                print("successfully sent gif")
                self.playSendSound()
            }
        }
    }
    
    func didDismiss(controller: GiphyViewController?) {
        print("dismissed giphy")
    }
}
