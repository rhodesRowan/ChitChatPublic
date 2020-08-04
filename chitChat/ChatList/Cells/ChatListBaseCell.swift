
//
//  ChatListCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Alamofire

var ChatListCellID = "ChatListCell"

class ChatListBaseCell: UITableViewCell {
    
    // MARK:- Properties
    var user: user?
    var profileIconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = ThemeManager.shared.greenColor.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var showUnread: Bool? {
        didSet {
            if self.showUnread == true {
                self.messageLbl.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                self.messageLbl.textColor = ThemeManager.shared.titleColor
                self.unreadMessage.isHidden = false
            } else {
                self.messageLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
                self.messageLbl.textColor = ThemeManager.shared.subTitleColor
                self.unreadMessage.isHidden = true
            }
        }
    }
    
    var unreadMessage: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7.5
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGreen
        return view
    }()
    
    var profileNameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor =  ThemeManager.shared.titleColor
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.text = ""
        return label
    }()
    
    var timeLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = ThemeManager.shared.subTitleColor
        label.sizeToFit()
        label.textAlignment = .right
        label.text = ""
        label.layer.masksToBounds = true
        return label
    }()
    
    var messageLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = ThemeManager.shared.subTitleColor
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileIconImageView)
        self.addSubview(profileNameLbl)
        self.addSubview(timeLbl)
        self.addSubview(messageLbl)
        self.addSubview(unreadMessage)
        backgroundColor = .clear
        
        // profile img constraints
        profileIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        profileIconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileIconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // time lbl
        timeLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        timeLbl.topAnchor.constraint(equalTo: profileIconImageView.topAnchor, constant: 6).isActive = true
        
        
        // profile name constraints
        profileNameLbl.topAnchor.constraint(equalTo: profileIconImageView.topAnchor, constant: 3).isActive = true
        profileNameLbl.leadingAnchor.constraint(equalTo: profileIconImageView.trailingAnchor, constant: 5).isActive = true
        profileNameLbl.trailingAnchor.constraint(equalTo: timeLbl.leadingAnchor, constant: 5).isActive = true
        
        // unread counter
        unreadMessage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        unreadMessage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        unreadMessage.topAnchor.constraint(equalTo: timeLbl.bottomAnchor, constant: 5).isActive = true
        unreadMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        // message label constraints
        messageLbl.topAnchor.constraint(equalTo: profileNameLbl.bottomAnchor, constant: 3).isActive = true
        messageLbl.leadingAnchor.constraint(equalTo: profileNameLbl.leadingAnchor).isActive = true
        messageLbl.trailingAnchor.constraint(equalTo: unreadMessage.leadingAnchor, constant: -5).isActive = true
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.profileIconImageView.image = UIImage(named: "user")
        self.messageLbl.text = ""
        self.messageLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        self.messageLbl.textColor = ThemeManager.shared.subTitleColor
        self.profileNameLbl.text = ""
        self.timeLbl.text = ""
        self.unreadMessage.isHidden = true
    }
    
    // MARK: Public
     func setupFromUser(chatPartner: user) {
        self.profileNameLbl.text = chatPartner.name.capitalized
        guard let url = chatPartner.photoURL else { return }
        self.profileIconImageView.loadImageUsingCacheWithURLString(urlString: url)
    }
}
