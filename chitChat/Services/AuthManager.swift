//
//  FirebaseManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    // MARK:- Properties
    private let firestoreRef = Firestore.firestore()
    static let sharedInstance: AuthManager = AuthManager()
    
    // MARK:- Public
    
    /// Attempts to login the user to firebase using their email and password credentials
    /// - Parameters:
    ///   - email: email address given by the user
    ///   - password: password given by the user
    ///   - completion: a bolean value indicating whether the login attempt was successful or not, if the login failed an error message was also be available in the completion with the reason why the login attempt falied
    public func Login(email: String, password: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    
    /// Attempts to register the user using the email address and password
    /// - Parameters:
    ///   - email: email address given by the user
    ///   - password: password given by the user
    ///   - name: name given by the user
    ///   - completion: bolean value indicating whether the registration attempt was successful, if registration failed, an error message will also be available explaining why the attempt failed
    public func Register(email: String, password: String, name: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                UserDetailsManager.sharedInstance.setDisplayName(user: user!.user, name: name.lowercased()) { (success) in
                    if success {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    
    /// signs the user out of firebase
    /// - Parameter completion: a bolean value indicating whether or not the sign out attempt was successful or not
    public func signOutUser(completion: @escaping (_ success: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch  {
            print(error)
            completion(false)
        }
    }
    
    
    /// checks if there is a user currently signed in to firebase
    /// - Parameter completion: a bolean value indicating whether there is a currently signed in user or not
    public func checkForCurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    
    /// returns the currently signed in user if there is one
    /// - returns: a user if there is one, else nil
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    
    /// Sets the current user to be online on the database, or disconnects on exiting the app
    public func setInactivityObservers() {
        guard let user = getCurrentUser() else { return }
        let userOnlineRef = Database.database().reference().child("userOnlineStatuses").child(user.uid).child("isOnline")
        userOnlineRef.setValue(true)
        userOnlineRef.onDisconnectSetValue(ServerValue.timestamp())
    }
    
    
    /// presents the chat list controller and loads the threads of the current User, then requests authorization for remote notifications
    /// - Parameter ViewController: the view controller that called the function
    public func transitionToConversations(_ ViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationNav = storyboard.instantiateViewController(identifier: "chatNavigationController") as? UINavigationController, let destinationVC = storyboard.instantiateViewController(identifier: "ChatListTableViewController") as? ChatListTableViewController else { return }
        destinationNav.viewControllers = [destinationVC]
        destinationNav.navigationBar.prefersLargeTitles = true
        destinationNav.modalPresentationStyle = .fullScreen
        destinationVC.loadThreads()
        ViewController.present(destinationNav, animated: true, completion: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

}

