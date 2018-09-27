//
//  EditorViewSection.swift
//  BackTrace
//
//  Created by Yun Wu on 6/3/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

protocol EditorTableViewSection {
    var sectionTitle : String { get }
    var cells : [UITableViewCell] { get set }
    
    // Required methods
    func contentDidChange() -> Bool
    func saveContent()
    
    // Optional methods with default implementation
    func numberOfRows() -> Int
    func cellAt(row: Int) -> UITableViewCell
    func heightFor(row: Int) -> CGFloat
    func tableView(didSelectRowAt: IndexPath)
}

extension EditorTableViewSection {
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cellAt(row: Int) -> UITableViewCell {
        return cells[row]
    }
    
    func heightFor(row: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(didSelectRowAt: IndexPath){
        return
    }
}
