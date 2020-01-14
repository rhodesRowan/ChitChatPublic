//
//  ChatBubbleCollectionViewCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var chatBubbleCellID = "chatBubbleCellID"

class ChatBubbleTextCell: ChatBubbleBaseCell {

    //MARK:- Properties
    var chatMessage: TextMessage! {
        didSet {
            textBubbleView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            textMessageLbl.textColor = chatMessage.isIncoming ? .black : .white
            textMessageLbl.text = chatMessage.text
            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                trailingConstraint.isActive = true
                leadingConstraint.isActive = false
            }
        }
    }
    
    var textMessageLbl: UILabel = {
        var textMessageLbl = UILabel()
        textMessageLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textMessageLbl.textColor = ThemeManager.shared.titleColor
        textMessageLbl.backgroundColor = .clear
        textMessageLbl.translatesAutoresizingMaskIntoConstraints = false
        textMessageLbl.numberOfLines = 0
        return textMessageLbl
    }()
    
    
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "chatLogBackGroundColor")
        
        // add subviews to cell
        self.addSubview(textMessageLbl)
    
        // add text message constraints
        textMessageLbl.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        textMessageLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        textMessageLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        // set alignment for message
        self.leadingConstraint = textMessageLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        self.trailingConstraint = textMessageLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        
        // add bubble view constraints
        textBubbleView.topAnchor.constraint(equalTo: textMessageLbl.topAnchor, constant: -16).isActive = true
        textBubbleView.bottomAnchor.constraint(equalTo: textMessageLbl.bottomAnchor, constant: 16).isActive = true
        textBubbleView.leadingAnchor.constraint(equalTo: textMessageLbl.leadingAnchor, constant: -16).isActive = true
        textBubbleView.trailingAnchor.constraint(equalTo: textMessageLbl.trailingAnchor, constant: 16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Public
    override func prepareForReuse() {
        self.textMessageLbl.text = nil
    }

}
