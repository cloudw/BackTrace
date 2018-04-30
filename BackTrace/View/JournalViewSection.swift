//
//  JournalViewSection.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import os

class JournalTextSection : TableViewSection {    
    var journalViewController: JournalViewController
    let sectionTitle = "Summary"
    
    var journal : Journal
    var cellIds = [String]() // Ids also serve as title for cell
    var cellMap = [String:AnyClass]()
    
    init(journalViewController: JournalViewController, journal: Journal) {
        self.journal = journal
        self.journalViewController = journalViewController
        
        addCellType(id: "Time", cell: LabelValueCell.self)
        addCellType(id: "Title", cell: LabelValueCell.self)
        addCellType(id: "Body", cell: TitileSubtitleCell.self)
    }
    
    private func addCellType(id: String, cell: AnyClass){
        cellIds.append(id)
        cellMap[id] = cell
    }

    func cellAt(row: Int) -> UITableViewCell {
        let cellId = cellIds[row]
        let cell = journalViewController.tableView.dequeueReusableCell(withIdentifier: cellId)!
        switch cellId {
        case "Time":
            setupTimeCell(cell)
        case "Title":
            setupNameCell(cell)
        case "Body":
            setupAddressCell(cell)
        case "Photo":
            setupImageCell(cell)
        default:
            os_log("Unrecognized cell id in jounal text section.", log: .default, type: .error)
        }
        return cell
    }
    
    private func setupTimeCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Time"
        cell.detailTextLabel?.text = journal.getDateString()
    }
    
    private func setupNameCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Title"
        cell.detailTextLabel?.text = journal.title
    }
    
    private func setupAddressCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Body"
        cell.detailTextLabel?.text = journal.summary
        if journal.summary.count == 0 {
            cell.detailTextLabel?.text = "(Empty jounal body)"
            cell.detailTextLabel?.textColor = .gray
        } else {
            cell.detailTextLabel?.textColor = .black
        }
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
    }
    
    private func setupImageCell(_ cell: UITableViewCell) {
        cell.imageView?.image = journal.image
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: journalViewController, action: #selector(journalViewController.imageTapped(_:))))
        
        if let image = cell.imageView?.image {
            let width = UIScreen.main.bounds.width - 40
            let height = width * image.size.height / image.size.width
            cell.imageView?.widthAnchor.constraint(equalToConstant: width).isActive = true
            cell.imageView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

class JournalPhotoSection : TableViewSection {
    var journalViewController: JournalViewController
    let sectionTitle = "Photo"
    
    var journal : Journal
    var cellIds = [String]() // Ids also serve as title for cell
    var cellMap = [String:AnyClass]()
    
    init(journalViewController: JournalViewController, journal: Journal) {
        self.journal = journal
        self.journalViewController = journalViewController
        
        addCellType(id: "Photo", cell: ImageCell.self)
    }
    
    private func addCellType(id: String, cell: AnyClass){
        cellIds.append(id)
        cellMap[id] = cell
    }
    
    func cellAt(row: Int) -> UITableViewCell {
        let cellId = cellIds[row]
        let cell = journalViewController.tableView.dequeueReusableCell(withIdentifier: cellId)!
        switch cellId {
        case "Photo":
            setupImageCell(cell)
        default:
            os_log("Unrecognized cell id in jounal image section.", log: .default, type: .error)
        }
        return cell
    }
    
    private func setupImageCell(_ cell: UITableViewCell) {
        cell.imageView?.image = journal.image
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: journalViewController, action: #selector(journalViewController.imageTapped(_:))))
        
        if let image = cell.imageView?.image {
            let width = UIScreen.main.bounds.width - 40
            let height = width * image.size.height / image.size.width
            cell.imageView?.widthAnchor.constraint(equalToConstant: width).isActive = true
            cell.imageView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

