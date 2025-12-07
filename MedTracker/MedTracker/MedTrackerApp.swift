//
//  MedTrackerApp.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI
import SwiftData

@main
struct MedTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MedicationListView()
        }
        .modelContainer(for: Medication.self)
    }
}
