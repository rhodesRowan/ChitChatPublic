//
//  profileCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var searchCellID = "searchCellID"

class searchCell: UITableViewCell {
    
    //MARK:- Properties

    var profileIconImg: UIImageView = {
       var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        image.layer.borderColor = ThemeManager.shared.greenColor.cgColor
        image.layer.borderWidth = 1.0
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var nameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = ThemeManager.shared.titleColor
        return label
    }()
    
    //MARK:- Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(profileIconImg)
        self.addSubview(nameLbl)
        
        // add profile image constraints
        profileIconImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileIconImg.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileIconImg.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileIconImg.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        // add nameLbl constraints
        nameLbl.leadingAnchor.constraint(equalTo: profileIconImg.trailingAnchor, constant: 8).isActive = true
        nameLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        nameLbl.centerYAnchor.constraint(equalTo: profileIconImg.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
