//
//  ChatLogTableViewController+ChatLogViewModelDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogTableViewController: ChatLogViewModelDelegate {
    
    // MARK:- ChatLogViewModel Delegate methods
    func cellSelected() {
        self.userInputTextField.endEditing(true)
    }
    
    // apply the changes to the table based upon what type of change occured
    func apply(changes: SectionChanges, applyType: updateType) {
        switch applyType {
        case .initialLoad:
            self.performInitialLoadUpdateOnTable(changes)
        case .pagination:
            self.performPaginationLoadUpdateOnTable(changes)
        case .newMessage:
            self.performNewMessageUpdateOnTable(changes)
        }
    }
    
    // MARK:- Public
    public func scrollToBottom() {
        guard self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: self.tableView.numberOfSections - 1) > 0 else { return }
        let sections = self.tableView.numberOfSections - 1
        let rows = self.tableView.numberOfRows(inSection: sections) - 1
        self.tableView.scrollToRow(at: IndexPath(row: rows, section: sections), at: .bottom, animated: true)
    }
    
    // MARK:- Private
    // insert the cells and sections and offset the content to the bottom
    fileprivate func performInitialLoadUpdateOnTable(_ changes: SectionChanges) {
        self.tableView.performBatchUpdates({
            self.tableView?.deleteSections(changes.deletes, with: .none)
            self.tableView?.insertSections(changes.inserts, with: .none)
            self.tableView?.reloadRows(at: changes.updates.reloads, with: .none)
            self.tableView?.insertRows(at: changes.updates.inserts, with: .none)
            self.tableView?.deleteRows(at: changes.updates.deletes, with: .none)
        }) { [weak self] (success) in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.scrollToBottom()
                    self.containerView.isHidden = true
                    self.setLastMessageRead()
                }
            }
            self.viewModel.isInitialLoad = false
        }
    }
    
    // reload the table and offset the content to the user's previously scrolled position
    fileprivate func performPaginationLoadUpdateOnTable(_ changes: SectionChanges) {
        self.tableView.reloadData()
        let rect = self.tableView.rectForRow(at: IndexPath(row: changes.updates.inserts.count, section: changes.inserts.count))
        self.tableView.setContentOffset(CGPoint(x: 0, y: rect.minY), animated: false)
        self.setLastMessageRead()
    }
    
    // insert the new cells and scroll the user to the bottom
    fileprivate func performNewMessageUpdateOnTable(_ changes: SectionChanges) {
        self.tableView.performBatchUpdates({
            self.tableView?.deleteSections(changes.deletes, with: .none)
            self.tableView?.insertSections(changes.inserts, with: .none)
            self.tableView?.reloadRows(at: changes.updates.reloads, with: .none)
            self.tableView?.insertRows(at: changes.updates.inserts, with: .none)
            self.tableView?.deleteRows(at: changes.updates.deletes, with: .none)
        }) { (success) in
            if success {
                self.scrollToBottom()
                self.setLastMessageRead()
            }
        }
    }
    
    fileprivate func setLastMessageRead() {
        guard let lastIndex = self.getLastRow() else { return }
        let fromID = self.viewModel.items[lastIndex.section].messages[lastIndex.row].fromID
        MessageManager.sharedInstance.setLastMessageRead(chatPartnerID: self.AppUser!.id, lastMessageSender: fromID)
    }
    
    fileprivate func getLastRow() -> IndexPath? {
        guard self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: self.tableView.numberOfSections - 1) > 0 else { return nil }
        let sections = self.tableView.numberOfSections - 1
        let rows = self.tableView.numberOfRows(inSection: sections) - 1
        return IndexPath(row: rows, section: sections)
    }
    
    // returns the value that represents the bottom of the table view.
    fileprivate func bottomOfTableViewYPosition() -> CGFloat {
        let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height)
        return scrollPoint.y
    }
}
