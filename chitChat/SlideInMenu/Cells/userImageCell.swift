//
//  userImageCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 17/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var userImageCellID = "userImageCellID"
class userImageCell: UITableViewCell {

    // MARK:- Properties
    var profileImageView: UIImageView = {
       var imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.layer.masksToBounds = true
       imageView.layer.cornerRadius = 40
       imageView.contentMode = .scaleAspectFill
       return imageView
    }()
    
    var nameLabel: UILabel = {
       var label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
       label.sizeToFit()
       label.textColor = ThemeManager.shared.titleColor
       return label
    }()
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        backgroundColor = .clear
        // profile image constraints
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // name label constraints
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
