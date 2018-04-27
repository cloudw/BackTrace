//
//  RecordViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/15/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    let recordImageView = UIImageView()
    let locationLabel = UILabel()
    let dateLabel = UILabel()
    
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
        
        recordImageView.backgroundColor = .gray
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recordImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recordImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: recordImageView.rightAnchor, constant: textSideMargin).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textTopMargin).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: (self.frame.height / 2)).isActive = true
        
        locationLabel.lineBreakMode = .byTruncatingTail
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: textTopMargin).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.contentView.layer.borderWidth = 0.5
    }
    
    private func setupInteraction() {
        let cellTapped = UITapGestureRecognizer(target: self, action: #selector(self.pop_details))
        self.addGestureRecognizer(cellTapped)
    }
    
    @objc private func pop_details () {
        if recordController != nil {
            recordController!.showRecordDetail(cell: self)
        }
    }
    
    func loadContend(record: LocationRecord){
        self.record = record
        recordImageView.image = record.image
        dateLabel.text = record.getDateString()
        locationLabel.text = record.locationName
    }
}

class LocationTableViewController: UITableViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        for id in DataSource.locationIds {
            tableView.register(LocationCell.self, forCellReuseIdentifier: id)
        }
        
        setupInteraction()
    }
    
    private func setupInteraction() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
    }
    
    @objc func addLocation() {
        let newId = DataSource.addLocation()
        tableView.register(LocationCell.self, forCellReuseIdentifier: newId)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.locationIds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = DataSource.locationIds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: id)!
        if let recordCell = cell as? LocationCell {
            recordCell.loadContend(record: DataSource.locations[id]!)
            recordCell.recordController = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataSource.removeLocation(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showRecordDetail(cell: LocationCell) {
        let detailController = LocationEditionController()
        detailController.loadRecord(record: cell.record!)

        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
