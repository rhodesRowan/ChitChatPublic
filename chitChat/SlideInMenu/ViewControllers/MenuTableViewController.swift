//
//  MenuTableViewController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 17/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, SlideTransitionDelegate {
    
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK:- Slide Transition Delegate Methods
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(identifier: "settingsVC")
            self.present(destination, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            self.togglePushNotifications()
        } else if indexPath.row == 3 {
            self.presentLogoutAlert()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        }
        return 70
    }
    
    // MARK:- TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let user = AuthManager.sharedInstance.getCurrentUser() {
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: userImageCellID, for: indexPath) as? userImageCell ?? userImageCell()
                if let photo = user.photoURL?.absoluteString {
                    cell.profileImg.loadImageUsingCacheWithURLString(urlString: photo)
                } else {
                    cell.profileImg.image = UIImage(named: "user")
                }
                cell.selectionStyle = .none
                cell.nameLbl.text = user.displayName?.capitalized
                return cell
            } else if indexPath.row == 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: slidingMenuID, for: indexPath) as? slidingMenuCell ?? slidingMenuCell()
                cell.actionLbl.text = "Account Settings"
                cell.actionIcon.image = UIImage(named: "settings")
                return cell
            } else if indexPath.row == 2 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: slidingMenuID, for: indexPath) as? slidingMenuCell ?? slidingMenuCell()
                cell.actionLbl.text = "Notifications"
                cell.actionIcon.image = UIImage(named: "bell")
                return cell
            } else  {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: slidingMenuID, for: indexPath) as? slidingMenuCell ?? slidingMenuCell()
                cell.actionLbl.text = "Log Out"
                cell.actionIcon.image = UIImage(named: "logOut")
                return cell
            }
        }
            return UITableViewCell()
    }
    
    // MARK:- Private
    fileprivate func presentLogoutAlert() {
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.logOutUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(signOutAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func logOutUser() {
        AuthManager.sharedInstance.signOutUser { (signedOut) in
            if signedOut {
                UIApplication.shared.unregisterForRemoteNotifications()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let login = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
                login.modalPresentationStyle = .fullScreen
                self.present(login, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func togglePushNotifications() {
        let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications
        var message: String!
        var action: UIAlertAction!
        if isRegistered {
            message = "Would you like to turn off push notifications?"
            action = UIAlertAction(title: "Turn Off", style: .destructive, handler: { (action) in
            })
        } else {
            message = "Would you like to turn on push notifications?"
            action = UIAlertAction(title: "Turn On", style: .default, handler: { [weak self] (action) in
                guard let self = self else { return }
                self.enablePushNotifications()
            })
        }
        let alert = UIAlertController(title: "Toggle Push Notifications", message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func enablePushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    fileprivate func configureTableView() {
        self.tableView.register(userImageCell.self, forCellReuseIdentifier: userImageCellID)
        self.tableView.register(slidingMenuCell.self, forCellReuseIdentifier: slidingMenuID)
    }
}
