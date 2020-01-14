//
//  ChatLogViewModel+TableDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogViewModel: UITableViewDelegate {
    
    // MARK:- TableView delegate Methods
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.cellSelected()
    }
       
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       // add a label with the date
       let label = dateHeaderLabel()
       label.text = items[section].sectionTitle

       let containerView = UIView()
       containerView.backgroundColor = .clear
       containerView.addSubview(label)
       label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
       label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
       return containerView
   }
}
