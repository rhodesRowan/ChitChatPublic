//
//  ViewController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 03/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Properties
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    var loadingView: AuthLoadingContainerView!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardObservers()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK:- Deinit
    deinit {
        print("DEINIT LOGIN")
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    // MARK:- @IBActions
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.addLoadingContainerView()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        AuthManager.sharedInstance.Login(email: email, password: password) { [weak self]
            (success, err)  in
            guard let self = self else { return }
            self.loadingView.removeFromSuperview()
            if success {
                AuthManager.sharedInstance.transitionToConversations(self)
            } else if err != nil {
                let failedAlert = UIAlertController.failedToPerformNetworkRequest(errorMessage: err!)
                self.present(failedAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- Private
    fileprivate func addLoadingContainerView() {
        loadingView = AuthLoadingContainerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        loadingView.center = self.view.center
        loadingView.configureLabel(labelText: "Signing In...")
        self.view.addSubview(loadingView)
    }
        
}

