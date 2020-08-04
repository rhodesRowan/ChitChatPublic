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

    var profileIconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = ThemeManager.shared.greenColor.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        self.addSubview(profileIconImageView)
        self.addSubview(nameLbl)
        
        // add profile image constraints
        profileIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileIconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileIconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        // add nameLbl constraints
        nameLbl.leadingAnchor.constraint(equalTo: profileIconImageView.trailingAnchor, constant: 8).isActive = true
        nameLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        nameLbl.centerYAnchor.constraint(equalTo: profileIconImageView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
