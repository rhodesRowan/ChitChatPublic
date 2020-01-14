//
//  ChatListTableViewController+SearchController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatListTableViewController: UISearchBarDelegate {
    
    // MARK:- Search Bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.searchingThreads = []
            self.tableView.reloadData()
            self.searching = false
            self.tableView.reloadData()
        } else {
            self.searchingThreads = self.orderedThreads.filter({ (thread) -> Bool in
                guard let text = searchBar.text else { return false }
                return thread.chatPartner.name.lowercased().prefix(text.count).contains(text.lowercased())
            })
            self.searching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchingThreads = []
        self.tableView.reloadData()
        self.searching = false
    }
    
}
