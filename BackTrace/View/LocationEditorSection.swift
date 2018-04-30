//
//  LocationEditorSection.swift
//  BackTrace
//
//  Created by Yun Wu on 4/30/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//
//  Date picker auto show/hide from https://stackoverflow.com/questions/29678471/expanding-and-collapsing-uitableviewcells-with-datepicker by thorb65@StackOverflow

import UIKit

class LocationTimePickerSection : EditorTableViewSection {
    var tableViewController : UITableViewController
    var location : LocationRecord

    var sectionTitle = "Time"
    var cells = [UITableViewCell]()
    let dateDisplayCell = 
    
    var statusPickerVisible = false

    
    init(tableViewController: UITableViewController, location: LocationRecord) {
        self.tableViewController = tableViewController
        self.location = location

        
    }
    
    func heightForRowAt(row: Int) -> CGFloat {
        var height = tableViewController.tableView.rowHeight;
        if (row == 1){
            height = self.statusPickerVisible ? 216.0 : 0.0;
        }
        return height
    }
    
    private func hideDatePicker() {
        
    }
    
    private func showDatePicker() {
        
    }
    
    func didSelectRowAtRow(indexPath: IndexPath) {
        if (indexPath.row == 0) {
            if (self.statusPickerVisible){
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
        tableViewController.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func contentDidChange() -> Bool {
        <#code#>
    }
    
    func saveContent() {
        <#code#>
    }
}

class LocationDetailEditSeciton : EditorTableViewSection {
    var tableViewController : UITableViewController
    var location : LocationRecord
    var sectionTitle = "Location"
    
    let nameCell = TextFieldCell()
    let addressCell = TextFieldCell()
    var cells = [UITableViewCell]()
    
    init(tableViewController: UITableViewController, location: LocationRecord) {
        self.tableViewController = tableViewController
        self.location = location
        
        nameCell.textField.placeholder = "Location Name"
        nameCell.textField.placeholder = "Address"
        cells = [nameCell, addressCell]
    }
        
    func contentDidChange() -> Bool {
        return nameCell.textField.text != location.locationName
            || addressCell.textField.text != location.address
    }
    
    func saveContent() {
        location.locationName = nameCell.textField.text!
        location.address = addressCell.textField.text
    }
}
