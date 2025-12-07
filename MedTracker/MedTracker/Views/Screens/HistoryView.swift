//
//  HistoryView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query(sort: \IntakeLog.date, order: .reverse) private var logs: [IntakeLog]
    
    var body: some View {
        NavigationStack {
            List {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "Keine Einnahmen",
                        systemImage: "calendar.badge.clock",
                        description: Text("Bestätigte Einnahmen erscheinen hier.")
                    )
                } else {
                    ForEach(logs) { log in
                        HStack {
                            // Linke Seite: Medikamenten Info
                            VStack(alignment: .leading) {
                                // Falls das Medikament gelöscht wurde, Fallback
                                Text(log.medication?.name ?? "Unbekanntes Medikament")
                                    .font(.headline)
                                Text(log.medication?.dosage ?? "--")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            // Rechte Seite: Zeitstempel
                            VStack(alignment: .trailing) {
                                Text(log.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.subheadline)
                                Text(log.date.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    .onDelete(perform: deleteLog)
                }
            }
            .navigationTitle("Verlauf")
        }
    }
    
    // Dependencies
    @Environment(\.modelContext) private var modelContext
    
    private func deleteLog(at offsets: IndexSet) {
        for index in offsets {
            let logToDelete = logs[index]
            modelContext.delete(logToDelete)
        }
    }
}
