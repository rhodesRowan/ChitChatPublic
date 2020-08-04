//
//  ChatLogTableViewController+TextField.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.sendButton.isEnabled = false
        } else {
            self.sendButton.isEnabled = true
        }
        return true
    }
}
