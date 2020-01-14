//
//  ChatListTableViewController+Datasource.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatListTableViewController: UITableViewDataSource {
    
    // MARK:- TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if searching {
           return self.searchingThreads.count
       } else {
           return self.orderedThreads.count
       }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archive = archiveAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [archive])
    }
    
    func archiveAction(at indexPath: IndexPath) -> UIContextualAction {
        var thread: Thread!
        if searching {
            thread = self.searchingThreads[indexPath.row]
        } else {
            thread = self.orderedThreads[indexPath.row]
        }
        let action = UIContextualAction(style: .normal, title: "Archive") { (action, view, completion) in
            action.image = UIImage(named: "archive")
            action.backgroundColor = ThemeManager.shared.greenColor
            self.threadsDict[thread.chatPartner.id] = nil
            ConversationObserverManager.sharedInstance.deleteThreadForUser(chatPartnerID: thread.chatPartner.id) { (success) in
                if success {
                    completion(true)
                } else {
                    let alertFailed = UIAlertController.failedToPerformNetworkRequest(errorMessage: "We could not seem to archive your message")
                    self.present(alertFailed, animated: true, completion: nil)
                    completion(false)
                }
            }
        }
        return action
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var thread: Thread!
       if searching {
           thread = self.searchingThreads[indexPath.row]
       } else {
           thread = self.orderedThreads[indexPath.row]
       }
       switch thread.lastMessage.type {
       case .textMessageCell:
           let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTextCellID, for: indexPath) as? ChatListTextCell ?? ChatListTextCell()
           cell.user = thread.chatPartner
           cell.message = thread.lastMessage as? TextMessage
           cell.showUnread = thread.showUnread
           return cell
       case .gifMessageCell:
           let cell = tableView.dequeueReusableCell(withIdentifier: ChatListGifCellID, for: indexPath) as? ChatListGifCell ?? ChatListGifCell()
           cell.user = thread.chatPartner
           cell.message = thread.lastMessage as? GifMessage
           cell.showUnread = thread.showUnread
           return cell
       case .imageMessageCell:
           let cell = tableView.dequeueReusableCell(withIdentifier: ChatListPhotoCellID, for: indexPath) as? ChatListPhotoCell ?? ChatListPhotoCell()
           cell.user = thread.chatPartner
           cell.message = thread.lastMessage as? PhotoMessage
           cell.showUnread = thread.showUnread
           return cell
       case.videoMessageCell:
           let cell = tableView.dequeueReusableCell(withIdentifier: ChatListVideoCellID, for: indexPath) as? ChatListVideoCell ?? ChatListVideoCell()
           cell.user = thread.chatPartner
           cell.message = thread.lastMessage as? VideoMessage
           cell.showUnread = thread.showUnread
           return cell
       }
   }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
}
