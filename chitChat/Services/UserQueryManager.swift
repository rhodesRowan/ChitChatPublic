//
//  FirebaseQueryUsersManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class UserQueryManager {
    
    // MARK:- Properties
    private let firestoreRef = Firestore.firestore()
    private let databaseRef = Database.database().reference()
    static let sharedInstance: UserQueryManager = UserQueryManager()
    
    
    //MARK:- Public
    
    /// gets a list of users, limited to 5 for demonstration purposes of searching for users
    /// - Parameter completion: an array of users
    public func fetchUsersForSearching(completion: @escaping (_ userArray: [user]) -> (Void)) {
        var usersArray: [user] = []
        firestoreRef.collection("users").order(by: "name", descending: true).limit(to: 5).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(usersArray)
            } else {
                for document in snapshot!.documents {
                    if document.documentID == Auth.auth().currentUser?.uid {
                    } else {
                        let userDict = document.data()
                        guard let email = userDict["email"] as? String, let name = userDict["name"] as? String else { return }
                        if let photoURL = userDict["photoURL"] as? String {
                            let Appuser = user(id: document.documentID, name: name, email: email, photoURL: photoURL)
                            usersArray.append(Appuser)
                        } else {
                            let Appuser = user(id: document.documentID, name: name, email: email)
                            usersArray.append(Appuser)
                        }
                    }
                }
                completion(usersArray)
            }
        }
    }
    
    
    /// searches for users in the firebase database whose name contains text that is being searched
    /// - Parameters:
    ///   - searchText: the string to match against users names
    ///   - completion: an array of users whose names contains the search text
    public func fetchUsersForSearchingByName(searchText: String, completion: @escaping (_ userArray: [user]) -> (Void)) {
        var usersArray: [user] = []
        firestoreRef.collection("users").whereField("name", isGreaterThan: searchText).whereField("name", isLessThan: searchText + "z").getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(usersArray)
            } else {
                for document in snapshot!.documents {
                    if document.documentID != AuthManager.sharedInstance.getCurrentUser()?.uid {
                        let userDict = document.data()
                        guard let email = userDict["email"] as? String, let name = userDict["name"] as? String else { return }
                        if let photoURL = userDict["photoURL"] as? String {
                            let Appuser = user(id: document.documentID, name: name, email: email, photoURL: photoURL)
                            usersArray.append(Appuser)
                        } else {
                            let Appuser = user(id: document.documentID, name: name, email: email)
                            usersArray.append(Appuser)
                        }
                    }
                }
                completion(usersArray)
            }
        }
    }
    
    
    /// fetch a user by id
    /// - Parameters:
    ///   - userID: the id of the user to be fetched
    ///   - completion: the user
    public func fetchUser(userID: String, completion: @escaping (_ user: user?) -> Void) {
        firestoreRef.collection("users").document(userID).getDocument { (snapshot, error) in
            guard let userData = snapshot?.data(), let name = userData["name"] as? String, let email = userData["email"] as? String else {
                completion(nil)
                return
            }
            let photoURL = userData["photoURL"] as? String ?? nil
            let fetchedUser = user(id: userID, name: name, email: email, photoURL: photoURL)
            completion(fetchedUser)
        }
    }
    
    
    /// Gets the timestamp or returns "online" as to when the user was last online
    /// - Parameters:
    ///   - userID: the user id who you want to check was last online
    ///   - completion: returns a string, either the date string or "online" if the user is currently online
    public func getLastLoggedIn(_ userID: String, completion: @escaping (_ date: String) -> Void) {
        // TODO:
        databaseRef.child("userOnlineStatuses").child(userID).child("isOnline").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool, value == true {
                completion("Online")
            } else if let value = snapshot.value as? Double {
                let date = Date.convertDateToString(date: Date(timeIntervalSince1970: value))
                completion(date)
            }
        }
    }

    
}
