//
//  TableViewSection.swift
//  BackTrace
//
//  Created by Yun Wu on 4/27/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

protocol TableViewSection {
    var sectionTitle : String { get }
    var cellIds : [String] { get set }
    var cellMap : [String:AnyClass] { get set }

    // Register
    func cellClassFor(id: String) -> AnyClass
    func cellIdentifierFor(row: Int) -> String

    // Display
    func numberOfRows() -> Int
    func cellAt(row: Int) -> UITableViewCell
}

extension TableViewSection {
    func numberOfRows() -> Int {
        return cellIds.count
    }
    
    func cellClassFor(id: String) -> AnyClass {
        return cellMap[id]!
    }
    
    func cellIdentifierFor(row: Int) -> String {
        return cellIds[row]
    }
}

protocol EditorTableViewSection {
    var sectionTitle : String { get }
    var cells : [UITableViewCell] { get set }
    
    func contentDidChange() -> Bool
    func saveContent()
    
    func numberOfRows() -> Int
    func cellAt(row: Int) -> UITableViewCell
}

extension EditorTableViewSection {
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cellAt(row: Int) -> UITableViewCell {
        return cells[row]
    }

}
