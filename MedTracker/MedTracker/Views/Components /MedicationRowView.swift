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
        HStack(spacing: 16) {
            
            VStack {
                if medication.isActive {
                    Text(medication.reminderTime, style: .time)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                } else {
                    Image(systemName: "pause.circle")
                        .font(.title3)
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 60) 
            
            
            HStack(spacing: 12) {
                
                if let image = medication.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(medication.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    HStack(spacing: 4) {
                        Text(medication.dosage)
                        Text("•")
                        Text(scheduleDescription)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            
            if medication.isTakenToday {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.green)
            }
        }
        .padding() 
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // Helper für den Text
    private var scheduleDescription: String {
        if !medication.isActive { return "Pausiert" }
        switch medication.frequency {
        case .everyXDays: return "Alle \(medication.interval) Tage"
        default: return medication.frequency.rawValue
        }
    }
}
