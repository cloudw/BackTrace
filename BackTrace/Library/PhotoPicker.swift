//
//  PhotoPicker.swift
//  BackTrace
//
//  Created by Yun Wu on 4/16/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class PhotoPicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var currentVC: UIViewController?
    var targetImageView: UIImageView?
    
    func setup(currentVC: UIViewController, targetImageView: UIImageView) {
        self.currentVC = currentVC
        self.targetImageView = targetImageView
    }
    
    @objc func addImage() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { action -> Void in self.camera() }
        let photoLibrary = UIAlertAction(title: "Album", style: .default) { action -> Void in self.photoLibrary() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in}
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        currentVC?.present(alertController, animated: true, completion: nil)
    }
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.targetImageView?.image = image
        }else{
            print("Failed loading picked image")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
}
