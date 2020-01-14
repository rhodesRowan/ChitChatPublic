//
//  UIViewController+Extensions.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK:- Public
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc public func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc public func keyboardWillShow(notification: NSNotification) {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 200
        }
    }

    @objc public func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    public func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

}
