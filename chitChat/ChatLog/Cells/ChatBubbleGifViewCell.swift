//
//  ChatBubbleGifViewCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK

var ChatBubbleGifViewCellID = "ChatBubbleGifViewCellID"

class ChatBubbleGifViewCell: ChatBubbleBaseCell {

    // MARK:- Properties
    var chatMessage: GifMessage! {
        didSet {
            textBubbleView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                trailingConstraint.isActive = true
                leadingConstraint.isActive = false
            }
            self.setupMessageImage(gifID: chatMessage.gifID)
        }
    }
    
    var gifImageView: GPHMediaView = {
       var imageView = GPHMediaView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(gifImageView)
        
        // add message image constraints
        gifImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        gifImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        gifImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gifImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        // set alignment for message
        self.leadingConstraint = gifImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        self.trailingConstraint = gifImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        // add bubble view constraints
        textBubbleView.topAnchor.constraint(equalTo: gifImageView.topAnchor, constant: -8).isActive = true
        textBubbleView.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 8).isActive = true
        textBubbleView.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor, constant: -8).isActive = true
        textBubbleView.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Public
    func setupMessageImage(gifID: String) {
        GiphyCore.shared.gifByID(gifID) { (response, error) in
            if let media = response?.data {
                DispatchQueue.main.sync { [weak self] in
                    guard let self = self else { return }
                    self.gifImageView.setMedia(media)
                }
            }
        }
    }
    
    
}
