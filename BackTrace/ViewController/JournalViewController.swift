//
//  JournalViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import os

class JournalViewController : DetailViewController {
    var journal : Journal?
    
    var sections = [TableViewSection]()
    var textSection : JournalTextSection?
    var photoSection : JournalPhotoSection?
    
    func loadLocationRecord(journal: Journal) {
        self.journal = journal
        
        textSection = JournalTextSection(journalViewController: self, journal: journal)
        photoSection = JournalPhotoSection(journalViewController: self, journal: journal)
        sections.append(textSection!)
        sections.append(photoSection!)

        // Register cell ids
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
            title = "Jounal"
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    @objc private func showEditor() {
        let editController = JournalEditionController()
        editController.loadRecord(record: journal!)
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
