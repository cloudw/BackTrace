//
//  TableCells.swift
//  BackTrace
//
//  Created by Yun Wu on 4/29/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//
//  Copyable label from https://stackoverflow.com/questions/1246198/show-iphone-cut-copy-paste-menu-on-uilabel
//  Answered by pableiros@StackOverflow

import UIKit

// Parent for all other TableViewCell in this file
// Define generic styles
class TitileContentCell : UITableViewCell {
    var copyEnabled = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textLabel?.textColor = .darkGray
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        detailTextLabel?.textColor = .black
        detailTextLabel?.lineBreakMode = .byWordWrapping
        detailTextLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableCopy() {
        self.copyEnabled = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    @objc func showMenu(sender: AnyObject?) {
        if copyEnabled {
            self.becomeFirstResponder()
            
            let menu = UIMenuController.shared
            
            if !menu.isMenuVisible {
                menu.setTargetRect(bounds, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = detailTextLabel?.text
        
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return copyEnabled
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}

class LabelValueCell : TitileContentCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        enableCopy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TitileSubtitleCell : TitileContentCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        enableCopy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageCell : TitileContentCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView?.leadingAnchor.constraintLessThanOrEqualToSystemSpacingAfter(contentView.leadingAnchor, multiplier: 2).isActive = true
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Disable highlight to avoid wierd image arrangement
    }
    
    override var canBecomeFirstResponder: Bool {
        return copyEnabled
    }
}

class JournalLocationCell : TitileContentCell {
    var location : LocationRecord?
    var journalViewController : JournalViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(){
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
    }

    override var canBecomeFirstResponder: Bool {
        return copyEnabled
    }
    
    @objc func showLocationDetail(){
        if location != nil {
            journalViewController?.showRecordDetail(location: location!)
        }
    }

    
}
