//
//  TextField.swift
//  BackTrace
//
//  Created by Yun Wu on 4/21/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class TextField: UITextField {
    var xOffSet:CGFloat = 10
    var yOffSet:CGFloat = 10

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return bounds.insetBy(dx: xOffSet, dy: yOffSet)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return bounds.insetBy(dx: xOffSet, dy: yOffSet)
    }
}
