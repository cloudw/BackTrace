//
//  JournalEditorSection.swift
//  BackTrace
//
//  Created by Yun Wu on 5/27/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import GooglePlaces

class JournalTimePickerSection : EditorTableViewSection {
    var tableViewController : UITableViewController
    var journal : Journal
    
    var sectionTitle = "Time"
    var cells : [UITableViewCell]
    
    let datePickerCell = UITableViewCell()
    var datePickerVisible = false
    var datePicker = UIDatePicker()
    
    let titleCell = UITableViewCell()
    
    init(tableViewController: JournalEditionController, journal: Journal) {
        self.tableViewController = tableViewController
        self.journal = journal
        
        titleCell.textLabel?.text = journal.getDateString()
        datePickerCell.addSubview(datePicker)
        datePicker.date = journal.date
        
        self.cells = [datePickerCell]
    }
    
    func heightFor(row: Int) -> CGFloat {
        var height = tableViewController.tableView.rowHeight;
        if (row == 1){
            height = self.datePickerVisible ? 216.0 : 0.0;
        }
        return height
    }

    private func hideDatePicker() {
        datePickerVisible = false
        tableViewController.tableView.beginUpdates()
        tableViewController.tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0
        }) { finished in
            self.datePicker.isHidden = true
        }
    }
    
    private func showDatePicker() {
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
    
    func didSelectRowAtRow(indexPath: IndexPath) {
        if (indexPath.row == 0) {
            if (self.datePickerVisible){
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
        tableViewController.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func contentDidChange() -> Bool {
        return journal.date == datePicker.date
    }
    
    func saveContent() {
        journal.date = datePicker.date
    }
}

class JournalTextEditionSection : NSObject, EditorTableViewSection {
    var tableViewController : UITableViewController
    var journal : Journal
    var sectionTitle = "Body"
    
    let titleCell = TextFieldCell()
    let textBodytCell = TextFieldCell()
    var cells : [UITableViewCell]
    
    init(tableViewController controller: JournalEditionController, journal journalSrc: Journal) {
        tableViewController = controller
        journal = journalSrc

        titleCell.textField.placeholder = "Title"
        textBodytCell.textField.placeholder = "Body"
        cells = [titleCell, textBodytCell]
        
        titleCell.textField.text = journal.title
        textBodytCell.textField.text = journal.summary
        
        super.init()
    }
    
    func contentDidChange() -> Bool {
        return titleCell.textField.text != journal.title
            || textBodytCell.textField.text != journal.summary
    }
    
    func saveContent() {
        journal.title = titleCell.textField.text!
        journal.summary = textBodytCell.textField.text!
    }
}
