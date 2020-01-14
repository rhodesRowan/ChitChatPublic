//
//  ChatLogTableViewContainer+MediaContainer.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogTableViewController {
    
    // MARK:- @IBActions
    
    @IBAction func pressMediaBtn(_ sender: Any) {
        self.showMediaBtnsContainer()
    }
    
    @IBAction func closeMediaPressed(_ sender: Any) {
        self.showMediaBtnsContainer()
    }
    
    // MARK:- Private
    // animate the media container over the user input bar or back depending on whether it is currently visible or not
    fileprivate func showMediaBtnsContainer() {
        if mediaContainerShowing {
            self.mediaContainerShowing = false
            self.mediaContainerWidthConstraint.constant = 0
        } else {
            self.mediaContainerShowing = true
            self.mediaContainerWidthConstraint.constant = self.view.frame.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            print("media out")
        }
    }
    
}
