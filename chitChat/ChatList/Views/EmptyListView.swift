//
//  EmptyListView.swift
//  chitChat
//
//  Created by Rowan Rhodes on 08/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

class EmptyListView: UIView {

    // MARK:- Properties
    var noMessageImage: UIImageView = {
       var noMessageImage = UIImageView(image: UIImage(named: "sad-face"))
        noMessageImage.tintColor = UIColor.lightGray
        noMessageImage.translatesAutoresizingMaskIntoConstraints = false
        return noMessageImage
    }()
    
    var noMessageLabel: UILabel = {
        var noMessageLabel = UILabel()
        noMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        noMessageLabel.textColor = UIColor.secondaryLabel
        noMessageLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        noMessageLabel.text = "You currently \n have no messages"
        noMessageLabel.textAlignment = .center
        noMessageLabel.numberOfLines = 0
        return noMessageLabel
    }()
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private
    fileprivate func setupSubviews() {
        self.addSubview(noMessageImage)
        noMessageImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noMessageImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(noMessageLabel)
        noMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noMessageLabel.topAnchor.constraint(equalTo: noMessageImage.bottomAnchor, constant: 12).isActive = true
    }
    
}
