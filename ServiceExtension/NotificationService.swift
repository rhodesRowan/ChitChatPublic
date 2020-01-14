//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Rowan Rhodes on 30/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    // MARK:- Properties
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    // MARK:- Public
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            bestAttemptContent.body = "\(bestAttemptContent.body)"
            bestAttemptContent.categoryIdentifier = "private_message"
            bestAttemptContent.badge = 0
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
