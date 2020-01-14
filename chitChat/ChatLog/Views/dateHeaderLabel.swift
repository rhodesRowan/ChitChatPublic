//
//  dateHeaderLabel.swift
//  chitChat
//
//  Created by Rowan Rhodes on 10/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class dateHeaderLabel: UILabel {

    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.backgroundColor = ThemeManager.shared.titleColor.withAlphaComponent(0.8)
        self.textColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Public
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + CGFloat(12)
        layer.cornerRadius = height / 2
        return CGSize(width: originalContentSize.width + CGFloat(16), height: height)
    }
    
    
}
