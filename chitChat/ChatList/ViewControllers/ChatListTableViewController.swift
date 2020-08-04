//
//  ChatListTableViewController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import UserNotifications


protocol SlideTransitionDelegate: AnyObject {
    func dismiss()
}

class ChatListTableViewController: UIViewController {
    
    // MARK:- @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK:- Properties
    let transition = SlideInTransition()
    var searchingThreads = [Thread]()
    weak var delegate: SlideTransitionDelegate?
    var newMessageObserver: DatabaseReference?
    var changedMessageObserver: DatabaseReference?
    var initialMessageObserverReference: DatabaseReference?
    var emptyView: EmptyListView!
    
    // computed Properties
    var orderedThreads = [Thread]() {
        didSet {
            self.orderedThreads.forEach({$0.delegate = self})
            self.checkForUpdates(oldValue: oldValue, newValue: self.orderedThreads)
            if self.orderedThreads.count == 0 {
                self.addEmptyListContainer()
            } else {
                guard emptyView != nil else { return self.view.bringSubviewToFront(self.tableView) }
                self.emptyView.removeFromSuperview()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    var searching = false {
        didSet {
            if self.searching == false {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    // key of the threads dictionary is equal to the chat partners id, and the value is the last message that they sent
    var threadsDict = [String: Thread]() {
        didSet {
            let array = Array(self.threadsDict.values).sorted { (thread1, thread2) -> Bool in
                return thread1.lastMessage.date > thread2.lastMessage.date
            }
            self.orderedThreads = array
        }
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.loadThreads()
        self.setupSettingsButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           self.searching = false
    }
       
    override func viewDidAppear(_ animated: Bool) {
       self.searching = false
    }
    
    // MARK:- Deinit
    deinit {
        print("DEINIT CHATLIST")
    }
    
    // MARK:- @IBActions
    // ellipsis button was pressed by the user, this functions slides in the menu
    @IBAction func slideMenuPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(identifier: "MenuTableViewController")
        destination.modalPresentationStyle = .overCurrentContext
        destination.transitioningDelegate = self
        self.delegate = destination as? SlideTransitionDelegate
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tap.numberOfTapsRequired = 1
        transition.dimmingView.addGestureRecognizer(tap)
        self.present(destination, animated: true, completion: nil)
    }
    
    // compose new message button was pressed by the user
    @IBAction func showNewChatController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(identifier: "searchTableVC") as! searchTableVC
        destination.modalPresentationStyle = .automatic
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK:- Public
    @objc func dismissMenu() {
        delegate?.dismiss()
    }
    
    // loads in the initial threads into the threads dictionary using a single event observer
    public func loadThreads() {
        self.initialMessageObserverReference = ConversationObserverManager.sharedInstance.observeInitialUserMessages { [weak self] (threads) in
            guard let self = self else { return }
            self.threadsDict = threads
            let lastDate = self.orderedThreads.last?.lastMessage.date ?? Date()
            self.newThreadAddedObserver(lastDate: lastDate)
        }
    }
    
    public func checkForUpdates(oldValue: [Thread], newValue: [Thread]) {
        var inserts = [IndexPath]()
        var removals = [IndexPath]()
        var reloads = [IndexPath]()
        let difference = newValue.difference(from: oldValue) { (element, thread) -> Bool in
            element.chatPartner.id == thread.chatPartner.id
        }
        for (index, element) in newValue.enumerated() {
            if oldValue.indices.contains(index) {
                if oldValue[index].chatPartner.id == element.chatPartner.id {
                    if oldValue[index].lastMessage.messageID != element.lastMessage.messageID || oldValue[index].showUnread != element.showUnread {
                        reloads.append(IndexPath(row: index, section: 0))
                    }
                }
            }
        }
        for change in difference {
            switch change {
            case let .insert(offset: offset, element: _, associatedWith: _):
                inserts.append(IndexPath(row: offset, section: 0))
            case let .remove(offset: offset, element: _, associatedWith: _):
                removals.append(IndexPath(row: offset, section: 0))
            }
        }
        self.apply(inserts, removals: removals, reloads: reloads)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK:- Private
    // check to make sure a user exists, if they dont, present the login screen
    fileprivate func checkForAuth() {
        AuthManager.sharedInstance.checkForCurrentUser { [weak self] (userExists) in
            guard let self = self else { return }
            if !userExists {
                let login = LoginViewController()
                login.modalPresentationStyle = .fullScreen
                self.present(login, animated: true, completion: nil)
            } else {
                return
            }
        }
    }
    
    // add the empty listcontainer if there are currently no threads
    fileprivate func addEmptyListContainer() {
        self.emptyView = EmptyListView()
        self.emptyView.center = self.view.center
        self.view.addSubview(emptyView)
    }
    
    // adds a snapshot listener that only listens for new threads, if the message already exists, it is not added to the dictionary.
    fileprivate func newThreadAddedObserver(lastDate: Date) {
        self.newMessageObserver = ConversationObserverManager.sharedInstance.observeUserMessagesAdded(lastDate: lastDate) { [weak self] (thread) in
            guard let self = self else { return }
                guard let thread = thread else { return }
                self.threadsDict[thread.chatPartner.id] = thread
        }
    }
    
    fileprivate func setupSettingsButton() {
        self.menuButton.imageView?.contentMode = .scaleAspectFit
        self.menuButton.imageView?.tintColor = ThemeManager.shared.greenColor
        self.searchBar.searchTextField.backgroundColor = UIColor(named: "secondaryBackgroundColor")
        self.searchBar.searchTextField.textColor = ThemeManager.shared.titleColor
        self.searchBar.delegate = self
    }
    
    fileprivate func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ChatListTextCell.self, forCellReuseIdentifier: ChatListTextCellID)
        self.tableView.register(ChatListPhotoCell.self, forCellReuseIdentifier: ChatListPhotoCellID)
        self.tableView.register(ChatListGifCell.self, forCellReuseIdentifier: ChatListGifCellID)
        self.tableView.register(ChatListVideoCell.self, forCellReuseIdentifier: ChatListVideoCellID)
        self.tableView.separatorStyle = .none
    }
    
    
    fileprivate func apply(_ inserts: [IndexPath], removals: [IndexPath], reloads: [IndexPath]) {
        self.tableView.performBatchUpdates({
            self.tableView?.insertRows(at: inserts, with: .none)
            self.tableView?.deleteRows(at: removals, with: .none)
            self.tableView.reloadRows(at: reloads, with: .none)
        }) { (success) in
            if success {
                print("cells updated")
            }
        }
    }
    
}


