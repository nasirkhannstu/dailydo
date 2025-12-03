//
//  TodoItem.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData

@Model
class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var itemDescription: String?
    var dueDate: Date?
    var dueTime: Date?
    var completed: Bool
    var starred: Bool
    var reminderEnabled: Bool
    var recurringType: RecurringType
    var aiGenerated: Bool
    var colorID: String?
    var textureID: String?
    var flagColor: String?
    var sortOrder: Int
    var createdDate: Date
    var completedDate: Date?

    @Relationship(inverse: \Subtype.todos) var subtype: Subtype?
    @Relationship(deleteRule: .cascade) var subtasks: [Subtask]

    init(
        id: UUID = UUID(),
        title: String,
        itemDescription: String? = nil,
        dueDate: Date? = nil,
        dueTime: Date? = nil,
        completed: Bool = false,
        starred: Bool = false,
        reminderEnabled: Bool = false,
        recurringType: RecurringType = .none,
        aiGenerated: Bool = false,
        colorID: String? = nil,
        textureID: String? = nil,
        flagColor: String? = nil,
        sortOrder: Int = 0,
        createdDate: Date = Date(),
        completedDate: Date? = nil,
        subtype: Subtype? = nil,
        subtasks: [Subtask] = []
    ) {
        self.id = id
        self.title = title
        self.itemDescription = itemDescription
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.completed = completed
        self.starred = starred
        self.reminderEnabled = reminderEnabled
        self.recurringType = recurringType
        self.aiGenerated = aiGenerated
        self.colorID = colorID
        self.textureID = textureID
        self.flagColor = flagColor
        self.sortOrder = sortOrder
        self.createdDate = createdDate
        self.completedDate = completedDate
        self.subtype = subtype
        self.subtasks = subtasks
    }

    // Toggle completion status
    func toggleCompletion() {
        completed.toggle()
        if completed {
            completedDate = Date()
        } else {
            completedDate = nil
        }
    }

    // Toggle starred status
    func toggleStarred() {
        starred.toggle()
    }

    // Check if todo is overdue
    var isOverdue: Bool {
        guard let dueDate = dueDate, !completed else { return false }
        return dueDate < Date()
    }

    // Check if todo is due today
    var isDueToday: Bool {
        guard let dueDate = dueDate else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }

    // Subtasks completion percentage
    var subtasksCompletionPercentage: Double {
        guard !subtasks.isEmpty else { return 0 }
        let completedCount = subtasks.filter { $0.completed }.count
        return Double(completedCount) / Double(subtasks.count) * 100
    }

    // Combined due date and time
    var combinedDueDateTime: Date? {
        guard let dueDate = dueDate else { return nil }

        if let dueTime = dueTime {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: dueTime)

            var combined = DateComponents()
            combined.year = dateComponents.year
            combined.month = dateComponents.month
            combined.day = dateComponents.day
            combined.hour = timeComponents.hour
            combined.minute = timeComponents.minute

            return calendar.date(from: combined)
        }

        return dueDate
    }

    // Calculate next recurring date
    func nextRecurringDate() -> Date? {
        guard recurringType != .none, let currentDueDate = dueDate else { return nil }

        let calendar = Calendar.current

        switch recurringType {
        case .none:
            return nil

        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: currentDueDate)

        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: currentDueDate)

        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: currentDueDate)

        case .yearly:
            return calendar.date(byAdding: .year, value: 1, to: currentDueDate)
        }
    }
}
