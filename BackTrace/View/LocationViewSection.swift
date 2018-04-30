//
//  LocationDetailSection.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//
//  For LocationViewController

import UIKit
import os

class LocationDetailSection : TableViewSection {
    var locationViewController: LocationViewController
    let sectionTitle = "Details"

    var location : LocationRecord
    var cellIds = [String]() // Ids also serve as title for cell
    var cellMap = [String:AnyClass]()
    
    init(locationViewController: LocationViewController, location: LocationRecord) {
        self.location = location
        self.locationViewController = locationViewController
        
        addCellType(id: "Time", cell: LabelValueCell.self)
        addCellType(id: "Name", cell: LabelValueCell.self)
        addCellType(id: "Address", cell: TitileSubtitleCell.self)
    }

    private func addCellType(id: String, cell: AnyClass){
        cellIds.append(id)
        cellMap[id] = cell
    }

    func cellAt(row: Int) -> UITableViewCell {
        let cellId = cellIds[row]
        let cell = locationViewController.tableView.dequeueReusableCell(withIdentifier: cellId)!
        switch cellId {
        case "Time":
            setupTimeCell(cell)
        case "Name":
            setupNameCell(cell)
        case "Address":
            setupAddressCell(cell)
        default:
            os_log("Unrecognized cell id in location detail section.", log: .default, type: .error)
        }
        return cell
    }
    
    private func setupTimeCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Time"
        cell.detailTextLabel?.text = location.getDateString()
    }
    
    private func setupNameCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Name"
        cell.detailTextLabel?.text = location.locationName
    }
    
    private func setupAddressCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Address"
        cell.detailTextLabel?.text = location.address
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.lineBreakMode = .byTruncatingTail
    }
}

class LocationPhotoSection : TableViewSection {
    var locationViewController: LocationViewController
    let sectionTitle = "Photo"
    
    var location : LocationRecord
    var cellIds = [String]() // Ids also serve as title for cell
    var cellMap = [String:AnyClass]()
    
    init(locationViewController: LocationViewController, location: LocationRecord) {
        self.location = location
        self.locationViewController = locationViewController

        addCellType(id: "Photo", cell: ImageCell.self)
    }
    
    private func addCellType(id: String, cell: AnyClass){
        cellIds.append(id)
        cellMap[id] = cell
    }
    
    func cellAt(row: Int) -> UITableViewCell {
        let cellId = cellIds[row]
        let cell = locationViewController.tableView.dequeueReusableCell(withIdentifier: cellId)!
        switch cellId {
        case "Photo":
            setupImageCell(cell)
        default:
            os_log("Unrecognized cell id in location photo section.", log: .default, type: .error)
        }
        return cell
    }
    
    private func setupImageCell(_ cell: UITableViewCell) {
        cell.imageView?.image = location.image
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: locationViewController, action: #selector(locationViewController.imageTapped(_:))))
        
        if let image = cell.imageView?.image {
            let width = UIScreen.main.bounds.width - 40
            let height = width * image.size.height / image.size.width
            cell.imageView?.widthAnchor.constraint(equalToConstant: width).isActive = true
            cell.imageView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

