//
//  LocationEditorSection.swift
//  BackTrace
//
//  Created by Yun Wu on 4/30/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//
//  Date picker auto show/hide from https://stackoverflow.com/questions/29678471/expanding-and-collapsing-uitableviewcells-with-datepicker by thorb65@StackOverflow

import UIKit
import GooglePlaces

class LocationTimePickerSection : EditorTableViewSection {
    var tableViewController : LocationEditionController
    var location : LocationRecord

    var sectionTitle = "Time"
    var cells : [UITableViewCell]

    let datePickerCell = UITableViewCell()
    var datePickerVisible : Bool
    var datePicker = UIDatePicker()

    let titleCell = UITableViewCell()

    init(tableViewController: LocationEditionController, location: LocationRecord) {
        self.tableViewController = tableViewController
        self.location = location
        datePickerVisible = false
        datePicker.isHidden = true
        
        titleCell.textLabel?.text = location.getDateString()
        datePickerCell.addSubview(datePicker)
        datePicker.date = location.date

        self.cells = [titleCell, datePickerCell]
    }
    
    private func hideDatePicker(indexPath: IndexPath) {
        datePickerVisible = false
        tableViewController.tableView.beginUpdates()
        tableViewController.tableView.endUpdates()

        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0
        }) { finished in
            self.datePicker.isHidden = true
        }
    }

    private func showDatePicker(indexPath: IndexPath) {
        datePickerVisible = true
        tableViewController.tableView.beginUpdates()
        tableViewController.tableView.endUpdates()

        datePicker.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 1
        }) { finished in
            self.datePicker.isHidden = false
        }
    }
    
    func tableView(didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let datePickerIndexPath = IndexPath(row: 1, section: indexPath.section)
            if (self.datePickerVisible){
                hideDatePicker(indexPath: datePickerIndexPath)
            } else {
                showDatePicker(indexPath: datePickerIndexPath)
            }
        }
        tableViewController.tableView.deselectRow(at: indexPath, animated: true)
    }

    func heightFor(row: Int) -> CGFloat {
        if row == 1 {
            return datePickerVisible ? 216 : 0
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func contentDidChange() -> Bool {
        return location.date == datePicker.date
    }
    
    func saveContent() {
        location.date = datePicker.date
    }
}

class LocationDetailEditSeciton : NSObject, EditorTableViewSection, GMSAutocompleteViewControllerDelegate {
    var tableViewController : LocationEditionController
    var location : LocationRecord
    var sectionTitle = "Location"
    var latitude : Double
    var longtitude : Double

    let nameCell = TextFieldCell()
    let addressCell = TextFieldCell()
    var cells = [UITableViewCell]()
    
    let autoCompleteController = GMSAutocompleteViewController()

    init(tableViewController controller: LocationEditionController, location locationRecord: LocationRecord) {
        tableViewController = controller
        location = locationRecord
        latitude = locationRecord.latitude
        longtitude = locationRecord.longtitude
        
        nameCell.textField.placeholder = "Location Name"
        addressCell.textField.placeholder = "Address"
        cells = [nameCell, addressCell]
        
        tableViewController.addToolBar(textField: nameCell.textField)
        tableViewController.addToolBar(textField: addressCell.textField)

        super.init()
        autoCompleteController.delegate = self
    }
        
    func contentDidChange() -> Bool {
        return nameCell.textField.text != location.locationName
            || addressCell.textField.text != location.address
    }
    
    func saveContent() {
        location.locationName = nameCell.textField.text!
        location.address = addressCell.textField.text
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        nameCell.textField.text = place.name
        addressCell.textField.text = place.formattedAddress
        
        self.latitude = place.coordinate.latitude
        self.longtitude = place.coordinate.longitude
        tableViewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        tableViewController.dismiss(animated: true, completion: nil)
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
        tableViewController.present(autoCompleteController, animated: true, completion: nil)
    }
}
