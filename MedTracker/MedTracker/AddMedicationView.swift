//
//  AddMedicationView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI

struct AddMedicationView: View {
    // Dependencies
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Form State
    @State private var name = ""
    @State private var dosage = ""
    @State private var notes = ""
    @State private var reminderTime = Date()
    @State private var isActive = true
    
    var body: some View {
        NavigationStack {
            Form {
                detailsSection
                scheduleSection
                notesSection
            }
            .navigationTitle("Neues Medikament")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var detailsSection: some View {
        Section("Details") {
            TextField("Name des Medikaments", text: $name)
                .textInputAutocapitalization(.words)
            
            TextField("Dosierung (z.B. 50mg)", text: $dosage)
        }
    }
    
    private var scheduleSection: some View {
        Section("Zeitplan") {
            DatePicker("Einnahmezeit", selection: $reminderTime, displayedComponents: .hourAndMinute)
            Toggle("Erinnerung aktiv", isOn: $isActive)
        }
    }
    
    private var notesSection: some View {
        Section("Notizen") {
            TextEditor(text: $notes)
                .frame(height: 100)
        }
    }
    
    private var cancelButton: some View {
        Button("Abbrechen") {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Speichern") {
            saveMedication()
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Logic
    
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !dosage.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveMedication() {
        let newMedication = Medication(
            name: name,
            dosage: dosage,
            notes: notes,
            isActive: isActive,
            reminderTime: reminderTime
        )
        
        modelContext.insert(newMedication)
        dismiss()
    }
}
