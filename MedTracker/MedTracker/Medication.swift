//
//  Medication.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import Foundation
import SwiftData

// Enum für die Auswahl-Logik. Codable ist wichtig für SwiftData.
enum Frequency: String, Codable, CaseIterable, Identifiable {
    case daily = "Täglich"
    case everyXDays = "Alle X Tage"
    case weekly = "Wöchentlich"
    case monthly = "Monatlich"
    case asNeeded = "Bei Bedarf"
    
    var id: String { self.rawValue }
}

@Model
class Medication {
    var id: UUID
    var name: String
    var dosage: String
    var notes: String
    var isActive: Bool
    var reminderTime: Date
    var frequency: Frequency
    var interval: Int // Wird nur genutzt, wenn frequency == .everyXDays
    
    init(name: String,
         dosage: String,
         notes: String = "",
         isActive: Bool = true,
         reminderTime: Date = Date(),
         frequency: Frequency = .daily,
         interval: Int = 1) {
        
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.notes = notes
        self.isActive = isActive
        self.reminderTime = reminderTime
        self.frequency = frequency
        self.interval = interval
    }
}
