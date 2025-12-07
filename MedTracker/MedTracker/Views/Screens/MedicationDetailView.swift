import SwiftUI
import SwiftData

struct MedicationDetailView: View {
    // Dependencies
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Daten
    let medication: Medication
    
    // Working Copy (State)
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var notes: String = ""
    @State private var isActive: Bool = true
    @State private var reminderTime: Date = Date()
    @State private var frequency: Frequency = .daily
    @State private var interval: Int = 1
    @State private var selectedImage: UIImage?
    @State private var justTakenAnimation = false
    
    // UI State
    @State private var showDeleteConfirmation = false
    @State private var showUnsavedChangesAlert = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    MedicationImageButton(selectedImage: $selectedImage)
                    Spacer ()
                    
                }
            }
            .listRowBackground(Color.clear)
            actionSection
            detailsSection
            scheduleSection
            notesSection
            historySection
            settingsSection
            deleteSection
        }
        .navigationTitle(name.isEmpty ? "Details" : name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 2. Eigener Zurück-Button
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .confirmationAction) {
                saveButton
            }
        }
        .onAppear { loadData() }
        // 3. Alert für ungespeicherte Änderungen
        .alert("Änderungen speichern?", isPresented: $showUnsavedChangesAlert) {
            Button("Speichern") { saveChanges() }
            Button("Verwerfen", role: .destructive) { dismiss() }
            Button("Abbrechen", role: .cancel) { }
        } message: {
            Text("Du hast ungespeicherte Änderungen. Möchtest du diese speichern, bevor du gehst?")
        }
        // Alert für Löschen
        .alert("Medikament löschen?", isPresented: $showDeleteConfirmation) {
            Button("Löschen", role: .destructive) { deleteMedication() }
            Button("Abbrechen", role: .cancel) { }
        }
    }
    
    // MARK: - Logic Helpers
    
    private func logIntake() {
            let log = IntakeLog()
            medication.logs.append(log)
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            dismiss()
        }
    
    
    private var hasChanges: Bool {
        name != medication.name ||
        dosage != medication.dosage ||
        notes != medication.notes ||
        isActive != medication.isActive ||
        frequency != medication.frequency ||
        interval != medication.interval ||
        reminderTime.compare(medication.reminderTime) != .orderedSame || // Hier fehlte das ||
        selectedImage?.jpegData(compressionQuality: 0.8) != medication.imageData
    }
    
    // MARK: - View Components
    
    private var actionSection: some View {
            Section {
                if medication.isTakenToday {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                        Text("Heute bereits eingenommen")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Button(action: logIntake) {
                        HStack {
                            Spacer()
                            Text("Jetzt einnehmen")
                                .font(.headline)
                            Image(systemName: "pills.fill")
                            Spacer()
                        }
                    }
                    .tint(.blue)
                    .listRowBackground(Color.blue.opacity(0.1)) // Leicht blauer Hintergrund
                }
            }
        }
    
    private var historySection: some View {
            Section("Verlauf") {
                if medication.logs.isEmpty {
                    Text("Noch keine Einnahmen")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    // Wir zeigen nur die letzten 5 Einträge, um die Liste nicht zu sprengen
                    ForEach(medication.sortedHistory.prefix(5)) { log in
                        HStack {
                            Text(log.date.formatted(date: .abbreviated, time: .shortened))
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
    
    private var backButton: some View {
        Button(action: handleBackPress) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .fontWeight(.semibold)
                Text("MedTracker")
            }
        }
    }
    
    private var saveButton: some View {
        Button("Speichern") {
            saveChanges()
        }
        .disabled(!hasChanges || name.trimmingCharacters(in: .whitespaces).isEmpty)
    }
    
    private var detailsSection: some View {
        Section("Details") {
            TextField("Name", text: $name)
            TextField("Dosierung", text: $dosage)
        }
    }
    
    private var scheduleSection: some View {
        Section("Zeitplan") {
            DatePicker("Erinnerungszeit", selection: $reminderTime, displayedComponents: .hourAndMinute)
            Picker("Häufigkeit", selection: $frequency) {
                ForEach(Frequency.allCases) { freq in
                    Text(freq.rawValue).tag(freq)
                }
            }
            if frequency == .everyXDays {
                Stepper("Alle \(interval) Tage", value: $interval, in: 2...365)
            }
        }
    }
    
    private var notesSection: some View {
        Section("Notizen") {
            TextEditor(text: $notes)
                .frame(height: 100)
        }
    }
    
    private var settingsSection: some View {
        Section("Einstellungen") {
            Toggle("Erinnerung aktiv", isOn: $isActive)
                .tint(.blue)
        }
    }
    
    private var deleteSection: some View {
        Section {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                HStack {
                    Spacer()
                    Text("Medikament löschen")
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func handleBackPress() {
        if hasChanges {
            showUnsavedChangesAlert = true
        } else {
            dismiss()
        }
    }
    
    private func loadData() {
            self.name = medication.name
            self.dosage = medication.dosage
            self.notes = medication.notes
            self.isActive = medication.isActive
            self.reminderTime = medication.reminderTime
            self.frequency = medication.frequency
            self.interval = medication.interval
            
            if let data = medication.imageData {
                self.selectedImage = UIImage(data: data)
            }
        }
    
    private func saveChanges() {
            medication.name = name
            medication.dosage = dosage
            medication.notes = notes
            medication.isActive = isActive
            medication.reminderTime = reminderTime
            medication.frequency = frequency
            medication.interval = interval
            medication.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
            NotificationManager.shared.scheduleNotification(for: medication)
            dismiss()
        }
    
    private func deleteMedication() {
        NotificationManager.shared.cancelNotification(for: medication)
        modelContext.delete(medication)
        dismiss()
    }
}
