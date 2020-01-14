//
//  ChatListTextCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var ChatListTextCellID = "ChatListTextCell"

class ChatListTextCell: ChatListBaseCell {
    
    
    //MARK:- Properties
    var message: TextMessage? {
        didSet {
            self.timeLbl.text = Date.convertDateToString(date: message!.date)
            self.messageLbl.text = "\(message!.text)"
            self.setupFromUser(chatPartner: user!)
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Methods
    
    override func prepareForReuse() {
        self.profileIconImg.image = UIImage(named: "user")
        self.messageLbl.text = ""
        self.profileNameLbl.text = ""
        self.timeLbl.text = ""
    }
    
    override func setupFromUser(chatPartner: user) {
        self.profileNameLbl.text = chatPartner.name.capitalized
        guard let url = chatPartner.photoURL else { return }
        self.profileIconImg.loadImageUsingCacheWithURLString(urlString: url)
    }
    
}
