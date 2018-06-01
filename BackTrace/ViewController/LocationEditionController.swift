//
//  RecordDetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/15/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class LocationEditionController: EditorViewController {
    var record : LocationRecord
    
//    let locationNameField = TextField()
//    let addressField = TextField()
//    let latitudeField = UILabel()
//    let longtitudeField = UILabel()
//    private func setupInteraction() {
//        locationNameField.inputAccessoryView = keyboardToolBar
//        addressField.inputAccessoryView = keyboardToolBar
//    }

    init(location: LocationRecord) {
        record = location
        super.init(style: .plain)
        
        sections.append(LocationTimePickerSection(tableViewController: self, location: record))
        sections.append(LocationDetailEditSeciton(tableViewController: self, location: record))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func recordEdition() {
        for section in sections {
            section.saveContent()
        }
        
        LocationRecordManager.updateLocation(locationId: record.locationId)
        navigationController?.popViewController(animated: true)
    }
}
