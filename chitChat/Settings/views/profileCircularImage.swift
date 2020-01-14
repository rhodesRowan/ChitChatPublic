//
//  profileCircularImage.swift
//  chitChat
//
//  Created by Rowan Rhodes on 18/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class profileCircularImage: UIImageView {

    //MARK:- Public
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.width / 2
    }

}
