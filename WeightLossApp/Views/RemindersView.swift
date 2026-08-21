import SwiftUI
import UserNotifications

struct RemindersView: View {
    @State private var weighHour = 9
    @State private var weighMinute = 0
    @State private var weighOn = true
    @State private var waterHour = 11
    @State private var waterMinute = 0
    @State private var waterOn = false
    @State private var status = "Не запрошено"

    var body: some View {
        NavigationStack {
            Form {
                Section("Напоминание взвешиваться") {
                    Toggle("Включено", isOn: $weighOn)
                    DatePicker("Время", selection: Binding(
                        get: { makeDate(hour: weighHour, minute: weighMinute) },
                        set: { setTime($0) }
                    ), displayedComponents: .hourAndMinute)
                    Button("Применить") { applyWeigh() }
                }

                Section("Напоминание о воде") {
                    Toggle("Включено", isOn: $waterOn)
                    DatePicker("Время", selection: Binding(
                        get: { makeDate(hour: waterHour, minute: waterMinute) },
                        set: { t in
                            let c = Calendar.current.dateComponents([.hour, .minute], from: t)
                            waterHour = c.hour ?? 11; waterMinute = c.minute ?? 0
                        }
                    ), displayedComponents: .hourAndMinute)
                    Button("Применить") { applyWater() }
                }

                Section("Статус уведомлений") {
                    Text(status).foregroundStyle(.secondary)
                    Button("Запросить разрешение") {
                        Task {
                            let ok = await ReminderManager.shared.requestAuthorization()
                            status = ok ? "Разрешено ✓" : "Запрещено"
                        }
                    }
                }
            }
            .navigationTitle("Напоминания")
            .onAppear { Task { let ok = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus == .authorized; status = ok ? "Разрешено ✓" : "Не разрешено" } }
        }
    }

    private func makeDate(hour: Int, minute: Int) -> Date {
        var c = DateComponents(); c.hour = hour; c.minute = minute
        return Calendar.current.date(from: c) ?? .now
    }
    private func setTime(_ d: Date) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: d)
        weighHour = c.hour ?? 9; weighMinute = c.minute ?? 0
    }
    private func applyWeigh() {
        if weighOn {
            ReminderManager.shared.scheduleWeighReminders(hour: weighHour, minute: weighMinute, days: Set(1...7))
        } else {
            ReminderManager.shared.removeAll()
        }
    }
    private func applyWater() {
        if waterOn {
            ReminderManager.shared.scheduleWaterReminder(hour: waterHour, minute: waterMinute, intervalMinutes: 60)
        } else {
            ReminderManager.shared.removeAll()
        }
    }
}
