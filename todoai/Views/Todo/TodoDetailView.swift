//
//  TodoDetailView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI
import SwiftData

struct TodoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var todo: TodoItem

    @State private var showingAddSubtask = false
    @State private var newSubtaskTitle = ""
    @State private var notificationService = NotificationService.shared

    var body: some View {
        List {
            // MARK: - Title, Description & Subtasks Card
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    TextField("Task title", text: $todo.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .textFieldStyle(.plain)

                    // Description
                    TextField("Add description...", text: Binding(
                        get: { todo.itemDescription ?? "" },
                        set: { todo.itemDescription = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .textFieldStyle(.plain)
                        .lineLimit(2...8)
                }
                .padding(.vertical, 4)

                // Subtasks
                if !todo.subtasks.isEmpty || todo.subtasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        // Subtasks Header
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "checklist")
                                    .font(.subheadline)
                                    .foregroundStyle(.blue)
                                Text("Subtasks")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            if !todo.subtasks.isEmpty {
                                Text("\(completedSubtasksCount)/\(todo.subtasks.count)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue)
                                    )
                            }
                        }
                        .padding(.top, 8)

                        // Subtasks List
                        if todo.subtasks.isEmpty {
                            Text("No subtasks yet")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 4) {
                                ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                                    CompactSubtaskRow(subtask: subtask)
                                }
                                .onDelete(perform: deleteSubtasks)
                            }
                        }

                        // Add Subtask Button
                        Button {
                            showingAddSubtask = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.subheadline)
                                Text("Add Subtask")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.blue)
                        }
                        .padding(.top, 4)
                    }
                }
            }

            // MARK: - Task Settings Card
            Section("Due Date & Time") {
                DatePicker(
                    "Date",
                    selection: Binding(
                        get: { todo.dueDate ?? Date() },
                        set: {
                            todo.dueDate = $0
                            todo.dueTime = $0
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)

                DatePicker(
                    "Time",
                    selection: Binding(
                        get: { todo.dueDate ?? Date() },
                        set: {
                            todo.dueDate = $0
                            todo.dueTime = $0
                        }
                    ),
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.compact)
            }

            Section {
                // Status
                Button {
                    withAnimation {
                        handleCompletion()
                    }
                } label: {
                    HStack {
                        Label("Status", systemImage: "circle")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(todo.completed ? .green : .gray)
                    }
                }
                .buttonStyle(.plain)

                // Recurring
                Picker(selection: $todo.recurringType) {
                    Text("Never").tag(RecurringType.none)
                    Text("Daily").tag(RecurringType.daily)
                    Text("Weekly").tag(RecurringType.weekly)
                    Text("Monthly").tag(RecurringType.monthly)
                    Text("Yearly").tag(RecurringType.yearly)
                } label: {
                    Label("Repeats", systemImage: "repeat")
                        .foregroundStyle(.secondary)
                }
                .pickerStyle(.menu)

                // Reminder Toggle
                Toggle(isOn: Binding(
                    get: { todo.reminderEnabled },
                    set: { newValue in
                        Task {
                            await toggleReminder(enabled: newValue)
                        }
                    }
                )) {
                    Label("Reminder", systemImage: "bell.fill")
                        .foregroundStyle(.secondary)
                }

                // Show in Calendar Toggle
                Toggle(isOn: $todo.showInCalendar) {
                    Label("Show in Calendar", systemImage: "calendar")
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: - Actions Section
            Section {
                // Toggle Star
                Button {
                    withAnimation {
                        todo.toggleStarred()
                    }
                } label: {
                    Label(
                        todo.starred ? "Unstar" : "Star",
                        systemImage: todo.starred ? "star.slash" : "star.fill"
                    )
                    .foregroundStyle(.yellow)
                }

                // Delete Todo
                Button(role: .destructive) {
                    deleteTodo()
                } label: {
                    Label("Delete Task", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddSubtask) {
            NavigationStack {
                Form {
                    TextField("Subtask title", text: $newSubtaskTitle)
                }
                .navigationTitle("New Subtask")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddSubtask = false
                            newSubtaskTitle = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addSubtask()
                        }
                        .disabled(newSubtaskTitle.isEmpty)
                    }
                }
            }
            .presentationDetents([.height(200)])
        }
    }

    // MARK: - Computed Properties

    private var completedSubtasksCount: Int {
        todo.subtasks.filter { $0.completed }.count
    }

    // MARK: - Functions

    private func addSubtask() {
        let subtask = Subtask(
            title: newSubtaskTitle,
            sortOrder: todo.subtasks.count,
            todoItem: todo
        )
        modelContext.insert(subtask)

        showingAddSubtask = false
        newSubtaskTitle = ""
    }

    private func deleteSubtasks(at offsets: IndexSet) {
        let sortedSubtasks = todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })
        for index in offsets {
            modelContext.delete(sortedSubtasks[index])
        }
    }

    private func deleteTodo() {
        // Cancel notification before deleting
        notificationService.cancelNotification(for: todo)
        modelContext.delete(todo)
        dismiss()
    }

    private func toggleReminder(enabled: Bool) async {
        if enabled {
            // Request permission first
            let authorized = await notificationService.requestAuthorization()

            if authorized {
                todo.reminderEnabled = true
                // Schedule notification
                await notificationService.scheduleNotification(for: todo)
            } else {
                // Permission denied, keep toggle off
                todo.reminderEnabled = false
            }
        } else {
            // Disable reminder
            todo.reminderEnabled = false
            // Cancel notification
            notificationService.cancelNotification(for: todo)
        }
    }

    private func handleCompletion() {
        // Check if this is a recurring todo being marked as complete
        if !todo.completed && todo.recurringType != .none {
            // Create next instance before marking current as complete
            if let nextDate = todo.nextRecurringDate() {
                let nextTodo = TodoItem(
                    title: todo.title,
                    itemDescription: todo.itemDescription,
                    dueDate: nextDate,
                    dueTime: todo.dueTime,
                    starred: todo.starred,
                    reminderEnabled: todo.reminderEnabled,
                    showInCalendar: todo.showInCalendar,
                    recurringType: todo.recurringType,
                    aiGenerated: todo.aiGenerated,
                    colorID: todo.colorID,
                    textureID: todo.textureID,
                    flagColor: todo.flagColor,
                    sortOrder: todo.sortOrder,
                    subtype: todo.subtype
                )
                modelContext.insert(nextTodo)

                // Schedule notification for the next instance if reminders are enabled
                if todo.reminderEnabled {
                    Task {
                        await notificationService.scheduleNotification(for: nextTodo)
                    }
                }
            }
        }

        // Toggle completion of current todo
        todo.toggleCompletion()
    }

}

// MARK: - Subtask Row

struct SubtaskRow: View {
    @Bindable var subtask: Subtask

    var body: some View {
        HStack(spacing: 12) {
            // Completion Button
            Button {
                withAnimation {
                    subtask.toggleCompletion()
                }
            } label: {
                Image(systemName: subtask.completed ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(subtask.completed ? .green : .gray)
            }
            .buttonStyle(.plain)

            // Subtask Title
            Text(subtask.title)
                .strikethrough(subtask.completed)
                .foregroundStyle(subtask.completed ? .secondary : .primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Compact Subtask Row

struct CompactSubtaskRow: View {
    @Bindable var subtask: Subtask

    var body: some View {
        HStack(spacing: 10) {
            // Completion Button
            Button {
                withAnimation(.spring(response: 0.3)) {
                    subtask.toggleCompletion()
                }
            } label: {
                Image(systemName: subtask.completed ? "checkmark.circle.fill" : "circle")
                    .font(.body)
                    .foregroundStyle(subtask.completed ? .green : .gray.opacity(0.5))
            }
            .buttonStyle(.plain)

            // Subtask Title
            Text(subtask.title)
                .font(.subheadline)
                .strikethrough(subtask.completed)
                .foregroundStyle(subtask.completed ? .secondary : .primary)

            Spacer()
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoItem.self, Subtask.self, configurations: config)

    let todo = TodoItem(
        title: "Complete Project",
        itemDescription: "Finish the DailyDo app implementation",
        dueDate: Date(),
        starred: true
    )
    container.mainContext.insert(todo)

    // Add sample subtasks
    let subtask1 = Subtask(title: "Design UI", completed: true, todoItem: todo)
    let subtask2 = Subtask(title: "Implement features", sortOrder: 1, todoItem: todo)
    let subtask3 = Subtask(title: "Test app", sortOrder: 2, todoItem: todo)

    container.mainContext.insert(subtask1)
    container.mainContext.insert(subtask2)
    container.mainContext.insert(subtask3)

    return NavigationStack {
        TodoDetailView(todo: todo)
    }
    .modelContainer(container)
}
