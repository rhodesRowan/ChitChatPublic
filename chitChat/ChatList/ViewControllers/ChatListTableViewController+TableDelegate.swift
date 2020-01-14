//
//  ChatListTableViewController+Delegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatListTableViewController: UITableViewDelegate {
    
    // MARK:- Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searching = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(identifier: "ChatLogTableViewController") as! ChatLogTableViewController
        if searching {
            let user = searchingThreads[indexPath.row].chatPartner
             destination.AppUser = user
             self.navigationController?.pushViewController(destination, animated: true)
             self.tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let user = orderedThreads[indexPath.row].chatPartner
            destination.AppUser = user
            self.navigationController?.pushViewController(destination, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
