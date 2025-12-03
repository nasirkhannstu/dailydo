//
//  Subtask.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData

@Model
class Subtask {
    @Attribute(.unique) var id: UUID
    var title: String
    var completed: Bool
    var sortOrder: Int
    var createdDate: Date

    @Relationship(inverse: \TodoItem.subtasks) var todoItem: TodoItem?

    init(
        id: UUID = UUID(),
        title: String,
        completed: Bool = false,
        sortOrder: Int = 0,
        createdDate: Date = Date(),
        todoItem: TodoItem? = nil
    ) {
        self.id = id
        self.title = title
        self.completed = completed
        self.sortOrder = sortOrder
        self.createdDate = createdDate
        self.todoItem = todoItem
    }

    // Toggle completion status
    func toggleCompletion() {
        completed.toggle()
    }
}
