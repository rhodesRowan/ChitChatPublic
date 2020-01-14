//
//  SettingsVCImagePicker.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension settingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- ImagePicker delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.profileImg.image = image
                let uploadData = image.jpegData(compressionQuality: 0.1)
                self.sendImageToStorage(data: uploadData!)
            }
        }
    }
}

