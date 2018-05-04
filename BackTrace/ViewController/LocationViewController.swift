//
//  LocationViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import os

class LocationViewController : DetailViewController {
    var locationRecord : LocationRecord?
    
    var sections = [TableViewSection]()
    var detailSection : LocationDetailSection?
    var photoSection : LocationPhotoSection?
    
    func loadLocationRecord(location: LocationRecord) {
        locationRecord = location
        
        detailSection = LocationDetailSection(locationViewController: self, location: location)
        photoSection = LocationPhotoSection(locationViewController: self, location: location)
        sections.append(detailSection!)
        sections.append(photoSection!)

        for section in sections {
            for row in 0..<section.numberOfRows(){
                let id = section.cellIdentifierFor(row: row)
                tableView.register(section.cellClassFor(id: id), forCellReuseIdentifier: id)
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditor))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
        if navigationController != nil {
            title = "Location Detail"
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    @objc private func showEditor() {
        let editController = LocationEditionController()
        editController.loadRecord(record: locationRecord!)
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].numberOfRows()
        } else {
            os_log("Location View invalid section index for section row number", log: OSLog.default, type: .debug)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cellAt(row: indexPath.row)
    }

}

