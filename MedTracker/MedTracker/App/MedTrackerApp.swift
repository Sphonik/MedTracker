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
    
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView() 
        }
        .modelContainer(for: Medication.self)
    }
}
