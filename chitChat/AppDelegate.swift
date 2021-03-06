//
//  AppDelegate.swift
//  chitChat
//
//  Created by Rowan Rhodes on 03/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // MARK:- Public
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        UNUserNotificationCenter.current().delegate = self
        self.configureUserNotificationCenter()
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID(handler: { (result, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                print(result?.token)
                UserDetailsManager.sharedInstance.setDeviceToken(token: result!.token)
            }
        })
    }
    
    func configureUserNotificationCenter() {
        let inputAction = UNTextInputNotificationAction(identifier: "REPLY_TO_MESSAGE", title: "Reply", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Message...")
        let privateMessageCategory = UNNotificationCategory(identifier: "private_message", actions: [inputAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([privateMessageCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "REPLY_TO_MESSAGE":
            if let textResponse = response as? UNTextInputNotificationResponse {
                UIApplication.shared.applicationIconBadgeNumber = 0
                let senderID = response.notification.request.content.userInfo["senderID"] as! String
                let payload: [String: Any] = ["toID": senderID, "fromID": AuthManager.sharedInstance.getCurrentUser()?.uid, "text": textResponse.userText, "timestamp": Int(Date().timeIntervalSince1970)]
                MessageManager.sharedInstance.sendMessage(payload: payload) { (success) in
                    if success {
                        print("successfully sent message")
                    } else {
                        print("there was an error sending the message")
                    }
                }
            }
        default:
            break
        }
    }
    
}

