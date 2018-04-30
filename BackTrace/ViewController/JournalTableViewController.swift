//
//  RecordViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        for id in JournalManager.journalIds {
            tableView.register(JournalCell.self, forCellReuseIdentifier: id)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJournal))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillAppear(animated)
    }
    
    @objc private func addJournal() {
        let newId = JournalManager.addJournal()
        tableView.register(JournalCell.self, forCellReuseIdentifier: newId)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalManager.journals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = JournalManager.journalIds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: id)!
        if let recordCell = cell as? JournalCell {
            recordCell.loadContend(journal: JournalManager.journals[id]!)
            recordCell.recordController = self
        }
        return cell
    }
    
    func showRecordDetail(cell: JournalCell) {
        let detailController = JournalViewController()
        detailController.loadLocationRecord(journal: cell.record!)
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    private func deleteJournalAt(indexPath: IndexPath){
        JournalManager.removeJournal(index: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmation(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    private func showDeleteConfirmation(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete Journal", message: "This action cannot be undo.", preferredStyle: UIAlertControllerStyle.alert)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { deleteAction in
            self.deleteJournalAt(indexPath: indexPath)
        }
        alertController.addAction(no)
        alertController.addAction(yes)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

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
        self.backgroundColor = .white
        self.addSubview(recordImageView)
        self.addSubview(dateLabel)
        self.addSubview(titleLabel)
        self.addSubview(summaryLabel)
        
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        recordImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recordImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        recordImageView.backgroundColor = .white
        recordImageView.clipsToBounds = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(recordImageView.trailingAnchor, multiplier: 1).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.lineBreakMode = .byTruncatingTail

        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.topAnchor.constraintEqualToSystemSpacingBelow(titleLabel.bottomAnchor, multiplier: 1).isActive = true
        summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryLabel.numberOfLines = 4
        summaryLabel.textColor = .gray
        summaryLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func setupInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pop_details))
        self.addGestureRecognizer(tap)
    }
    
    @objc func pop_details () {
        if recordController != nil {
            recordController!.showRecordDetail(cell: self)
        }
    }
    
    func loadContend(journal: Journal){
        self.record = journal
        recordImageView.image = record?.image
        dateLabel.text = record?.getDateStringShort()
        titleLabel.text = record?.title
        summaryLabel.text = record?.summary
    }
}
