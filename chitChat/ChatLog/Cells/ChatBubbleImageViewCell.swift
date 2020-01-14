//
//  ChatBubbleImageViewCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var chatBubbleImageCellID = "chatBubbleImageCellID"

class chatBubbleImageCell: ChatBubbleBaseCell {

    // MARK:- Properties
    weak var delegate: ChatBubbleMediaProtocol?
    var chatMessage: PhotoMessage! {
        didSet {
            textBubbleView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                trailingConstraint.isActive = true
                leadingConstraint.isActive = false
            }
            self.setupMessageImage(photoURL: chatMessage.imageURL)
        }
    }
    
    

    lazy var messageImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageWasTapped))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(messageImageView)
        
        // add message image constraints
        messageImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        messageImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // set alignment for message
        self.leadingConstraint = messageImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        self.trailingConstraint = messageImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        // add bubble view constraints
        textBubbleView.topAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -8).isActive = true
        textBubbleView.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8).isActive = true
        textBubbleView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor, constant: -8).isActive = true
        textBubbleView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Public
    func setupMessageImage(photoURL: String) {
        self.messageImageView.loadImageUsingCacheWithURLString(urlString: photoURL)
    }
    
    override func prepareForReuse() {
        self.messageImageView.image = nil
    }
    
    @objc func imageWasTapped() {
        let aspect = Double((self.messageImageView.image?.size.width)!) / Double((self.messageImageView.image?.size.height)!)
        delegate?.imageViewWasTapped(imageView: self.messageImageView, aspectRatio: aspect)
    }

}
