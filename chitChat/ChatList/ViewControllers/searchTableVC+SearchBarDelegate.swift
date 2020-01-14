//
//  searchTableVC+SearchBarDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 08/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension searchTableVC: UISearchBarDelegate {
    
    // MARK:- SearchBar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.searchingArray = []
            self.tableView.reloadData()
            self.isSearching = false 
            self.tableView.reloadData()
        } else {
            guard let text = searchBar.text else { return }
            self.searchForUsers(searchText: text)
            self.isSearching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchingArray = []
        self.tableView.reloadData()
        self.isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchingArray = []
        self.tableView.reloadData()
        self.isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    // MARK:- Private
    
    fileprivate func searchForUsers(searchText: String) {
        UserQueryManager.sharedInstance.fetchUsersForSearchingByName(searchText: searchText.lowercased()) { (users) -> (Void) in
            guard users.count > 0 else { return self.searchingArray = [] }
            for user in users {
                let contains = self.searchingArray.first(where: {$0.id == user.id})
                if contains == nil {
                    self.searchingArray.append(user)
                }
            }
            self.tableView.reloadData()
        }
    }
}
