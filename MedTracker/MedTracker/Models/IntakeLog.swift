//
//  IntakeLog.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import Foundation
import SwiftData

@Model
class IntakeLog {
    var date: Date
    
    // Beziehung zurück zum Medikament
    var medication: Medication?
    
    init(date: Date = Date()) {
        self.date = date
    }
}
