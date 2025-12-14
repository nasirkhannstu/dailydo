//
//  TodoViewModel.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class TodoViewModel {
    private var modelContext: ModelContext

    var todos: [TodoItem] = []
    var isLoading = false
    var errorMessage: String?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Fetch todos for a specific subtype
    func fetchTodos(for subtype: Subtype) {
        isLoading = true
        errorMessage = nil

        do {
            let descriptor = FetchDescriptor<TodoItem>()
            let allTodos = try modelContext.fetch(descriptor)
            // Filter and sort
            todos = allTodos
                .filter { $0.subtype?.id == subtype.id }
                .sorted { first, second in
                    if first.completed != second.completed {
                        return !first.completed // incomplete first
                    }
                    return first.createdDate > second.createdDate // newest first
                }
        } catch {
            errorMessage = "Failed to load todos: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Create a new todo
    func createTodo(
        title: String,
        description: String? = nil,
        dueDate: Date? = nil,
        dueTime: Date? = nil,
        reminderEnabled: Bool = false,
        recurringType: RecurringType = .dueDate,
        subtype: Subtype
    ) {
        let newTodo = TodoItem(
            title: title,
            itemDescription: description,
            dueDate: dueDate,
            dueTime: dueTime,
            reminderEnabled: reminderEnabled,
            recurringType: recurringType,
            sortOrder: todos.count,
            subtype: subtype
        )

        modelContext.insert(newTodo)
        saveContext()
        fetchTodos(for: subtype)
    }

    // Update todo
    func updateTodo(_ todo: TodoItem) {
        saveContext()
    }

    // Delete todo
    func deleteTodo(_ todo: TodoItem, from subtype: Subtype) {
        modelContext.delete(todo)
        saveContext()
        fetchTodos(for: subtype)
    }

    // Toggle completion
    func toggleCompletion(_ todo: TodoItem) {
        todo.toggleCompletion()
        saveContext()
    }

    // Set priority
    func setPriority(_ todo: TodoItem, _ newPriority: TodoPriority) {
        todo.setPriority(newPriority)
        saveContext()
    }

    // Save context
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
