//
//  settingsVC.swift
//  chitChat
//
//  Created by Rowan Rhodes on 09/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class settingsVC: UIViewController {
    
    //MARK:- @IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var settingsContainerView: UIView!
    @IBOutlet weak var titleLbl: titleLabel!
    @IBOutlet weak var profileIconImg: profileCircularImage!
    @IBOutlet weak var saveBtn: UIButton!
    var savingChangesContainer: UIView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureSubviews()
        self.setupKeyboardObservers()
        self.hideKeyboardWhenTappedAround()
        self.nameTxt.delegate = self
    }
    
    //MARK:- @IBActions
       
    @IBAction func changeName(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else { return }
       UserDetailsManager.sharedInstance.changeUserName(name: name) { [weak self] (success, err) in
        guard let self = self else { return }
        if err != nil {
            let failedAlert = UIAlertController.failedToPerformNetworkRequest(errorMessage: err!)
            self.present(failedAlert, animated: true, completion: nil)
        } else if success {
            self.dismiss(animated: true, completion: nil)
        }
       }
    }
    
    //MARK:- Private
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc public override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc public override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    //MARK:- Public
    public func sendImageToStorage(data: Data) {
        UserDetailsManager.sharedInstance.uploadProfileImage(imgData: data) { [weak self] (url, err) in
            guard let self = self else { return }
            if err != nil {
                let failedAlert = UIAlertController.failedToPerformNetworkRequest(errorMessage: err!)
                self.present(failedAlert, animated: true, completion: nil)
            } else if let downloadURL = url {
                UserDetailsManager.sharedInstance.changePhoto(photoUrl: downloadURL) { [weak self] (success, err) in
                    guard let self = self else { return }
                    if err != nil {
                        let failedAlert = UIAlertController.failedToPerformNetworkRequest(errorMessage: err!)
                        self.present(failedAlert, animated: true, completion: nil)
                    } else if success {
                        self.profileImg.loadImageUsingCacheWithURLString(urlString: downloadURL)
                        self.profileIconImg.loadImageUsingCacheWithURLString(urlString: downloadURL)
                    }
                }
            }
        }
    }
    
    public func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPickerController = UIImagePickerController()
            cameraPickerController.delegate = self
            cameraPickerController.sourceType = .camera
            self.present(cameraPickerController, animated: true, completion: nil)
        }
    }
    
    public func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPickerController = UIImagePickerController()
            photoPickerController.delegate = self
            photoPickerController.sourceType = .photoLibrary
            self.present(photoPickerController, animated: true, completion: nil)
        }
    }
    
}
