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
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .background(Color(.systemGroupedBackground))
                    
                    
                    List {
                        ForEach(medications) { medication in
                            ZStack {
                                NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                MedicationRowView(medication: medication)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteMedication)
                    }
                    .listStyle(.plain) // Standard-Stil entfernen
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hallo!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Deine Medikamente")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(Date().formatted(date: .complete, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            Spacer()
        }
        .padding(.top, 10)
    }
    
    private var addButton: some View {
        Button(action: showAddSheet) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)
        }
    }
    
    // MARK: - Actions
    
    private func showAddSheet() {
        isShowingAddSheet = true
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        for index in offsets {
            let medicationToDelete = medications[index]            
            NotificationManager.shared.cancelNotification(for: medicationToDelete)
            modelContext.delete(medicationToDelete)
        }
    }
}
