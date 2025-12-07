//
//  NotificationManager.swift
//  MedTracker
//
//  Created by Mohamed Bondok on 07.12.25.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    
    // MARK: - Singleton
    static let shared = NotificationManager()
    private init() {}
    
    // MARK: - Constants
    private let secondsInDay: TimeInterval = 86_400
    
    // MARK: - Public API
    
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("[NotificationManager] Error requesting authorization: \(error.localizedDescription)")
                return
            }
            print("[NotificationManager] Permission granted: \(granted)")
        }
    }
    
    /// Plant eine Benachrichtigung für ein Medikament oder aktualisiert eine bestehende.
    func scheduleNotification(for medication: Medication) {
        // 1. Aufräumen: Alte Notifications für diese ID immer erst löschen
        cancelNotification(for: medication)
        guard medication.isActive else { return }
        // 3. Validierung: "Bei Bedarf" benötigt keine Zeit-Erinnerung
        guard medication.frequency != .asNeeded else { return }
        // 4. Inhalt erstellen
        let content = makeNotificationContent(for: medication)
        
        guard let trigger = makeTrigger(for: medication) else {
            print("[NotificationManager] Could not create trigger for medication: \(medication.name)")
            return
        }
        
        
        let request = UNNotificationRequest(
            identifier: medication.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[NotificationManager] Failed to schedule: \(error.localizedDescription)")
            } else {
                print("[NotificationManager] Scheduled '\(medication.name)'")
            }
        }
    }
    
    /// Entfernt geplante Benachrichtigungen für ein Medikament.
    func cancelNotification(for medication: Medication) {
        let identifier = medication.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        //  bereits zugestellte Notifications aus dem Notification Center entfernen
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    // MARK: - Private Helpers
    
    private func makeNotificationContent(for medication: Medication) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Zeit für deine Medikamente"
        content.body = "Einnahme: \(medication.name) - \(medication.dosage)"
        content.sound = .default
        return content
    }
    
    private func makeTrigger(for medication: Medication) -> UNNotificationTrigger? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: medication.reminderTime)
        
        switch medication.frequency {
        case .daily:
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
        case .weekly:
            var weeklyComponents = dateComponents
            let weekday = calendar.component(.weekday, from: medication.reminderTime)
            weeklyComponents.weekday = weekday
            return UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
            
        case .monthly:
            var monthlyComponents = dateComponents
            let day = calendar.component(.day, from: medication.reminderTime)
            monthlyComponents.day = day
            return UNCalendarNotificationTrigger(dateMatching: monthlyComponents, repeats: true)
            
        case .everyXDays:
            let interval = TimeInterval(medication.interval) * secondsInDay
            // Sicherheitscheck: Ein Intervall von 0 oder weniger würde crashen
            guard interval > 0 else { return nil }
            return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
            
        case .asNeeded:
            return nil
        }
    }
}
