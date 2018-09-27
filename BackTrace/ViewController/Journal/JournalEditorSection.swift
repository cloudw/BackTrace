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
    var datePickerVisible : Bool
    var datePicker = UIDatePicker()
    
    let titleCell = UITableViewCell()
    
    init(tableViewController: JournalEditionController, journal: Journal) {
        self.tableViewController = tableViewController
        self.journal = journal
        
        titleCell.textLabel?.text = journal.getDateString()
        
        datePickerCell.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: datePickerCell.contentView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: datePickerCell.contentView.bottomAnchor).isActive = true
        datePicker.isHidden = true
        datePickerCell.isHidden = true
        datePickerVisible = false

        datePicker.date = journal.date
        
        self.cells = [titleCell, datePickerCell]
    }
    
    private func hideDatePicker(indexPath: IndexPath) {
        datePickerVisible = false

        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0
        }) { finished in
            self.datePickerCell.isHidden = true
            self.datePicker.isHidden = true
        }

        tableViewController.tableView.beginUpdates()
        //        tableViewController.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        tableViewController.tableView.endUpdates()

    }
    
    private func showDatePicker(indexPath: IndexPath) {
        datePickerVisible = true
//        tableViewController.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        datePicker.alpha = 0

        tableViewController.tableView.beginUpdates()
        tableViewController.tableView.endUpdates()

        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 1
        }) { finished in
            self.datePickerCell.isHidden = false
            self.datePicker.isHidden = false
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
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
        
        tableViewController.addToolBar(textField: titleCell.textField)
        tableViewController.addToolBar(textField: textBodytCell.textField)

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
