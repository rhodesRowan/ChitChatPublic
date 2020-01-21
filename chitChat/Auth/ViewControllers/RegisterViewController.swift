//
//  RegisterViewController.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    // MARK:- Properties
    @IBOutlet weak var nameTxt: AuthTxtField!
    @IBOutlet weak var emailTxt: AuthTxtField!
    @IBOutlet weak var passwordTxt: AuthTxtField!
    var loadingView: AuthLoadingContainerView!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK:- Deinit
    deinit {
        print("DEINIT REGISTER")
    }
    
    // MARK:- @IBActions
    @IBAction func dismissRegisterVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnPressed(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.addLoadingContainerView()
        guard let name = nameTxt.text, name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, let email = emailTxt.text, let password = passwordTxt.text else { return self.presentFailedAlert(alertMessage: "Please fill in all fields") }
        AuthManager.sharedInstance.Register(email: email, password: password, name: name) { [weak self] (success, err) in
            guard let self = self else { return }
            self.loadingView.removeFromSuperview()
            if success {
                AuthManager.sharedInstance.transitionToConversations(self)
            } else if err != nil {
                self.presentFailedAlert(alertMessage: err!)
            }
        }
    }
    
    // MARK:- Private
    fileprivate func presentFailedAlert(alertMessage: String) {
        self.loadingView.removeFromSuperview()
        let failedAlert = UIAlertController.failedToPerformNetworkRequest(errorMessage: alertMessage)
        self.present(failedAlert, animated: true, completion: nil)
    }
    
    fileprivate func addLoadingContainerView() {
        loadingView = AuthLoadingContainerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        loadingView.center = self.view.center
        loadingView.configureLabel(labelText: "Registering...")
        self.view.addSubview(loadingView)
    }
        
}
