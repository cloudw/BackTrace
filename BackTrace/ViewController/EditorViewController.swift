//
//  EditorViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/22/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class EditorViewController : UITableViewController  {
    let imageView = UIImageView()
    let photoPicker = PhotoPicker()

    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sections = [EditorTableViewSection]()

    override func viewDidLoad() {
        setupView()
        setupInteraction()
    }

    private func setupView() {
        title = "Edit"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupInteraction() {
        let saveEditButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonAction))
        navigationItem.rightBarButtonItem = saveEditButton

        if tabBarController != nil {
            self.photoPicker.setup(currentVC: tabBarController!, targetImageView: self.imageView)
        } else if navigationController != nil {
            self.photoPicker.setup(currentVC: navigationController!, targetImageView: self.imageView)
        } else {
            self.photoPicker.setup(currentVC: self, targetImageView: self.imageView)
        }

        let tap = UITapGestureRecognizer(target: self.photoPicker, action: #selector(self.photoPicker.addImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }

    // Storage Interaction and Manage

    @objc func saveButtonAction() {
        if contentDidChange() {
            showConfirmationAlert(title: "Save edition?", message: nil, yes: recordEdition, no: nil)
        }
    }

    func loadRecord(record: AnyObject) {
        preconditionFailure("Must be overriden by children")
    }

    func contentDidChange() -> Bool {
        for section in sections {
            if section.contentDidChange() {
                return true
            }
        }
        return false
    }

    func recordEdition() {
        preconditionFailure("Must be overriden by children")
    }

    private func showConfirmationAlert(title: String?, message: String?, yes: (() -> Void)? , no: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let no = UIAlertAction(title: "No", style: .cancel) { action -> Void in no?() }
        let yes = UIAlertAction(title: "Yes", style: .default) { action -> Void in yes?() }
        alertController.addAction(no)
        alertController.addAction(yes)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // TableViewController Overrides

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cellAt(row: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].heightFor(row: indexPath.row)
    }
}

