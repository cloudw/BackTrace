//
//  DataSource.swift
//  BackTrace
//
//  Created by Yun Wu on 4/16/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import CoreLocation

class DataSource {
    static var journalIds = [String]()
    static var locationIds = [String]()
    
    static var journals = [String: Journal]() // id -> journal
    static var locations = [String: LocationRecord]() // locationId -> location record
    
    static let locationIdFile = "locations.json"
    static let locationPrefix = "locations_"
    static let journalIdFile = "journals.json"
    static let journalPrefix = "journal_"

    static var currentLatitude: CLLocationDegrees = 0.0
    static var currentLongtitude: CLLocationDegrees = 0.0
    
    // Locations
    static func saveLocationIds() {
        Storage.store(locationIds, to: .documents, as: locationIdFile)
    }
    
    static func loadLocations() {
        if Storage.fileExists(locationIdFile, in: .documents) {
            locationIds = Storage.retrieve(locationIdFile, from: .documents, as: [String].self)
            for locationId in locationIds {
                let filePath = locationId.toLocationFileName()
                locations[locationId] = Storage.retrieve(filePath, from: .documents, as: LocationRecord.self)
            }
        }
    }
    
    // Insert location record. Update file storage. Return ID.
    static func addLocation() -> String {
        let newId = currentTime()
        let newLocation = LocationRecord(id: newId, latitude: currentLatitude, longtitude: currentLongtitude)
        locationIds.insert(newId, at: 0)
        locations[newId] = newLocation
        
        saveLocationIds()
        Storage.store(newLocation, to: .documents, as: newId.toLocationFileName())
        
        return newId
    }
    
    static func removeLocation(index: Int) {
        let locationId = locationIds[index]
        locationIds.remove(at: index)
        locations.removeValue(forKey: locationId)
        
        saveLocationIds()
        Storage.remove(locationId.toLocationFileName(), from: .documents)
    }
    
    static func updateLocation(locationId: String) {
        let location = locations[locationId]
        Storage.store(location, to: .documents, as: locationId.toLocationFileName())
    }
    
    // Journals
    
    static func saveJournalIds() {
        Storage.store(journalIds, to: .documents, as: journalIdFile)
    }
    
    static func loadJournals() {
        if Storage.fileExists(journalIdFile, in: .documents) {
            journalIds = Storage.retrieve(journalIdFile, from: .documents, as: [String].self)
            for journalId in journalIds {
                let filePath = journalId.toJournalFileName()
                journals[journalId] = Storage.retrieve(filePath, from: .documents, as: Journal.self)
            }
        }
    }
    
    static func addJournal() -> String {
        let newId = currentTime()
        let newJournal = Journal(id: newId, date: Date(), title: "New Journal", summary: "- Empty -")
        journalIds.insert(newId, at: 0)
        journals[newId] = newJournal
        
        Storage.store(journalIds, to: .documents, as: journalIdFile)
        Storage.store(newJournal, to: .documents, as: newId.toJournalFileName())
        
        return newId
    }
    
    static func removeJournal(index: Int) {
        let journalId = journalIds[index]
        journalIds.remove(at: index)
        journals.removeValue(forKey: journalId)
        
        saveJournalIds()
        Storage.remove(journalId.toJournalFileName(), from: .documents)
    }
    
    static func updateJournal(journalId: String) {
        let journal = journals[journalId]
        Storage.store(journal, to: .documents, as: journalId.toJournalFileName())
    }
    
    // ID generator
    
    private static func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Time zone independent index
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSSS"
        return formatter.string(from: Date())
    }
}

extension String {
    func toLocationFileName() -> String {
        return DataSource.locationPrefix + self + ".json"
    }
    
    func toJournalFileName() -> String {
        return DataSource.journalPrefix + self + ".json"
    }

}

