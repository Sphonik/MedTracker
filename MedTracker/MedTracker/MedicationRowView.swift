//
//  MedicationRowView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI

struct MedicationRowView: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(medication.name)
                    .font(.headline)
                Spacer()
                // Zeigt z.B. "08:00" an
                if medication.isActive {
                    Text(medication.reminderTime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            
            HStack {
                Text(medication.dosage)
                Text("•")
                Text(scheduleDescription)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    // Computed Property für sauberen Text
    private var scheduleDescription: String {
        if !medication.isActive { return "Pausiert" }
        
        switch medication.frequency {
        case .everyXDays:
            return "Alle \(medication.interval) Tage"
        default:
            return medication.frequency.rawValue
        }
    }
}
