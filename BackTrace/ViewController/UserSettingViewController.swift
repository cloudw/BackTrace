//
//  UserSettingViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/21/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import Foundation

class UserSettingViewController : UITableViewController {
    let userDefault = UserDefaults()
    let recordLocationSwitch = UISwitch()
    let recordDistanceField = UITextField()
    let defaultZoomLevelSlider = UISlider()
    
    let cellTitles : [String:[String]]
    
    enum preferenceKeys : CustomStringConvertible {
        case recordDistance
        case recordStarted
        case defaultMapZoomLevel
        case timeZone

        var description: String {
            switch self {
            // Use Internationalization, as appropriate.
            case .recordDistance: return "recordDistance"
            case .recordStarted: return "recordStarted"
            case .defaultMapZoomLevel: return "defaultMapZoomLevel"
            case .timeZone: return "timeZone"
            }
        }
    }

    private func loadUserSettings() {
        recordLocationSwitch.isOn = userDefault.bool(forKey: preferenceKeys.recordStarted.description)
        recordDistanceField.text = String(userDefault.double(forKey: preferenceKeys.recordDistance.description))
    }

    override init(style: UITableViewStyle) {
        cellTitles = [
            "Location Tracking": ["Track Location", "Distance for new record"],
            "Others": ["Default Zoom Level", "Other Settings"]
        ]
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.backgroundColor = UIColor.init(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
        for sectionTitle in cellTitles.keys {
            tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: sectionTitle)
            for cellTitle in cellTitles[sectionTitle]! {
                tableView.register(SettingCell.self, forCellReuseIdentifier: cellTitle)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Location record settings
        // Other settings
        return cellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let secitonTitle = Array(cellTitles.keys)[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: secitonTitle)
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let secitonTitle = Array(cellTitles.keys)[section]
        return cellTitles[secitonTitle]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secitonTitle = Array(cellTitles.keys)[indexPath.section]
        let cellId = cellTitles[secitonTitle]![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        setupCell(cell: cell, cellId: cellId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func setupCell(cell tableCell: UITableViewCell, cellId: String) {
        if let cell = tableCell as? SettingCell {
            if !cell.setupCompleted {
                switch cellId {
                case "Track Location":
                    cell.addRightItem(view: recordLocationSwitch)
                case "Distance for new record":
                    cell.addRightItem(view: recordDistanceField)
                default:
                    return
                }
            }
        }
    }
}

class SettingCell : UITableViewCell {
    var setupCompleted = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        textLabel?.text = reuseIdentifier
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRightItem(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

class RecordDistanceCell : SettingCell, UITextFieldDelegate {
    func addRightItem(view: UITextField) {
        super.addRightItem(view: view)
        view.placeholder = "Distance in miles"
        view.borderStyle = .roundedRect
        view.clearButtonMode = .whileEditing
        view.keyboardType = .numberPad
        view.delegate = self
    }
}

class TableHeader : UITableViewHeaderFooterView {
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        title.text = reuseIdentifier
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.leadingAnchor.constraintEqualToSystemSpacingAfter(self.leadingAnchor, multiplier: 2).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        title.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        title.textColor = .gray
    }
}

