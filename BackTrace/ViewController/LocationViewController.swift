//
//  RecordDetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/15/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    var record : LocationRecord?
    let imageView = UIImageView()
    let dateField = UIDatePicker()
    let locationNameField = UITextField()
    let photoPicker = PhotoPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInteraction()
    }
    
    private func setupView() {
        let lineMargin:CGFloat = 10
        let sideMargin:CGFloat = 10
        view.backgroundColor = .white
        
        let locationNamelabel = UILabel()
        let imageLabel = UILabel()
        
        view.addSubview(dateField)
        view.addSubview(locationNamelabel)
        view.addSubview(locationNameField)
        view.addSubview(imageLabel)
        view.addSubview(imageView)

        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dateField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dateField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        dateField.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        dateField.datePickerMode = .dateAndTime
        
        locationNamelabel.translatesAutoresizingMaskIntoConstraints = false
        locationNamelabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        locationNamelabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationNamelabel.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: lineMargin).isActive = true
        locationNamelabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationNamelabel.text = "Title"
        
        locationNameField.translatesAutoresizingMaskIntoConstraints = false
        locationNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        locationNameField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationNameField.topAnchor.constraint(equalTo: locationNamelabel.bottomAnchor).isActive = true
        locationNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationNameField.layer.borderWidth = 0.5
        locationNameField.layer.borderColor = UIColor.gray.cgColor

        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        imageLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageLabel.topAnchor.constraint(equalTo: locationNameField.bottomAnchor, constant: lineMargin).isActive = true
        imageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageLabel.text = "Photo"

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.backgroundColor = .gray
    }
    
    private func setupInteraction() {
        let saveEditButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonAction))
        navigationItem.rightBarButtonItem = saveEditButton
        
        self.photoPicker.setup(currentVC: navigationController!, targetImageView: self.imageView)
        
        let tap = UITapGestureRecognizer(target: self.photoPicker, action: #selector(self.photoPicker.addImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func contentDidChange() -> Bool {
        return self.record?.locationName != self.locationNameField.text! ||
        self.record?.date != self.dateField.date ||
        self.record?.image != self.imageView.image
    }
    
    private func recordEdition() {
        if record != nil {
            self.record!.locationName = self.locationNameField.text!
            self.record!.date = self.dateField.date
            self.record!.image = self.imageView.image
            
            DataSource.updateLocation(locationId: record!.locationId)
            
            if let tableView = navigationController?.viewControllers[0].view as? UITableView {
                tableView.reloadData()
            }
        }
    }
    
    @objc func saveButtonAction() {
        if contentDidChange() {
            showConfirmationAlert(title: "Save edition?", message: nil, yes: recordEdition, no: nil)
        }
    }
    
    func loadRecord(record: LocationRecord) {
        self.record = record
        imageView.image = record.image
        dateField.date = record.date
        locationNameField.text = record.locationName
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
