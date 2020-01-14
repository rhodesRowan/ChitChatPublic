//
//  StatusBar+Style.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension UIStatusBarStyle {

    //MARK:- Properties
    static var darkContentWorkaround: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

}
