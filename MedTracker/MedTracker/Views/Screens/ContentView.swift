//
//  ContentView.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1: Deine bestehende Liste
            MedicationListView()
                .tabItem {
                    Label("Medikamente", systemImage: "pills.fill")
                }
            
            // Tab 2: Der neue Verlauf
            HistoryView()
                .tabItem {
                    Label("Verlauf", systemImage: "list.bullet.clipboard")
                }
        }
    }
}
