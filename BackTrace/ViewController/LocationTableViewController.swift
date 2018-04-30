//
//  RecordViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/15/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    let deleteAllButton = UIBarButtonItem(title: "Remove All", style: .plain, target: nil, action: nil)
    var locationTypePresented = LocationRecordManager.statusPresnetationType.all
    let segControl = UISegmentedControl(items: ["All", " ✓ ", " ? "])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        for id in LocationRecordManager.locationIds {
            tableView.register(LocationCell.self, forCellReuseIdentifier: id)
        }
        setupInteraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
    }
    
    private func setupInteraction() {
        deleteAllButton.target = self
        deleteAllButton.action = #selector(removeAllUnstarred)
        deleteAllButton.isEnabled = false
        navigationItem.leftBarButtonItem = deleteAllButton
        
        segControl.selectedSegmentIndex = 0
        segControl.frame = CGRect(x: 0, y: 0, width: segControl.frame.width+50, height: segControl.frame.height)
        segControl.addTarget(self, action: #selector(locationCategoryChanged), for: .valueChanged)
        navigationItem.titleView = segControl
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationWithButton))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func removeAllUnstarred() {
        print("Removing!")
        
        let alertController = UIAlertController(title: nil, message: "Remove all non-starred location record", preferredStyle: UIAlertControllerStyle.alert)
        
        let no = UIAlertAction(title: "No", style: .cancel) { _ in }
        let yes = UIAlertAction(title: "Yes", style: .destructive) { action -> Void in
            while self.tableView.numberOfRows(inSection: 0) > 0 && self.locationTypePresented == .unstarred {
                self.removeRowAndDataAt(row: 0)
            }
        }
        alertController.addAction(no)
        alertController.addAction(yes)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func locationCategoryChanged() {
        switch segControl.selectedSegmentIndex{
        case 0:
            locationTypePresented = .all
        case 1:
            locationTypePresented = .starred
        case 2:
            locationTypePresented = .unstarred
        default:
            print("Unrecognized location starring status")
            return
        }
        
        if locationTypePresented == .unstarred {
            deleteAllButton.isEnabled = true
        } else {
            deleteAllButton.isEnabled = false
        }
    
        tableView.reloadData()
    }
    
    @objc func addLocationWithButton() {
        self.addLocation(starred: true)
    }
    
    func addLocation(starred:Bool) {
        if segControl.selectedSegmentIndex != 0 { // Show inserted row
            segControl.selectedSegmentIndex = 0
            locationCategoryChanged()
            tableView.endUpdates()
        }
        
        let newId = LocationRecordManager.addLocation(starred: starred)
        tableView.register(LocationCell.self, forCellReuseIdentifier: newId)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch locationTypePresented {
        case .all:
            return LocationRecordManager.locationIds.count
        case .starred:
            return LocationRecordManager.starredlocationIds.count
        case .unstarred:
            return LocationRecordManager.unstarredlocationIds.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = LocationRecordManager.getLocation(index: indexPath.row, from: locationTypePresented, sortBy: .time)!
        let cell = tableView.dequeueReusableCell(withIdentifier: location.locationId)!
        if let recordCell = cell as? LocationCell {
            recordCell.loadContend(record: location)
            recordCell.recordController = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)
            if let locationCell = cell as? LocationCell {
                let location = locationCell.record
                if !(location!.starred) { // Non-starred location record get directly deleted
                    LocationRecordManager.removeLocation(locationId: location!.locationId)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    return
                }
            }
            
            showDeleteConfirmation(indexPath: indexPath)
        }
    }
    
    func removeRowAndDataAt(row: Int){
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
        if let locationCell = cell as? LocationCell {
            let location = locationCell.record
            LocationRecordManager.removeLocation(locationId: location!.locationId)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showRecordDetail(cell: LocationCell) {
        let detailController = LocationViewController()
        detailController.loadLocationRecord(location: cell.record!)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    private func showDeleteConfirmation(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete Starred Location Record", message: "This action cannot be undo.", preferredStyle: UIAlertControllerStyle.alert)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { deleteAction in
            self.removeRowAndDataAt(row: indexPath.row)
        }
        alertController.addAction(no)
        alertController.addAction(yes)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

class LocationCell: UITableViewCell {
    let recordImageView = UIImageView()
    let locationLabel = UILabel()
    let dateLabel = UILabel()
    let starButton = UIButton()
    
    var record: LocationRecord?
    var recordController: LocationTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        record = nil
        recordController = nil
        
        setupView()
        setupInteraction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        let textSideMargin:CGFloat = 15
        let textTopMargin:CGFloat = 10
        
        self.backgroundColor = .white
        self.addSubview(recordImageView)
        self.addSubview(dateLabel)
        self.addSubview(locationLabel)
        self.addSubview(starButton)
        
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        starButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        starButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        starButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        starButton.setTitleColor(.yellow, for: .normal)
        starButton.setTitleColor(.yellow, for: .selected)

        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recordImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recordImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.backgroundColor = .white
        recordImageView.contentMode = .scaleAspectFill
        recordImageView.clipsToBounds = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: recordImageView.trailingAnchor, constant: textSideMargin).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textTopMargin).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: (self.frame.height / 2)).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: textTopMargin).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        locationLabel.lineBreakMode = .byTruncatingTail
        locationLabel.numberOfLines = 2
    }
    
    private func setupInteraction() {
        let cellTapped = UITapGestureRecognizer(target: self, action: #selector(self.pop_details))
        self.addGestureRecognizer(cellTapped)
        
        starButton.addTarget(self, action: #selector(invertStar), for: .touchDown)
    }
    
    @objc private func pop_details () {
        if recordController != nil {
            recordController!.showRecordDetail(cell: self)
        }
    }
    
    @objc func invertStar() {
        if record != nil {
            record!.starred = !(record!.starred)
            
            let tempImg = starButton.image(for: .normal)
            starButton.setImage(starButton.image(for: .selected), for: .normal)
            starButton.setImage(tempImg, for: .selected)
            
            LocationRecordManager.updateLocation(locationId: record!.locationId)
        }
    }
    
    func loadContend(record: LocationRecord){
        self.record = record
        recordImageView.image = record.image
        dateLabel.text = record.getDateString()
        locationLabel.text = record.locationName
        
        if record.starred {
            starButton.setImage(#imageLiteral(resourceName: "star-filled"), for: .normal)
            starButton.setImage(#imageLiteral(resourceName: "star"), for: .selected)
        } else {
            starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            starButton.setImage(#imageLiteral(resourceName: "star-filled"), for: .selected)
        }
    }
}
