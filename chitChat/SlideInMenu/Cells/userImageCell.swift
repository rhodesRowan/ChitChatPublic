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
    var profileImg: UIImageView = {
       var imgView = UIImageView()
       imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 40
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    var nameLbl: UILabel = {
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
        self.addSubview(profileImg)
        self.addSubview(nameLbl)
        backgroundColor = .clear
        // profile image constraints
        profileImg.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImg.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImg.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // name label constraints
        nameLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLbl.topAnchor.constraint(equalTo: profileImg.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
