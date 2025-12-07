//
//  MedicationListView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI
import SwiftData

struct MedicationListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [Medication]
    
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(medications) { medication in
                    NavigationLink(destination: MedicationDetailView(medication: medication)) {
                        MedicationRowView(medication: medication)
                    }
                }
                .onDelete(perform: deleteMedication)
            }
            .navigationTitle("MedTracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    addButton
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddMedicationView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var addButton: some View {
        Button(action: showAddSheet) {
            Image(systemName: "plus")
        }
    }
    
    // MARK: - Actions
    
    private func showAddSheet() {
        isShowingAddSheet = true
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        for index in offsets {
            let medicationToDelete = medications[index]
            modelContext.delete(medicationToDelete)
        }
    }
}
