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
            
            MedicationListView()
                .tabItem {
                    Label("Medikamente", systemImage: "pills.fill")
                }
            
            
            HistoryView()
                .tabItem {
                    Label("Verlauf", systemImage: "list.bullet.clipboard")
                }
        }
    }
}
