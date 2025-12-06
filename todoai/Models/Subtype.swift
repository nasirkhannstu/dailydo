//
//  Subtype.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData

@Model
class Subtype {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: SubtypeType
    var colorID: String?
    var textureID: String?
    var screenID: String?
    var icon: String
    var showInCalendar: Bool
    var notificationEnabled: Bool
    var isPreCreated: Bool
    var isShared: Bool
    var sharedUserIDs: [String]
    var sortOrder: Int
    var createdDate: Date

    @Relationship(inverse: \User.subtypes) var user: User?
    @Relationship(deleteRule: .cascade) var todos: [TodoItem]

    init(
        id: UUID = UUID(),
        name: String,
        type: SubtypeType,
        colorID: String? = nil,
        textureID: String? = nil,
        screenID: String? = nil,
        icon: String = "",
        showInCalendar: Bool = false,
        notificationEnabled: Bool = false,
        isPreCreated: Bool = false,
        isShared: Bool = false,
        sharedUserIDs: [String] = [],
        sortOrder: Int = 0,
        createdDate: Date = Date(),
        user: User? = nil,
        todos: [TodoItem] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.colorID = colorID
        self.textureID = textureID
        self.screenID = screenID
        self.icon = icon.isEmpty ? type.icon : icon
        self.showInCalendar = showInCalendar
        self.notificationEnabled = notificationEnabled
        self.isPreCreated = isPreCreated
        self.isShared = isShared
        self.sharedUserIDs = sharedUserIDs
        self.sortOrder = sortOrder
        self.createdDate = createdDate
        self.user = user
        self.todos = todos
    }

    // Computed property: count of incomplete todos (excludes completion instances and ended recurring)
    var incompleteTodosCount: Int {
        todos.filter { !$0.completed && !$0.isCompletionInstance && !$0.hasRecurringEnded }.count
    }

    // Computed property: count of completed todos (excludes completion instances and ended recurring)
    var completedTodosCount: Int {
        todos.filter { $0.completed && !$0.isCompletionInstance && !$0.hasRecurringEnded }.count
    }

    // Computed property: completion percentage
    var completionPercentage: Double {
        let activeTodos = todos.filter { !$0.isCompletionInstance && !$0.hasRecurringEnded }
        guard !activeTodos.isEmpty else { return 0 }
        return Double(completedTodosCount) / Double(activeTodos.count) * 100
    }
}
