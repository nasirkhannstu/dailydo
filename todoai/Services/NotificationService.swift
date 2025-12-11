//
//  NotificationService.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import Foundation
import UserNotifications
import SwiftData
import Combine

@MainActor
class NotificationService: ObservableObject {

    static let shared = NotificationService()

    @Published var isAuthorized = false

    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Permission Management

    /// Request notification permissions from the user
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted

            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }

            return granted
        } catch {
            print("❌ Error requesting notification permission: \(error)")
            return false
        }
    }

    /// Check current authorization status
    func checkAuthorizationStatus() async -> Bool {
        let settings = await center.notificationSettings()
        let authorized = settings.authorizationStatus == .authorized
        isAuthorized = authorized
        return authorized
    }

    // MARK: - Schedule Notifications

    /// Schedule a notification for a todo item
    func scheduleNotification(for todo: TodoItem) async {
        // Check if notifications are enabled for this todo
        guard todo.reminderEnabled else {
            print("⏭️ Skipping notification - reminders disabled for: \(todo.title)")
            return
        }

        // Check if we have permission
        let isAuthorized = await checkAuthorizationStatus()
        guard isAuthorized else {
            print("⚠️ Cannot schedule notification - not authorized")
            return
        }

        // Determine the notification date
        guard let notificationDate = todo.combinedDueDateTime else {
            print("⏭️ Skipping notification - no due date set for: \(todo.title)")
            return
        }

        // Don't schedule notifications for past dates
        guard notificationDate > Date() else {
            print("⏭️ Skipping notification - date is in the past for: \(todo.title)")
            return
        }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(todo.title)"

        if let description = todo.itemDescription, !description.isEmpty {
            content.body = description
        } else {
            content.body = "Don't forget to complete this task!"
        }

        content.sound = .default
        content.badge = 1

        // Add category for actions (optional - for future enhancement)
        content.categoryIdentifier = "TODO_REMINDER"

        // Store todo ID in userInfo for later retrieval
        content.userInfo = ["todoID": todo.id.uuidString]

        // Create trigger based on recurring type
        let trigger = createTrigger(for: todo, notificationDate: notificationDate)

        // Create request
        let identifier = "todo-\(todo.id.uuidString)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        // Schedule notification
        do {
            try await center.add(request)
            print("✅ Scheduled notification for: \(todo.title) at \(notificationDate)")
        } catch {
            print("❌ Error scheduling notification: \(error)")
        }
    }

    /// Create appropriate trigger based on recurring type
    private func createTrigger(for todo: TodoItem, notificationDate: Date) -> UNNotificationTrigger {
        let calendar = Calendar.current

        switch todo.recurringType {
        case .dueDate, .oneTime:
            // One-time notification
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        case .daily:
            // Daily at the same time
            let components = calendar.dateComponents([.hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        case .weekly:
            // Weekly on the same day and time
            let components = calendar.dateComponents([.weekday, .hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        case .monthly:
            // Monthly on the same day and time
            let components = calendar.dateComponents([.day, .hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        case .yearly:
            // Yearly on the same date and time
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        }
    }

    // MARK: - Cancel Notifications

    /// Cancel notification for a specific todo
    func cancelNotification(for todo: TodoItem) {
        let identifier = "todo-\(todo.id.uuidString)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("🗑️ Cancelled notification for: \(todo.title)")
    }

    /// Cancel all notifications
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        print("🗑️ Cancelled all notifications")
    }

    // MARK: - Update Notifications

    /// Update notification when todo is modified
    func updateNotification(for todo: TodoItem) async {
        // Cancel existing notification
        cancelNotification(for: todo)

        // Schedule new one if reminders are enabled
        if todo.reminderEnabled {
            await scheduleNotification(for: todo)
        }
    }

    // MARK: - Badge Management

    /// Clear app badge
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }

    // MARK: - Pending Notifications

    /// Get count of pending notifications
    func getPendingNotificationsCount() async -> Int {
        let requests = await center.pendingNotificationRequests()
        return requests.count
    }

    /// Get all pending notifications for debugging
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await center.pendingNotificationRequests()
    }

    /// Print all pending notifications for debugging
    func printPendingNotifications() async {
        let requests = await center.pendingNotificationRequests()
        print("📋 Pending notifications: \(requests.count)")
        for request in requests {
            print("  - \(request.identifier): \(request.content.title)")
        }
    }
}
