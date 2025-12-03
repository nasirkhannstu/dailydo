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

    // Edit todo states
    @State private var showingEditTodo = false
    @State private var editTitle = ""
    @State private var editDescription = ""
    @State private var editDueDate: Date?
    @State private var editShowDueDatePicker = false
    @State private var editRecurringType: RecurringType = .none

    var body: some View {
        List {
            // MARK: - Todo Info Section
            Section("Task Details") {
                // Title
                HStack {
                    Label("Title", systemImage: "text.alignleft")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(todo.title)
                }

                // Description
                if let description = todo.itemDescription, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Description", systemImage: "doc.text")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        Text(description)
                            .font(.body)
                    }
                }

                // Due Date
                if let dueDate = todo.dueDate {
                    HStack {
                        Label("Due Date", systemImage: "calendar")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(dueDate, style: .date)
                            .foregroundStyle(todo.isOverdue ? .red : .primary)
                    }
                }

                // Status
                HStack {
                    Label("Status", systemImage: todo.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(todo.completed ? "Completed" : "Active")
                        .foregroundStyle(todo.completed ? .green : .blue)
                }

                // Recurring
                if todo.recurringType != .none {
                    HStack {
                        Label("Repeats", systemImage: "repeat")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(todo.recurringType.displayName)
                    }
                }

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
            }

            // MARK: - Subtasks Section
            Section {
                if todo.subtasks.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "checklist")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("No subtasks yet")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                } else {
                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        SubtaskRow(subtask: subtask)
                    }
                    .onDelete(perform: deleteSubtasks)
                }
            } header: {
                HStack {
                    Text("Subtasks")
                    Spacer()
                    if !todo.subtasks.isEmpty {
                        Text("\(completedSubtasksCount)/\(todo.subtasks.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } footer: {
                Button {
                    showingAddSubtask = true
                } label: {
                    Label("Add Subtask", systemImage: "plus.circle.fill")
                }
            }

            // MARK: - Actions Section
            Section {
                // Toggle Completion
                Button {
                    withAnimation {
                        handleCompletion()
                    }
                } label: {
                    Label(
                        todo.completed ? "Mark as Incomplete" : "Mark as Complete",
                        systemImage: todo.completed ? "arrow.uturn.backward.circle" : "checkmark.circle.fill"
                    )
                    .foregroundStyle(todo.completed ? .orange : .green)
                }

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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    prepareEditForm()
                    showingEditTodo = true
                } label: {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showingEditTodo) {
            NavigationStack {
                Form {
                    Section("Task Details") {
                        TextField("Title", text: $editTitle)
                        TextField("Description (optional)", text: $editDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }

                    Section {
                        Toggle("Set Due Date", isOn: $editShowDueDatePicker)

                        if editShowDueDatePicker {
                            DatePicker(
                                "Due Date",
                                selection: Binding(
                                    get: { editDueDate ?? Date() },
                                    set: { editDueDate = $0 }
                                ),
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                    }

                    Section("Repeat") {
                        Picker("Recurring", selection: $editRecurringType) {
                            Text("Never").tag(RecurringType.none)
                            Text("Daily").tag(RecurringType.daily)
                            Text("Weekly").tag(RecurringType.weekly)
                            Text("Monthly").tag(RecurringType.monthly)
                            Text("Yearly").tag(RecurringType.yearly)
                        }
                        .pickerStyle(.menu)
                    }
                }
                .navigationTitle("Edit Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingEditTodo = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveEditedTodo()
                        }
                        .disabled(editTitle.isEmpty)
                    }
                }
            }
            .presentationDetents([.large])
        }
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

    private func prepareEditForm() {
        editTitle = todo.title
        editDescription = todo.itemDescription ?? ""
        editDueDate = todo.dueDate
        editShowDueDatePicker = todo.dueDate != nil
        editRecurringType = todo.recurringType
    }

    private func saveEditedTodo() {
        // Update todo properties
        todo.title = editTitle
        todo.itemDescription = editDescription.isEmpty ? nil : editDescription
        todo.dueDate = editShowDueDatePicker ? editDueDate : nil
        todo.recurringType = editRecurringType

        // Update notification if reminder is enabled
        if todo.reminderEnabled {
            Task {
                await notificationService.updateNotification(for: todo)
            }
        }

        showingEditTodo = false
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
