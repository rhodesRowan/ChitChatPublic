//
//  slidingMenuBtn.swift
//  chitChat
//
//  Created by Rowan Rhodes on 17/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

var slidingMenuID = "slidingMenuID"

class slidingMenuCell: UITableViewCell {

    //MARK:- Properties
    var actionLbl: UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ThemeManager.shared.titleColor
        return label
    }()
    
    var actionIcon: UIImageView = {
        var icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(actionLbl)
        self.addSubview(actionIcon)
        
        backgroundColor = .clear
        // action icons constraints
        actionIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        actionIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        actionIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // action label constraints
        actionLbl.leadingAnchor.constraint(equalTo: actionIcon.trailingAnchor, constant: 8).isActive = true
        actionLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
