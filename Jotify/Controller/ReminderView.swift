//
//  ReminderView.swift
//  Jotify
//
//  Replaces ReminderController, DatePickerCell and TimePickerCell.
//

import SwiftUI
import UserNotifications

/// Sheet for setting or clearing a reminder on the note being edited
/// (`EditingData.currentNote`).
struct ReminderView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var isOn: Bool
    @State private var date: Date
    private let hadReminder: Bool

    init() {
        let timestamp = EditingData.currentNote.reminderTimestamp ?? 0
        let existing = Date(timeIntervalSinceReferenceDate: timestamp)
        // A reminder that already fired is finished; start fresh.
        let isPending = timestamp > 0 && existing > .now
        hadReminder = isPending
        _isOn = State(initialValue: isPending)
        _date = State(initialValue: isPending ? existing : Self.nextHour())
    }

    var body: some View {
        NavigationStack {
            // One group, compact pickers (like Reminders and Calendar), so
            // the sheet stays small instead of a tall graphical calendar.
            Form {
                Section {
                    Toggle("Remind Me", isOn: $isOn.animation())
                    if isOn {
                        DatePicker("Date", selection: $date, in: Date.now..., displayedComponents: .date)
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
                    }
                } footer: {
                    Text(isOn
                         ? "Jotify will remind you \(date.formatted(.relative(presentation: .named)))."
                         : "Get a notification about this note at a time you choose.")
                }
            }
            .navigationTitle("Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        save()
                        dismiss()
                    }
                    .disabled(isOn && date <= .now)
                }
            }
        }
        .tint(Color(UIColor.brandCoral))
    }

    private func save() {
        if isOn {
            ReminderScheduler.schedule(at: date)
        } else if hadReminder {
            ReminderScheduler.removeReminder()
        }
    }

    private static func nextHour() -> Date {
        let calendar = Calendar.current
        let inAnHour = calendar.date(byAdding: .hour, value: 1, to: .now) ?? .now
        return calendar.date(bySetting: .minute, value: 0, of: inAnHour) ?? inAnHour
    }

    static func makeController() -> UIViewController {
        let controller = UIHostingController(rootView: ReminderView())
        controller.modalPresentationStyle = .pageSheet
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        return controller
    }
}

/// Schedules and clears note reminders, and keeps the app badge in order.
enum ReminderScheduler {

    /// Replaces any reminder on the current note with one at `date`.
    static func schedule(at date: Date) {
        let center = UNUserNotificationCenter.current()
        if let existing = EditingData.currentNote.reminder, !existing.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: [existing])
        }

        let note = EditingData.currentNote
        let identifier = UUID().uuidString
        let content = UNMutableNotificationContent()
        content.body = note.content
        content.userInfo = ["noteID": note.id, "color": note.color, "timestamp": note.timestamp, "content": note.content]
        content.sound = .default
        content.categoryIdentifier = "NOTE_REMINDER"
        //placeholder: pending reminders are renumbered in delivery order
        //whenever the app goes to the background
        content.badge = 1

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let fireDate = Calendar.current.date(from: components) ?? date
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))

        EditingData.currentNote.reminder = identifier
        EditingData.currentNote.reminderTimestamp = fireDate.timeIntervalSinceReferenceDate

        //give Firebase the reminder's ID and time
        DataManager.updateNoteReminder(reminder: identifier, reminderTimestamp: fireDate.timeIntervalSinceReferenceDate, uid: note.id) { success in
            if success != true { print("There was an error creating the reminder") }
        }
    }

    /// Clears the current note's reminder, locally and on the server.
    static func removeReminder() {
        let timestamp = EditingData.currentNote.reminderTimestamp ?? 0
        guard timestamp > 0 else { return }
        //only a reminder that already fired has added to the badge
        let wasDelivered = timestamp < Date.timeIntervalSinceReferenceDate
        if let identifier = EditingData.currentNote.reminder, !identifier.isEmpty {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        EditingData.currentNote.reminderTimestamp = 0
        EditingData.currentNote.reminder = ""

        DataManager.removeReminder(uid: EditingData.currentNote.id) { success in
            if success == true, wasDelivered {
                UIApplication.shared.decrementBadge()
            }
        }
    }

    /// Renumbers the badge on pending reminders so they count up in delivery
    /// order. Copies each request's existing content and only changes the
    /// badge, so `userInfo` and the NOTE_REMINDER category survive (tapping
    /// the reminder still opens its note). Called when the app backgrounds.
    static func renumberBadgesOfPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { pendingNotificationRequests in
            let notificationRequests = pendingNotificationRequests
                .compactMap { request -> (UNNotificationRequest, Date)? in
                    guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
                          let date = trigger.nextTriggerDate() else { return nil }
                    return (request, date)
                }
                .sorted { $0.1 < $1.1 }
                .map { $0.0 }
            guard !notificationRequests.isEmpty else { return }
            center.removePendingNotificationRequests(withIdentifiers: notificationRequests.map { $0.identifier })
            notificationRequests.enumerated().forEach { index, request in
                guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else { return }
                content.badge = (index + 1) as NSNumber
                center.add(UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger))
            }
        }
    }
}
