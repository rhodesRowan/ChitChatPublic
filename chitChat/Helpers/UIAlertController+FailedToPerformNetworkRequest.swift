//
//  UIAlertController+FailedToPerformNetworkRequest.swift
//  chitChat
//
//  Created by Rowan Rhodes on 08/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // MARK:- Public
    static func failedToPerformNetworkRequest(errorMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "Oops...", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        return alert
    }
}
