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
    
    var timePickerSection : LocationTimePickerSection? = nil
    var detailEditSection : LocationDetailEditSeciton? = nil
    
    init(location: LocationRecord) {
        record = location
        super.init(style: .plain)
        
        timePickerSection = LocationTimePickerSection(tableViewController: self, location: record)
        detailEditSection = LocationDetailEditSeciton(tableViewController: self, location: record)
        sections.append(timePickerSection!)
        sections.append(detailEditSection!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timePickerSection = sections[indexPath.section] as? LocationTimePickerSection {
            timePickerSection.tableView(didSelectRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].heightFor(row: indexPath.row)
    }
    
    override func recordEdition() {
        for section in sections {
            section.saveContent()
        }
        
        LocationRecordManager.updateLocation(locationId: record.locationId)
        navigationController?.popViewController(animated: true)
    }
}
