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
            // 1. Uhrzeit anzeigen/ändern
            DatePicker("Erinnerungszeit", selection: $medication.reminderTime, displayedComponents: .hourAndMinute)
            
            // 2. Häufigkeit anzeigen/ändern (NEU HINZUGEFÜGT)
            Picker("Häufigkeit", selection: $medication.frequency) {
                ForEach(Frequency.allCases) { freq in
                    Text(freq.rawValue).tag(freq)
                }
            }
            
            // 3. Intervall anzeigen, falls nötig (NEU HINZUGEFÜGT)
            if medication.frequency == .everyXDays {
                Stepper("Alle \(medication.interval) Tage", value: $medication.interval, in: 2...365)
            }
        }
    }
    
    private var notesSection: some View {
        Section("Notizen") {
            // Hier nutzen wir TextEditor, damit man Notizen auch ändern kann
            TextEditor(text: $medication.notes)
                .frame(height: 100)
            
            if medication.notes.isEmpty {
                Text("Keine Notizen hinterlegt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
