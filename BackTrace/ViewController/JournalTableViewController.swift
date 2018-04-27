//
//  RecordViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class JournalCell : UITableViewCell {

    let recordImageView = UIImageView()
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let summaryLabel = UILabel()

    var record: Journal?
    var recordController : JournalTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupInteraction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        let textLeftMargin:CGFloat = 15
        let textTopMargin:CGFloat = 10

        self.backgroundColor = .white
        self.addSubview(recordImageView)
        self.addSubview(dateLabel)
        self.addSubview(titleLabel)
        self.addSubview(summaryLabel)
        
        recordImageView.backgroundColor = .gray
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recordImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recordImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: recordImageView.rightAnchor, constant: textLeftMargin).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textTopMargin).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: (self.frame.height / 3)).isActive = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: dateLabel.heightAnchor).isActive = true
        
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryLabel.numberOfLines = 4
        summaryLabel.textColor = .gray
        summaryLabel.font = UIFont.systemFont(ofSize: 15)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        summaryLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        summaryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textTopMargin).isActive = true
        
        self.contentView.layer.borderWidth = 0.5
    }
    
    private func setupInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pop_details))
        self.addGestureRecognizer(tap)
    }
    
    @objc func pop_details () {
        print("editing")
        if recordController != nil {
            recordController!.showRecordDetail(cell: self)
        }
    }
    
    func loadContend(journal: Journal){
        self.record = journal
        recordImageView.image = record?.image
        dateLabel.text = record?.getDateString()
        titleLabel.text = record?.title
        summaryLabel.text = record?.summary
    }
}

class JournalTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        for id in DataSource.journalIds {
            tableView.register(JournalCell.self, forCellReuseIdentifier: id)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJournal))
    }
    
    @objc private func addJournal() {
        let newId = DataSource.addJournal()
        tableView.register(JournalCell.self, forCellReuseIdentifier: newId)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.journals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = DataSource.journalIds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: id)!
        if let recordCell = cell as? JournalCell {
            recordCell.loadContend(journal: DataSource.journals[id]!)
            recordCell.recordController = self
        }
        return cell
    }
    
    func showRecordDetail(cell: JournalCell) {
        let detailController = JournalEditionController()
        detailController.loadRecord(record: cell.record!)

        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataSource.removeJournal(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
