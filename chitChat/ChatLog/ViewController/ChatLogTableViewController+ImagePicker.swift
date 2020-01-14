//
//  ChatLogTableViewController+ImagePicker.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

extension ChatLogTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- @IBActions
    @IBAction func cameraBtnPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func galleryBtnPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK:- UIImagePickerController Delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            self.setupImageForSending(selectedImageFromPicker: selectedImageFromPicker)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            self.setupImageForSending(selectedImageFromPicker: selectedImageFromPicker)
        } else if let videoURL = info[.mediaURL] as? NSURL {
            do {
                let videoData = try Data(contentsOf: videoURL as URL)
                self.setupVideoForSending(dataForVideo: videoData)
            } catch {
                print(error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
