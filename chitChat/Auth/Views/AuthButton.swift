//
//  AuthBtn.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    // MARK:- Public
    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.systemGreen
        self.titleLabel?.textColor = .white
    }

}
