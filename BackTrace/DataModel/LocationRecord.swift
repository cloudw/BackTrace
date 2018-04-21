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
    var date:Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case image
        case latitude
        case longtitude
        case locationName
        case date
    }
    
    init(id: String, latitude:Double, longtitude:Double) {
        self.locationId = id
        self.image = #imageLiteral(resourceName: "add_image")
        self.latitude = latitude
        self.longtitude = longtitude
        self.locationName = "(" + String(latitude) + ", " + String(longtitude) + ")"
        self.date = Date()
    }
    
    init(id: String, latitude:Double, longtitude:Double, date:Date, locationName: String, image:UIImage?) {
        self.locationId = id
        self.image = image
        self.latitude = latitude
        self.longtitude = longtitude
        self.locationName = locationName
        self.date = date
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
        
        if container.contains(CodingKeys.image) {
            let data = try container.decode(Data.self, forKey: CodingKeys.image)
            guard let image = UIImage(data: data) else {
                print("No image decoded")
                self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, image: nil)
                return
            }
            self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, image: image)
        } else {
            self.init(id: id, latitude: latitude, longtitude: longtitude, date:date, locationName: locationName, image: nil)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(locationId, forKey: CodingKeys.id)
        try! container.encode(latitude, forKey: CodingKeys.latitude)
        try! container.encode(longtitude, forKey: CodingKeys.longtitude)
        try! container.encode(date, forKey: CodingKeys.date)
        try! container.encode(locationName, forKey: CodingKeys.locationName)
        
        if image != nil {
            guard let data = UIImagePNGRepresentation(image!) else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
}
