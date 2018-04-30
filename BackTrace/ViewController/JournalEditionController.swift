//
//  RecordDetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/9/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import CoreGraphics

class JournalEditionController : EditorViewController {
    var record : Journal?
    let dateField = UIDatePicker()
    let titleField = UITextField()
    let summaryField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInteraction()
    }
    
    private func setupView() {
        let sectionTitleFontSize:CGFloat = 20
        view.backgroundColor = .white
        
        let dateLabel = UILabel()
        let titleLabel = UILabel()
        let summaryLabel = UILabel()
        let imageLabel = UILabel()
        let locationLabel = UILabel()
        
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(dateField)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleField)
        scrollView.addSubview(summaryLabel)
        scrollView.addSubview(summaryField)
        scrollView.addSubview(imageLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(locationLabel)
        
        scrollView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        dateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: sectionTitleFontSize + 5).isActive = true
        dateLabel.text = "Time"
        dateLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        
        scrollView.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        dateField.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        dateField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 140).isActive = true
        dateField.datePickerMode = .date
        dateField.contentMode = .scaleToFill
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraintEqualToSystemSpacingBelow(dateField.bottomAnchor, multiplier: 2).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        titleLabel.text = "Title"

        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        titleField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        titleField.topAnchor.constraintEqualToSystemSpacingBelow(titleLabel.bottomAnchor, multiplier: 1).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleField.borderStyle = .roundedRect
        
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        summaryLabel.topAnchor.constraintEqualToSystemSpacingBelow(titleField.bottomAnchor, multiplier: 2).isActive = true
        summaryLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        summaryLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        summaryLabel.text = "Summary"

        summaryField.translatesAutoresizingMaskIntoConstraints = false
        summaryField.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        summaryField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        summaryField.topAnchor.constraintEqualToSystemSpacingBelow(summaryLabel.bottomAnchor, multiplier: 1).isActive = true
        summaryField.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        summaryField.layer.borderWidth = 0.5
        summaryField.layer.borderColor = UIColor.gray.cgColor

        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        imageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageLabel.topAnchor.constraintEqualToSystemSpacingBelow(summaryField.bottomAnchor, multiplier: 2).isActive = true
        imageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        imageLabel.text = "Photo"
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.topAnchor.constraintEqualToSystemSpacingBelow(imageLabel.bottomAnchor, multiplier: 1).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.backgroundColor = .gray

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        locationLabel.topAnchor.constraintEqualToSystemSpacingBelow(summaryField.bottomAnchor, multiplier: 2).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)
        locationLabel.text = "Locations"

    }

    private func setupInteraction() {
        let saveEditButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonAction))
        navigationItem.rightBarButtonItem = saveEditButton
        
        self.photoPicker.setup(currentVC: navigationController!, targetImageView: self.imageView)
        
        let tap = UITapGestureRecognizer(target: self.photoPicker, action: #selector(self.photoPicker.addImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
                
        titleField.inputAccessoryView = keyboardToolBar
        summaryField.inputAccessoryView = keyboardToolBar
    }
        
    func loadRecord(record: Journal) {
        self.record = record
        imageView.image = record.image
        dateField.date = record.date
        titleField.text = record.title
        summaryField.text = record.summary
    }

    override func contentDidChange() -> Bool {
        return self.record?.title != self.titleField.text! ||
        self.record?.summary != self.summaryField.text! ||
        self.record?.date != self.dateField.date ||
        self.record?.image != self.imageView.image
    }
    
    override func recordEdition() {
        if record != nil {
            self.record!.title = self.titleField.text!
            self.record!.summary = self.summaryField.text!
            self.record!.date = self.dateField.date
            self.record!.image = self.imageView.image
            
            JournalManager.updateJournal(journalId: record!.journalId)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc override func saveButtonAction() {
        if contentDidChange() {
            showConfirmationAlert(title: "Save edition?", message: nil, yes: recordEdition, no: nil)
        }
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
