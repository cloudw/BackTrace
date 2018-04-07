//
//  Display.swift
//  BackTrace
//
//  Created by Yun Wu on 3/26/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    // https://stackoverflow.com/questions/13505379/adding-rounded-corner-and-drop-shadow-to-uicollectionviewcell
    func addShadow(){
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

extension String {
    // height estimation: https://www.youtube.com/watch?v=TEMUOaamcDA&index=6&list=PL0dzCUj1L5JE1wErjzEyVqlvx92VN3DL5
    func heightEstimation(width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: 2000)
        let attribute = [NSAttributedStringKey.font: font]
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return estimatedFrame.height
    }
}
