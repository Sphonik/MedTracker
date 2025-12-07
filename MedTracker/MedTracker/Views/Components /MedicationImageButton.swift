//
//  MedicationImageButton.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import SwiftUI

struct MedicationImageButton: View {
    @Binding var selectedImage: UIImage?
    
    @State private var showConfirmationDialog = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            // 1. Das Bild oder der Platzhalter
            ZStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                } else {
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        )
                }
            }
            .onTapGesture {
                showConfirmationDialog = true
            }
            
            // 2. Kleiner Hinweistext
            Text(selectedImage == nil ? "Foto hinzufügen" : "Foto ändern")
                .font(.caption)
                .foregroundStyle(.blue)
        }
        // Auswahl-Dialog (Action Sheet)
        .confirmationDialog("Foto auswählen", isPresented: $showConfirmationDialog) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Kamera") {
                    self.sourceType = .camera
                    self.showImagePicker = true
                }
            }
            
            Button("Galerie") {
                self.sourceType = .photoLibrary
                self.showImagePicker = true
            }
            
            if selectedImage != nil {
                Button("Foto löschen", role: .destructive) {
                    withAnimation {
                        selectedImage = nil
                    }
                }
            }
            
            Button("Abbrechen", role: .cancel) {}
        }
        // Der eigentliche Picker (Modal)
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                .ignoresSafeArea()
        }
    }
}
