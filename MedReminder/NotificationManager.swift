import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // Request notification authorization
    func requestAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let granted = try await center.requestAuthorization(options: options)
        if !granted {
            throw NSError(domain: "NotificationAuthorization", code: 1, userInfo: [NSLocalizedDescriptionKey: "Benachrichtigungen sind nicht erlaubt. Bitte in den Einstellungen aktivieren."])
        }
    }

    // Schedule a medication reminder at a specific time (optionally repeating daily)
    @discardableResult
    func scheduleMedicationReminder(id: String = UUID().uuidString,
                                    name: String,
                                    time: Date,
                                    repeatsDaily: Bool = true,
                                    notes: String? = nil) async throws -> String {
        let content = UNMutableNotificationContent()
        content.title = "Medikament einnehmen"
        content.body = notes?.isEmpty == false ? "\(name) – \(notes!)" : name
        content.sound = .default

        // Extract hour/minute/second for a calendar trigger
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute, .second], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: repeatsDaily)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        return id
    }

    @discardableResult
    func scheduleOneTimeMedicationReminder(id: String = UUID().uuidString,
                                           name: String,
                                           date: Date,
                                           notes: String? = nil) async throws -> String {
        let content = UNMutableNotificationContent()
        content.title = "Medikament einnehmen"
        content.body = notes?.isEmpty == false ? "\(name) – \(notes!)" : name
        content.sound = .default

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        return id
    }

    // Remove a scheduled notification
    func removePendingNotification(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    // Remove all pending notifications (use carefully)
    func removeAllPending() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // Fetch pending requests (for debugging or listing)
    func pendingRequests() async -> [UNNotificationRequest] {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                continuation.resume(returning: requests)
            }
        }
    }
}
