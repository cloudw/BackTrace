//
//  LocationRecord.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import Foundation

class LocationRecord {
    let latitude:Float
    let longtitude:Float
    let time:Date
    
    init(latitude:Float, longtitude:Float) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.time = Date()
    }
    
    init(latitude:Float, longtitude:Float, time:Date) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.time = time
    }
    
}
