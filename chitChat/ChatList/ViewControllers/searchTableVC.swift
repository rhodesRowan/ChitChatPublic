//
//  searchTableVC.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Alamofire

class searchTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var usersArray: [user] = []
    var isSearching: Bool = false
    var searchingArray: [user] = []
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureSearchBar()
        self.loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK:- Deinit
    deinit {
        print("DEINIT SEARCH VC")
    }
    
    func configureTableView() {
        self.title = "New Message"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(searchCell.self, forCellReuseIdentifier: searchCellID)
        self.tableView.separatorStyle = .none
    }
    
    func configureSearchBar() {
        self.searchBar.searchTextField.backgroundColor = UIColor(named: "secondaryBackgroundColor")
        self.searchBar.searchTextField.textColor = UIColor.label
        self.searchBar.delegate = self
    }
    
    func loadUsers() {
        UserQueryManager.sharedInstance.fetchUsersForSearching { [weak self] (usersArray) -> (Void) in
            self?.usersArray = usersArray
            self?.tableView.reloadData()
        }
    }

    // MARK: - TableView Datasource Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearching {
            return self.searchingArray.count
        } else {
            return self.usersArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellID, for: indexPath) as? searchCell ?? searchCell()
        let item: user!
        if isSearching {
            item = searchingArray[indexPath.row]
        } else {
            item = usersArray[indexPath.row]
        }
        if let photoURL = item.photoURL {
            cell.profileIconImg.loadImageUsingCacheWithURLString(urlString: photoURL)
        } else {
            cell.profileIconImg.image = UIImage(named: "user")
        }
        
        cell.nameLbl.text = item.name.capitalized
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(identifier: "ChatLogTableViewController") as! ChatLogTableViewController
        if isSearching {
            destination.AppUser = searchingArray[indexPath.row]
        } else {
            destination.AppUser = usersArray[indexPath.row]
        }
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}
