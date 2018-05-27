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
    
    let dateField = UIDatePicker()

    let locationNameField = TextField()
    let addressField = TextField()
    let latitudeField = UILabel()
    let longtitudeField = UILabel()
    
    var sections = [EditorTableViewSection]()
    
    init(record soureRecord: LocationRecord) {
        record = soureRecord
        super.init(style: .plain)
        
        sections.append(LocationTimePickerSection(tableViewController: self, location: record))
        sections.append(LocationDetailEditSeciton(tableViewController: self, location: record))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInteraction()
    }
    
    private func setupInteraction() {
        locationNameField.inputAccessoryView = keyboardToolBar
        addressField.inputAccessoryView = keyboardToolBar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cellAt(row: indexPath.row)
    }
    
    override func contentDidChange() -> Bool {
        for section in sections {
            if section.contentDidChange() {
                return true
            }
        }
        return false
    }
    
    override func recordEdition() {
        for section in sections {
            section.saveContent()
        }
        LocationRecordManager.updateLocation(locationId: record.locationId)
        navigationController?.popViewController(animated: true)
    }
}
