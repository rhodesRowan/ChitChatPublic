//
//  settingsVC+TextFieldDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension settingsVC: UITextFieldDelegate {
    
    //MARK:- TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.saveBtn.isEnabled = false
            self.saveBtn.alpha = 0.5
        } else {
            self.saveBtn.isEnabled = true
            self.saveBtn.alpha = 1.0
        }
        return true
    }
    
}
