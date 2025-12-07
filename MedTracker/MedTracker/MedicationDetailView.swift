//
//  MedicationDetailView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI
import SwiftData

struct MedicationDetailView: View {
    @Bindable var medication: Medication
    
    var body: some View {
        Form {
            headerSection
            scheduleSection
            notesSection
            settingsSection
        }
        .navigationTitle(medication.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        Section {
            HStack {
                Text("Dosierung")
                Spacer()
                Text(medication.dosage)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var scheduleSection: some View {
        Section("Zeitplan") {
            HStack {
                Text("Erinnerungszeit")
                Spacer()
                Text(medication.reminderTime.formatted(date: .omitted, time: .shortened))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var notesSection: some View {
        Section("Notizen") {
            if medication.notes.isEmpty {
                Text("Keine Notizen vorhanden")
                    .foregroundStyle(.tertiary)
                    .italic()
            } else {
                Text(medication.notes)
            }
        }
    }
    
    private var settingsSection: some View {
        Section("Einstellungen") {
            Toggle("Erinnerung aktiv", isOn: $medication.isActive)
                .tint(.blue)
        }
    }
}
