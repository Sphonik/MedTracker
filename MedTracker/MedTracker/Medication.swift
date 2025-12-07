//
//  Medication.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import Foundation
import SwiftData

@Model
class Medication {
    var id: UUID
    var name: String
    var dosage: String
    var notes: String
    var isActive: Bool
    var reminderTime: Date
    
    // Initializer zum Erstellen neuer Einträge
    init(name: String, dosage: String, notes: String = "", isActive: Bool = true, reminderTime: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.notes = notes
        self.isActive = isActive
        self.reminderTime = reminderTime
    }
}
