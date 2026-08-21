import Foundation
import UserNotifications

final class ReminderManager {
    static let shared = ReminderManager()

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleWeighReminders(hour: Int, minute: Int, days: Set<Int>) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weighReminder"])
        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "⚖️ Время взвешивания"
        content.body = "Не забудь записать свой вес сегодня!"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "weighReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        _ = days
    }

    func scheduleWaterReminder(hour: Int, minute: Int, intervalMinutes: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["waterReminder"])
        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "💧 Пора пить воду"
        content.body = "Сделай глоток воды и отметь в приложении."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        _ = intervalMinutes
    }

    func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
