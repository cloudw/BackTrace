//
//  RecordViewController.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class RecordCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.backgroundColor = .gray
    }
}

class RecordViewController: UITableViewController {
    let id = "id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(RecordCell.self, forCellReuseIdentifier: id)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: id)!
    }
    
}
