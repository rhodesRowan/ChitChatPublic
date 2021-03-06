//
//  ChatLogCollectionViewController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Firebase
import GiphyUISDK
import GiphyCoreSDK
import AVFoundation
import MobileCoreServices

class ChatLogTableViewController: UIViewController, UITableViewDelegate {
    
    // MARK:- @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var mediaContainerWidthConstraint: NSLayoutConstraint!
    
    // MARK:- Properties
    var mediaContainerShowing = false
    var containerView = LoadingContainerView()
    var sendButton = UIButton()
    var viewModel = ChatLogViewModel()
    let giphy = GiphyViewController()
    var sendSoundEffect: AVAudioPlayer?
    var lastOnlineTime: String?
    var AppUser: user? {
        didSet {
            UserQueryManager.sharedInstance.getLastLoggedIn(AppUser!.id) { (lastOnline) in
                self.lastOnlineTime = lastOnline
            }
        }
    }
    
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        self.view.backgroundColor = ThemeManager.shared.bgColor
        self.configureTableView()
        self.setupUserInputBar()
        self.setupNavBar()
        self.setupContainerView()
        GiphyUISDK.configure(apiKey: "fill api token here ....")
        giphy.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.observeInitialMessages(User: AppUser!)
    }
    
    deinit {
        self.viewModel.removeObserverForChatLog()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("CHATLOG VC DEINIT")
    }
    
    // MARK:- Private
    fileprivate func setupContainerView() {
        containerView.isHidden = false
        containerView.frame = self.view.frame
        containerView.backgroundColor = ThemeManager.shared.bgColor
        containerView.fillColor = ThemeManager.shared.bgColor.cgColor
        self.view.insertSubview(containerView, aboveSubview: self.tableView)
    }
    
    fileprivate func setupNavBar() {
        let width = self.view.frame.width
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        
        // set up profileImage
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = ThemeManager.shared.greenColor.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        if let photo = AppUser!.photoURL {
            profileImageView.loadImageUsingCacheWithURLString(urlString: (photo))
        } else {
            profileImageView.image = UIImage(named: "user")
        }
        
        titleView.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 5).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        // set up name
        let nameLabel = UILabel()
        nameLabel.text = AppUser?.name.capitalized
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.sizeToFit()
        titleView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        
        
        // set up lastOnline
        let lastOnline = UILabel()
        lastOnline.text = lastOnlineTime ?? "Online"
        lastOnline.textColor = .lightGray
        lastOnline.sizeToFit()
        lastOnline.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lastOnline.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(lastOnline)
        lastOnline.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        lastOnline.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc fileprivate func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupUserInputBar() {
        self.userInputTextField.delegate = self
        self.userInputTextField.layer.masksToBounds = true
        self.userInputTextField.layer.cornerRadius = 8
        self.userInputTextField.layer.borderWidth = 1
        self.userInputTextField.layer.borderColor = UIColor.tertiarySystemBackground.resolvedColor(with: self.traitCollection).cgColor
        self.userInputTextField.backgroundColor = ThemeManager.shared.secondaryBGColor
        // create send button
        self.sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.sendButton.setImage(UIImage(named: "send"), for: .normal)
        self.sendButton.imageView?.contentMode = .scaleAspectFit
        self.sendButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        self.userInputTextField.rightView = sendButton
        self.userInputTextField.rightViewMode = .always
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        self.sendButton.isEnabled = false
        // setup media button
        self.mediaButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @objc fileprivate func handleKeyboardNotification(notification: NSNotification) {
        let bottomSafeArea = self.view.safeAreaInsets.bottom - 5
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            // is the keyboard showing or hiding
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            self.bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame.size.height + bottomSafeArea  : 0

            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }, completion: nil)
        }
    }
    
    fileprivate func registerCells() {
        self.tableView.register(ChatBubbleTextCell.self, forCellReuseIdentifier: chatBubbleCellID)
        self.tableView.register(chatBubbleImageCell.self, forCellReuseIdentifier: chatBubbleImageCellID)
        self.tableView.register(ChatBubbleGifViewCell.self, forCellReuseIdentifier: ChatBubbleGifViewCellID)
        self.tableView.register(chatBubbleVideoCell.self, forCellReuseIdentifier: chatBubbleVideoCellID)
    }

    fileprivate func configureTableView() {
        self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
        self.registerCells()
        self.viewModel.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.backgroundColor = UIColor(named: "chatLogBackGroundColor")
        self.viewModel.observeNewMesages(User: AppUser!)
        self.viewModel.setupRefreshControl(tableView: self.tableView)
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(tableViewTapped))
        self.tableView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tableViewTapped() {
        if self.userInputTextField.isEditing {
            self.userInputTextField.endEditing(true)
        }
    }
    
}





