//
//  ChatListPhotoCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

var ChatListPhotoCellID = "ChatListPhotoCellID"

class ChatListPhotoCell: ChatListBaseCell {
    
    
    //MARK:- Properties
    var message: PhotoMessage? {
        didSet {
            self.timeLbl.text = Date.convertDateToString(date: message!.date)
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
    
    //MARK:- Public
    
    override func prepareForReuse() {
        self.profileIconImg.image = UIImage(named: "user")
        self.messageLbl.text = ""
        self.profileNameLbl.text = ""
        self.timeLbl.text = ""
    }
    
    override func setupFromUser(chatPartner: user) {
        self.profileNameLbl.text = chatPartner.name.capitalized
        if self.message?.fromID == message?.chatPartner {
            self.messageLbl.text = "\(chatPartner.name.capitalized) sent an image"
        } else {
            self.messageLbl.text = "You sent an image"
        }
        guard let url = chatPartner.photoURL else { return }
        self.profileIconImg.loadImageUsingCacheWithURLString(urlString: url)
    }
}
