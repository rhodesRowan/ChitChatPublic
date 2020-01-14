//
//  Controls.swift
//  chitChat
//
//  Created by Rowan Rhodes on 04/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

@IBDesignable
public class AuthTxtField: UITextField {
    
   // MARK:- Properties
    @IBInspectable public var accessoryImage: UIImage = UIImage() {
        didSet {
            let imageView = UIImageView(image: accessoryImage)
            imageView.tintColor = UIColor.label
            imageView.contentMode = .scaleAspectFit
            self.leftView = imageView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable public var placeHolderColor: UIColor = .black {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    // MARK:- Public
    override public func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.4)
        self.textColor = UIColor.label
        self.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.inputAccessoryView?.backgroundColor = .white
    }
    
}
