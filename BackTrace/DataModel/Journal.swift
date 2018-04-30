//
//  DayRecord.swift
//  BackTrace
//
//  Created by Yun Wu on 4/9/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit

class Journal : Codable {
    let journalId : String
    var image : UIImage?
    var date : Date
    var title : String
    var summary : String
    var locationIds : [String]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case image
        case date
        case title
        case summary
        case locationIds
    }
    
    init(id: String, date: Date, title: String, summary: String) {
        self.journalId = id
        self.image = #imageLiteral(resourceName: "add_image")
        self.date = date
        self.title = title
        self.summary = summary
        self.locationIds = []
    }
    
    init(id: String, date: Date, title: String, summary: String, locationIds:[String], image: UIImage?) {
        self.journalId = id
        self.date = date
        self.title = title
        self.summary = summary
        self.locationIds = locationIds
        self.image = image
    }
    
    func addLocation(location: LocationRecord){
        self.locationIds.append(location.locationId)
    }
    
    func getDateStringShort() -> String {
        let formatter = DateFormatter()
        let weekStr = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        formatter.dateFormat = "MM/dd/yyyy"
        return weekStr + ", " + formatter.string(from: date)
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        let weekStr = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        formatter.dateFormat = "MM/dd/yyyy hh:mm"
        return weekStr + ", " + formatter.string(from: date)
    }
    
    // Referenced image encoding: https://stackoverflow.com/questions/46197785/how-to-conform-uiimage-to-codable
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let journalId = try! container.decode(String.self, forKey: CodingKeys.id)
        let date = try! container.decode(Date.self, forKey: CodingKeys.date)
        let title = try! container.decode(String.self, forKey: CodingKeys.title)
        let summary = try! container.decode(String.self, forKey: CodingKeys.summary)
        let locationIds = try! container.decode([String].self, forKey: CodingKeys.locationIds)
        
        if container.contains(CodingKeys.image) {
            let data = try container.decode(Data.self, forKey: CodingKeys.image)
            guard let image = UIImage(data: data) else {
                print("Fail to decode image")
                self.init(id: journalId, date: date, title: title, summary: summary, locationIds: locationIds, image: nil)
                return
            }
            self.init(id: journalId, date: date, title: title, summary: summary, locationIds: locationIds, image: image)
        } else {
            self.init(id: journalId, date: date, title: title, summary: summary, locationIds: locationIds, image: nil)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(journalId, forKey: CodingKeys.id)
        try! container.encode(date, forKey: CodingKeys.date)
        try! container.encode(title, forKey: CodingKeys.title)
        try! container.encode(summary, forKey: CodingKeys.summary)
        try! container.encode(locationIds, forKey: CodingKeys.locationIds)
        
        if image != nil {
            guard let data = UIImagePNGRepresentation(image!) else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
}
