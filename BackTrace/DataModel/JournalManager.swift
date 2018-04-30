//
//  DataSource.swift
//  BackTrace
//
//  Created by Yun Wu on 4/16/18.
//  Copyright © 2018 Yun Wu. All rights reserved.
//

import UIKit
import CoreLocation

class JournalManager {
    static var journalIds = [String]()
    static var journals = [String: Journal]() // id -> journal

    
    static let journalIdFile = "journals.json"
    static let journalPrefix = "journal_"
    
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
    func toJournalFileName() -> String {
        return JournalManager.journalPrefix + self + ".json"
    }
}

