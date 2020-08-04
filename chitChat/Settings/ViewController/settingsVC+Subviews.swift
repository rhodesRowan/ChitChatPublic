//
//  settingsVC+Subviews.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit
import Firebase

extension settingsVC {
    
    // MARK:- Public
    public func configureSubviews() {
        //configure name Text
        guard let currentUser = AuthManager.sharedInstance.getCurrentUser() else { return }
        setupTitleLbl()
        setupContainerView()
        setupNameTxt(currentUser)
        setupProfileImg(currentUser)
        setupBlurView()
        setupProfileIcon()
    }
    
    // MARK:- Private
    fileprivate func setupTitleLbl() {
        //title Label traits
        self.titleLbl.textColor = UIColor.white
        self.titleLbl.layer.masksToBounds = true
        self.titleLbl.textAlignment = .center
        self.titleLbl.layer.cornerRadius = 20
        self.titleLbl.backgroundColor = ThemeManager.shared.greenColor.withAlphaComponent(0.6)
    }
    
    fileprivate func setupBlurView() {
        // blur imageview
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.profileImg.frame
        blurView.frame = self.profileImg.frame
        blurView.contentView.addSubview(vibrancyEffectView)
        self.profileImg.addSubview(blurView)
    }
    
    fileprivate func setupContainerView() {
        // settings container view
        self.settingsContainerView.layer.cornerRadius = 35
        self.settingsContainerView.backgroundColor = .systemBackground
        self.settingsContainerView.layer.masksToBounds = true
    }
    
    fileprivate func setupProfileImg(_ currentUser: User) {
        // configure profile image
        self.profileImg.contentMode = .scaleAspectFill
        self.setupPhotoImageViews(photoURL: currentUser.photoURL)
    }
    
    fileprivate func setupNameTxt(_ currentUser: User) {
        self.nameTextField.placeholder = currentUser.displayName
        self.nameTextField.textColor = .darkGray
        self.nameTextField.backgroundColor = UIColor.secondarySystemFill
        self.nameTextField.layer.cornerRadius = 10
        self.nameTextField.layer.masksToBounds = true
        self.nameTextField.delegate = self
    }
    
    fileprivate func setupProfileIcon() {
        // configure profile icon
        self.profileIconImg.clipsToBounds = true
        self.profileIconImg.contentMode = .scaleAspectFill
        self.profileIconImg.layer.borderColor = ThemeManager.shared.greenColor.cgColor
        self.profileIconImg.layer.borderWidth = 3
        self.profileIconImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changePhoto))
        self.profileIconImg.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func changePhoto() {
        self.showActionSheet()
    }
    
    fileprivate func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.accessCamera()
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupPhotoImageViews(photoURL: URL?) {
        if let photoURL = photoURL?.absoluteString {
            self.profileImg.loadImageUsingCacheWithURLString(urlString: photoURL)
            self.profileIconImg.loadImageUsingCacheWithURLString(urlString: photoURL)
        } else {
            self.profileImg.image = UIImage(named: "user")
            self.profileIconImg.image = UIImage(named: "user")
        }
    }
}
