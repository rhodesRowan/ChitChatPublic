//
//  FirebaseUserDetailsManager.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class UserDetailsManager {
    
    // MARK:- Properties
    private let firestoreRef = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    static let sharedInstance = UserDetailsManager()
    
    // MARK:- Public
    
    /// change the url of the photo property on the user, and then update the url of the user in the database
    /// - Parameters:
    ///   - photoUrl: the url of the new photo
    ///   - completion: a bolean value indicating whether the photoURL had been successfully changed and additionally whether the photo url had changed in the database
    public func changePhoto(photoUrl: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        guard let current = AuthManager.sharedInstance.getCurrentUser() else { return completion(false, "There is currently no signed in user") }
       let changeRequest = current.createProfileChangeRequest()
       changeRequest.photoURL = URL(string: photoUrl)
       changeRequest.commitChanges { [weak self] (err) in
           if let error = err {
            completion(false, error.localizedDescription)
           } else {
               self?.updateDatabasePhotoURL(photoURL: photoUrl) { (success) in
                   if success {
                    completion(true, nil)
                   } else {
                    completion(false, nil)
                   }
               }
           }
       }
    }
   
    
    /// sets the device token in the database, used for sending push notifications from cloud functions
    /// - Parameter token: the device token to send the push notifications too
   public func setDeviceToken(token: String) {
       guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
       let userRef = firestoreRef.collection("users").document(currentUser.uid)
       userRef.setData(["deviceToken": token], merge: true) { (err) in
           if let error = err {
               print(error)
           } else {
               print("success")
           }
       }
   }
   
    
    /// sets the display name for the current user
    /// - Parameters:
    ///   - user: the current user
    ///   - name: the name to be set
    ///   - completion: bolean value indicating whether the name was successfully set
   public func setDisplayName(user: User, name: String, completion: @escaping (_ success: Bool) -> Void) {
       let changeRequest = user.createProfileChangeRequest()
       changeRequest.displayName = name.lowercased()
       changeRequest.commitChanges(completion: { (error) in
           if let error = error {
               print(error.localizedDescription)
               completion(false)
           } else {
               self.addUserToDatabase(user: user) { (success) in
                   if success {
                       completion(true)
                   } else {
                       completion(false)
                   }
               }
           }
       })
   }
   
    
    /// changes the display name and updates the name property in the database
    /// - Parameters:
    ///   - name: name that the user wants to change too
    ///   - completion: a bolean value indicating whether or not the change was successful, if it failed, an error message is returned as to why the change failed
    public func changeUserName(name: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
       guard let currentUser = Auth.auth().currentUser else { return }
       let changeRequest = currentUser.createProfileChangeRequest()
       changeRequest.displayName = name.lowercased()
       changeRequest.commitChanges(completion: { (error) in
           if let error = error {
               print(error.localizedDescription)
               completion(false, error.localizedDescription)
           } else {
               self.updateName(user: currentUser) { (success) in
                   if success {
                    completion(true, nil)
                   } else {
                    completion(false, nil)
                   }
               }
           }
       })
   }
   

    
    /// adds the user to the database after registering
    /// - Parameters:
    ///   - user: the current user
    ///   - completion: a bolean value indicating whether or not the user was successfully uploaded to firebase or not
   public func addUserToDatabase(user: User, completion: @escaping (_ success: Bool) -> Void) {
       let userDict: [String: Any] = ["email": user.email!, "name": user.displayName!.lowercased()]
       firestoreRef.collection("users").document(user.uid).setData(userDict) { (err) in
           if err != nil {
            print(err?.localizedDescription ?? "")
               completion(false)
           } else {
               completion(true)
           }
       }
   }
    
    
    /// uploads the users profile picture to firebase storage
    /// - Parameters:
    ///   - imgData: the data of the image to be changed too
    ///   - completion: a bolean value indicating whether or not the upload was successful or not, if not, an error message is given as to the reason why it failed
    public func uploadProfileImage(imgData: Data, completion: @escaping (_ success: String?, _ error: String?) -> Void) {
        let profileImagesPath = storageRef.child("profileImages").child("\(Auth.auth().currentUser!.uid).jpg")
        profileImagesPath.putData(imgData, metadata: nil) { (metaData, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil, error?.localizedDescription)
            } else {
                    profileImagesPath.downloadURL(completion: { (url, err) in
                    if let err = error {
                        print(err.localizedDescription)
                        completion(nil, nil)
                    } else {
                        completion(url?.absoluteString, nil)
                    }
                })
            }
        }
    }
    
    
    // MARK:- Private
    fileprivate func updateDatabasePhotoURL(photoURL: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let current = Auth.auth().currentUser else { return completion(false) }
        firestoreRef.collection("users").document(current.uid).updateData(["photoURL": photoURL]) { (err) in
            if let error = err {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    fileprivate func updateName(user: User, completion: @escaping (_ success: Bool) -> Void) {
        firestoreRef.collection("users").document(user.uid).updateData(["name": user.displayName!.lowercased()]) { (err) in
            if err != nil {
                print(err?.localizedDescription ?? "")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
