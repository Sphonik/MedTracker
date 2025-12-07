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
    @State private var selectedImage: UIImage?
    @State private var dosage = ""
    @State private var notes = ""
    @State private var reminderTime = Date()
    @State private var isActive = true
    @State private var frequency: Frequency = .daily
    @State private var interval: Int = 1
    
    var body: some View {
        NavigationStack {
            Form {
                Section  {
                    HStack {
                        Spacer()
                        MedicationImageButton(selectedImage: $selectedImage)
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
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
            Toggle("Erinnerung aktiv", isOn: $isActive)

            if isActive {
                DatePicker("Uhrzeit", selection: $reminderTime, displayedComponents: .hourAndMinute)

                Picker("Häufigkeit", selection: $frequency) {
                    ForEach(Frequency.allCases) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }

                // Bedingte Anzeige: Nur wenn "Alle X Tage" gewählt ist
                if frequency == .everyXDays {
                    Stepper("Alle \(interval) Tage", value: $interval, in: 2...365)
                }
            }
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
            
            let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
            
            let newMedication = Medication(
                name: name,
                dosage: dosage,
                notes: notes,
                isActive: isActive,
                reminderTime: reminderTime,
                frequency: frequency,
                interval: interval,
                imageData: imageData 
            )
            
            modelContext.insert(newMedication)
            NotificationManager.shared.scheduleNotification(for: newMedication)
            dismiss()
        }
}
