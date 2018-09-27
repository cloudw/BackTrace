//
//  RecordDetailViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/9/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import CoreGraphics

class JournalEditionController : EditorViewController {
    var record : Journal
    
    init(journal: Journal) {
        record = journal
        super.init(style: .plain)

        sections.append(JournalTimePickerSection(tableViewController: self, journal: record))
        sections.append(JournalTextEditionSection(tableViewController: self, journal: record))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timePickerSection = sections[indexPath.section] as? JournalTimePickerSection {
            timePickerSection.didSelectRowAt(indexPath: indexPath)
        } 
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

        JournalManager.updateJournal(journalId: record.journalId)
        navigationController?.popViewController(animated: true)
    }
}
