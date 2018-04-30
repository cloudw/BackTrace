//
//  RecordDetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/15/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationEditionController: EditorViewController, GMSAutocompleteViewControllerDelegate {
    var record : LocationRecord?
    var latitude:Double = 0
    var longtitude:Double = 0
    
    let dateField = UIDatePicker()

    let autoCompleteButton = UIButton()
    let locationNameField = TextField()
    let addressField = TextField()
    let latitudeField = UILabel()
    let longtitudeField = UILabel()
    let autoCompleteController = GMSAutocompleteViewController()
    
    var sectionTitles : [String]

    func setupTabelContent(){
        sectionTitles = ["Summary", "Image"]
        
    }

    init() {
        setupTabelContent()
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInteraction()
    }
    
    private func setupView() {
        let sectionTitleFontSize:CGFloat = 20
        
        let dateLabel = UILabel()
        let locationLabel = UILabel()
        let locationNameLabel = UILabel()
        let addressLabel = UILabel()
        let latitudeLabel = UILabel()
        let longtitudeLabel = UILabel()
        let imageLabel = UILabel()
        let mapLabel = UILabel()

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
        dateField.datePickerMode = .dateAndTime
        dateField.contentMode = .scaleToFill
        
        scrollView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5)
        locationLabel.topAnchor.constraint(equalTo: dateField.bottomAnchor).isActive = true
        locationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: sectionTitleFontSize + 5).isActive = true
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)

        scrollView.addSubview(autoCompleteButton)
        autoCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        autoCompleteButton.leadingAnchor.constraintEqualToSystemSpacingAfter(locationLabel.trailingAnchor, multiplier: 1).isActive = true
        autoCompleteButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        autoCompleteButton.topAnchor.constraint(equalTo: locationLabel.topAnchor).isActive = true
        autoCompleteButton.heightAnchor.constraint(equalTo: locationLabel.heightAnchor).isActive = true
        autoCompleteButton.setTitle("Search", for: .normal)
        autoCompleteButton.setTitleColor(.blue, for: .normal)
        
        addLabelAndField(label: locationNameLabel, field: locationNameField, below: locationLabel)
        locationNameLabel.text = "Name"
        locationNameField.borderStyle = .roundedRect

        addLabelAndField(label: addressLabel, field: addressField, below: locationNameLabel)
        addressLabel.text = "Address"
        addressField.borderStyle = .roundedRect

        addLabelAndField(label: latitudeLabel, field: latitudeField, below: addressLabel)
        latitudeLabel.text = "Latitude"

        addLabelAndField(label: longtitudeLabel, field: longtitudeField, below: latitudeLabel)
        longtitudeLabel.text = "Longtitude"
        
        scrollView.addSubview(imageLabel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        imageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageLabel.topAnchor.constraintEqualToSystemSpacingBelow(longtitudeLabel.bottomAnchor, multiplier: 2).isActive = true
        imageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: sectionTitleFontSize + 5).isActive = true
        imageLabel.text = "Photo"
        imageLabel.font = UIFont.systemFont(ofSize: sectionTitleFontSize, weight: .bold)

        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, constant: -systemMinimumLayoutMargins.leading + systemMinimumLayoutMargins.trailing).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.heightAnchor, constant: -systemMinimumLayoutMargins.leading + systemMinimumLayoutMargins.trailing).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.backgroundColor = .gray
        
        scrollView.addSubview(mapLabel)
        mapLabel.translatesAutoresizingMaskIntoConstraints = false
        mapLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        mapLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mapLabel.topAnchor.constraintEqualToSystemSpacingBelow(imageView.bottomAnchor, multiplier: 2).isActive = true
        mapLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        mapLabel.text = "Location on Map"
        mapLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private func addLabelAndField(label: UILabel, field: UIView, below viewAbove: UIView){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraintEqualToSystemSpacingAfter(scrollView.leadingAnchor, multiplier: 2).isActive = true
        label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3)
        label.topAnchor.constraintEqualToSystemSpacingBelow(viewAbove.bottomAnchor, multiplier: 1).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        scrollView.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leadingAnchor.constraintEqualToSystemSpacingAfter(label.trailingAnchor, multiplier: 1).isActive = true
        field.trailingAnchor.constraintEqualToSystemSpacingAfter(scrollView.trailingAnchor, multiplier: -1)
        field.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        field.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
    }
    
    private func setupInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.presentPlaceAutocompleteController))
        autoCompleteButton.isUserInteractionEnabled = true
        autoCompleteButton.addGestureRecognizer(tap)
        autoCompleteController.delegate = self
        
        locationNameField.inputAccessoryView = keyboardToolBar
        addressField.inputAccessoryView = keyboardToolBar
    }
    
    func loadRecord(record: LocationRecord) {
        self.record = record
        imageView.image = record.image
        dateField.date = record.date
        locationNameField.text = record.locationName
        addressField.text = record.address
        self.latitude = record.latitude
        latitudeField.text = String(record.latitude)
        self.longtitude = record.longtitude
        longtitudeField.text = String(record.longtitude)
    }

    override func contentDidChange() -> Bool {
        return self.record?.locationName != self.locationNameField.text! ||
            self.record?.address != self.addressField.text! ||
            self.record?.date != self.dateField.date ||
            self.record?.image != self.imageView.image ||
            self.record?.latitude != self.latitude ||
            self.record?.longtitude != self.longtitude
    }
    
    override func recordEdition() {
        if record != nil {
            self.record!.locationName = self.locationNameField.text!
            self.record!.address = self.addressField.text!
            self.record!.date = self.dateField.date
            self.record!.image = self.imageView.image
            self.record!.latitude = self.latitude
            self.record!.longtitude = self.longtitude
            
            LocationRecordManager.updateLocation(locationId: record!.locationId)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.locationNameField.text = place.name
        self.addressField.text = place.formattedAddress
        self.latitude = place.coordinate.latitude
        self.latitudeField.text = String(place.coordinate.latitude)
        self.longtitude = place.coordinate.longitude
        self.longtitudeField.text = String(place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @objc private func presentPlaceAutocompleteController() {
        autoCompleteController.autocompleteBounds = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D(latitude: latitude+0.25, longitude: longtitude+0.25),
            coordinate: CLLocationCoordinate2D(latitude: latitude-0.25, longitude: longtitude-0.25)
        )
        autoCompleteController.autocompleteBoundsMode = .bias
        self.present(autoCompleteController, animated: true, completion: nil)
    }
}
