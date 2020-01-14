//
//  ChatLogViewModel+Pagination.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogViewModel {
    
    // MARK:- Public
    public func setupRefreshControl(tableView: UITableView) {
        if #available(iOS 10, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(fetchPreviousMessages), for: UIControl.Event.valueChanged)
    }

    // MARK:- Private
    @objc fileprivate func fetchPreviousMessages() {
        guard let first = self.textMessages.first else { return }
        let firstTimeStamp = first.date.timeIntervalSince1970
        ChatLogObserverManager.sharedInstance.getPreviousMessagesForThread(chatPartnerID: user.id, firstTimestamp: firstTimeStamp) { (messages) in
            self.textMessages.append(contentsOf: messages)
            self.refreshControl.endRefreshing()
            self.attemptToAssembleGroupedMessages(updateType: .pagination)
        }
    }
    
}
