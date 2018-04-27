//
//  EditorViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/22/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//
import UIKit

class EditorViewController : UIViewController  {
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let photoPicker = PhotoPicker()
    let keyboardToolBar = UIToolbar()

    override func viewDidLoad() {
        setupScrollView()
        setupInteraction()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .white
    }

    private func setupInteraction() {
        let saveEditButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonAction))
        navigationItem.rightBarButtonItem = saveEditButton
        
        if tabBarController != nil {
            self.photoPicker.setup(currentVC: tabBarController!, targetImageView: self.imageView)
        } else if navigationController != nil {
            self.photoPicker.setup(currentVC: navigationController!, targetImageView: self.imageView)
        } else {
            self.photoPicker.setup(currentVC: self, targetImageView: self.imageView)
        }
        
        let tap = UITapGestureRecognizer(target: self.photoPicker, action: #selector(self.photoPicker.addImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        let doneEditingButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        keyboardToolBar.setItems([doneEditingButton], animated: false)
        keyboardToolBar.sizeToFit()
    }

    @objc private func doneEditing() {
        view.endEditing(true)
    }

    @objc func saveButtonAction() {
        if contentDidChange() {
            showConfirmationAlert(title: "Save edition?", message: nil, yes: recordEdition, no: nil)
        }
    }

    func loadRecord(record: AnyObject) {
        preconditionFailure("Must be overriden by children")
    }
    
    func contentDidChange() -> Bool {
        preconditionFailure("Must be overriden by children")
    }
    
    func recordEdition() {
        preconditionFailure("Must be overriden by children")
    }
    
    private func showConfirmationAlert(title: String?, message: String?, yes: (() -> Void)? , no: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let no = UIAlertAction(title: "No", style: .cancel) { action -> Void in no?() }
        let yes = UIAlertAction(title: "Yes", style: .default) { action -> Void in yes?() }
        alertController.addAction(no)
        alertController.addAction(yes)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

