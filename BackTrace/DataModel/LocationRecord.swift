//
//  LocationRecord.swift
//  BackTrace
//
//  Created by Yun Wu on 4/7/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class LocationRecord : Codable {
    let locationId:String
    var image:UIImage?
    var latitude:Double
    var longtitude:Double
    var locationName:String
    var address:String?
    var date:Date
    var starred:Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case image
        case latitude
        case longtitude
        case locationName
        case address
        case date
        case starred
    }
    
    init(id: String, latitude:Double, longtitude:Double, starred:Bool) {
        self.locationId = id
        self.image = #imageLiteral(resourceName: "add_image")
        self.latitude = latitude
        self.longtitude = longtitude
        self.locationName = "New Location"
        self.date = Date()
        self.starred = starred
    }
    
    init(id: String, latitude:Double, longtitude:Double, date:Date, locationName: String, address:String?, image:UIImage?, starred:Bool) {
        self.locationId = id
        self.image = image
        self.latitude = latitude
        self.longtitude = longtitude
        self.locationName = locationName
        self.address = address
        self.date = date
        self.starred = starred
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
        return formatter.string(from: date)
    }
    
    // Referenced image encoding: https://stackoverflow.com/questions/46197785/how-to-conform-uiimage-to-codable
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try! container.decode(String.self, forKey: CodingKeys.id)
        let latitude = try! container.decode(Double.self, forKey: CodingKeys.latitude)
        let longtitude = try! container.decode(Double.self, forKey: CodingKeys.longtitude)
        let date = try! container.decode(Date.self, forKey: CodingKeys.date)
        let locationName = try! container.decode(String.self, forKey: CodingKeys.locationName)
        
        var address:String? = nil
        if container.contains(CodingKeys.address) {
            address = try! container.decode(String.self, forKey: CodingKeys.address)
        }
        
        var starred = false
        if container.contains(CodingKeys.starred) {
            starred = try! container.decode(Bool.self, forKey: CodingKeys.starred)
        }
        
        if container.contains(CodingKeys.image) {
            let data = try container.decode(Data.self, forKey: CodingKeys.image)
            guard let image = UIImage(data: data) else {
                print("No image decoded")
                self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, address: address, image: nil, starred: starred)
                return
            }
            self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, address: address, image: image, starred: starred)
        } else {
            self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, address: address, image: nil, starred: starred)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(locationId, forKey: CodingKeys.id)
        try! container.encode(latitude, forKey: CodingKeys.latitude)
        try! container.encode(longtitude, forKey: CodingKeys.longtitude)
        try! container.encode(date, forKey: CodingKeys.date)
        try! container.encode(locationName, forKey: CodingKeys.locationName)
        try! container.encode(starred, forKey: CodingKeys.starred)
        
        if address != nil {
            try! container.encode(address, forKey: CodingKeys.address)
        }
        
        if image != nil {
            guard let data = UIImagePNGRepresentation(image!) else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
}
