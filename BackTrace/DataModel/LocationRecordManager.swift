//
//  LocationRecordManager.swift
//  BackTrace
//
//  Created by Yun Wu on 4/28/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import CoreLocation

// TODO: Implement sort by distance
class LocationRecordManager {
    static var locationIds = Set<String>()
    static var starredlocationIds = Set<String>()
    static var unstarredlocationIds = Set<String>()
    static var locations = [String: LocationRecord]() // locationId -> location record

    static let locationIdFile = "locations.json"
    static let locationPrefix = "locations_"

    static var currentLatitude: CLLocationDegrees = 0.0
    static var currentLongtitude: CLLocationDegrees = 0.0
    
    static private var sortedLocation = [LocationRecord]()
    static private var sortedStarredLocation = [LocationRecord]()
    static private var sortedUnstarredLocation = [LocationRecord]()
    static private var sortBy = sortMethod.time
    static private var locationReferenceChanged = true
    
    enum sortMethod {
        case time
        case distance
        case name
    }
    
    enum statusPresnetationType {
        case all
        case starred
        case unstarred
    }
    
    static func saveLocationIds() {
        Storage.store(locationIds, to: .documents, as: locationIdFile)
    }
    
    static func loadLocations() {
        if Storage.fileExists(locationIdFile, in: .documents) {
            locationIds = Storage.retrieve(locationIdFile, from: .documents, as: Set.self)
            for locationId in locationIds {
                let filePath = locationId.toLocationFileName()
                let loadedLocation = Storage.retrieve(filePath, from: .documents, as: LocationRecord.self)
                locations[locationId] = loadedLocation
                if loadedLocation.starred {
                    starredlocationIds.insert(locationId)
                } else {
                    unstarredlocationIds.insert(locationId)
                }
            }
            locationReferenceChanged = true
        }
    }
    
    static func addLocation(starred:Bool) -> String {
        let newId = currentTime()
        let newLocation = LocationRecord(id: newId, latitude: currentLatitude, longtitude: currentLongtitude, starred: starred)
        locationIds.insert(newId)
        locations[newId] = newLocation
        
        if newLocation.starred {
            starredlocationIds.insert(newId)
        } else {
            unstarredlocationIds.insert(newId)
        }
        
        saveLocationIds()
        Storage.store(newLocation, to: .documents, as: newId.toLocationFileName())
        
        locationReferenceChanged = true
        return newId
    }
    
    static func removeLocation(locationId:String) {
        locationIds.remove(locationId)
        starredlocationIds.remove(locationId)
        unstarredlocationIds.remove(locationId)
        
        locations.removeValue(forKey: locationId)
        
        saveLocationIds()
        Storage.remove(locationId.toLocationFileName(), from: .documents)
        
        locationReferenceChanged = true
    }
    
    static func updateLocation(locationId: String) {
        let location = locations[locationId]
        if location != nil && locationStarNeedsUpdate(locaiton: location!) {
            if location!.starred {
                starredlocationIds.insert(location!.locationId)
                unstarredlocationIds.remove(location!.locationId)
            } else {
                unstarredlocationIds.insert(location!.locationId)
                starredlocationIds.remove(location!.locationId)
            }
            locationReferenceChanged = true
        }
        Storage.store(location, to: .documents, as: locationId.toLocationFileName())
    }
    
    static private func locationStarNeedsUpdate (locaiton: LocationRecord) -> Bool {
        if locaiton.starred {
            return !starredlocationIds.contains(locaiton.locationId)
        } else {
            return !unstarredlocationIds.contains(locaiton.locationId)
        }
    }

    static func getLocation(index: Int, from: statusPresnetationType, sortBy: sortMethod) -> LocationRecord? {
        if index < 0 || index >= locations.count {
            return nil
        }
        
        if self.sortBy != sortBy || locationReferenceChanged {
            var locationArray = Array(locations.values)
            switch sortBy{
            case .time:
                locationArray.sort { (locationA, locationB) -> Bool in return locationA.date > locationB.date}
            case .name:
                locationArray.sort { (locationA, locationB) -> Bool in return locationA.locationName.count > 0 && locationA.locationName > locationB.locationName}
            case .distance:
                break
            }
            
            sortedLocation = locationArray
            sortedStarredLocation = [LocationRecord]()
            sortedUnstarredLocation = [LocationRecord]()
            for location in locationArray {
                if location.starred {
                    sortedStarredLocation.append(location)
                } else {
                    sortedUnstarredLocation.append(location)
                }
            }
            
            self.sortBy = sortBy
            locationReferenceChanged = false
        }
        
        switch from {
        case .all:
            return sortedLocation[index]
        case .starred:
            return sortedStarredLocation[index]
        case .unstarred:
            return sortedUnstarredLocation[index]
        }
    }
    
    private static func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Time zone independent index
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSSS"
        return formatter.string(from: Date())
    }
}

extension String {
    func toLocationFileName() -> String {
        return LocationRecordManager.locationPrefix + self + ".json"
    }
}
