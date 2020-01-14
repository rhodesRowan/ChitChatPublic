//
//  ChatLogViewModel+TableDataSource.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogViewModel: UITableViewDataSource {
    
    // MARK:- TableView Datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].messages[indexPath.row]
        switch item.type {
        case .textMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: chatBubbleCellID, for: indexPath) as? ChatBubbleTextCell ?? ChatBubbleTextCell()
            cell.selectionStyle = .none
            cell.chatMessage = item as? TextMessage
            return cell
        case .imageMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: chatBubbleImageCellID, for: indexPath) as? chatBubbleImageCell ?? chatBubbleImageCell()
            cell.delegate = self
            cell.selectionStyle = .none
            cell.chatMessage = item as? PhotoMessage
            return cell
        case .videoMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: chatBubbleVideoCellID, for: indexPath) as? chatBubbleVideoCell ?? chatBubbleVideoCell()
            cell.selectionStyle = .none
            cell.delegate = self
            cell.chatMessage = item as? VideoMessage
            return cell
        case .gifMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleGifViewCellID, for: indexPath) as? ChatBubbleGifViewCell ?? ChatBubbleGifViewCell()
            cell.selectionStyle = .none
            cell.chatMessage = item as? GifMessage
            return cell
        }
    }
    
}
