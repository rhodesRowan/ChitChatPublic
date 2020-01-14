//
//  ChatBubbleBaseCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class ChatBubbleBaseCell: UITableViewCell {
    
    // MARK:- Properties
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var textBubbleView: UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.4
        return view
    }()
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(textBubbleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
