//
//  ChatListTableViewController+ThreadDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 14/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation

extension ChatListTableViewController: ThreadDelegate {
    
    
    func reloadCell(messageID: String) {
        guard let index = self.orderedThreads.firstIndex(where: {$0.lastMessage.messageID == messageID}) else { return }
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
}
