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
    var completionContextDate: Date? = nil

    @Query private var allTodos: [TodoItem]
    @State private var showingAddSubtask = false
    @State private var newSubtaskTitle = ""
    @State private var notificationService = NotificationService.shared

    private var completionInstances: [TodoItem] {
        guard todo.isRecurringTemplate else { return [] }
        return allTodos.filter { $0.parentRecurringTodoId == todo.id }
            .sorted { ($0.dueDate ?? Date()) > ($1.dueDate ?? Date()) }
    }

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

                        // Add Subtask Button (Hide for completion instances)
                        if !todo.isCompletionInstance {
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
            }

            // MARK: - Task Settings Card (Hide for completion instances)
            if !todo.isCompletionInstance {
                Section(todo.dueDateLabel) {
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

                // End Date (only show if recurring)
                if todo.recurringType != .none {
                    Toggle(isOn: Binding(
                        get: { todo.recurringEndDate != nil },
                        set: { enabled in
                            if enabled {
                                // Set end date to 30 days from start as default
                                todo.recurringEndDate = Calendar.current.date(byAdding: .day, value: 30, to: todo.dueDate ?? Date())
                            } else {
                                todo.recurringEndDate = nil
                            }
                        }
                    )) {
                        Label("End Date", systemImage: "calendar.badge.clock")
                            .foregroundStyle(.secondary)
                    }

                    if todo.recurringEndDate != nil {
                        DatePicker(
                            "Ends On",
                            selection: Binding(
                                get: { todo.recurringEndDate ?? Date() },
                                set: { todo.recurringEndDate = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
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

                // MARK: - Completion History Section (Recurring Templates Only)
                if todo.isRecurringTemplate {
                    Section("Completion History") {
                        if completionInstances.isEmpty {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text("Not yet completed")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                        } else {
                            ForEach(completionInstances) { completion in
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.title3)

                                    VStack(alignment: .leading, spacing: 2) {
                                        if let date = completion.dueDate {
                                            Text(date, style: .date)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                        }
                                        if let time = completion.completedDate {
                                            Text("Completed at \(time, style: .time)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }

                                    Spacer()
                                }
                            }
                        }
                    }
                }
            } // End of !todo.isCompletionInstance
        }
        .navigationTitle(todo.isCompletionInstance ? "Completed Task" : "Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(todo.isCompletionInstance)
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
        // Check if this is a recurring template being marked as complete
        if !todo.completed && todo.isRecurringTemplate {
            // Use completion context date if provided, otherwise use today
            let effectiveDate = completionContextDate ?? Date()

            // Create a completion instance instead of marking template as complete
            let completionInstance = TodoItem(
                title: todo.title,
                itemDescription: todo.itemDescription,
                dueDate: effectiveDate, // Use the date being completed for
                dueTime: todo.dueTime,
                completed: true,
                starred: todo.starred,
                reminderEnabled: false, // Completion instances don't need reminders
                showInCalendar: todo.showInCalendar,
                recurringType: .none, // Completion instances are not recurring
                aiGenerated: todo.aiGenerated,
                colorID: todo.colorID,
                textureID: todo.textureID,
                flagColor: todo.flagColor,
                sortOrder: todo.sortOrder,
                completedDate: Date(),
                parentRecurringTodoId: todo.id, // Link to parent recurring todo
                subtype: todo.subtype
            )
            modelContext.insert(completionInstance)

            // Dismiss view since we created a completion instance
            // The recurring template stays in the list
            dismiss()
        } else {
            // For non-recurring or completion instances, toggle normally
            todo.toggleCompletion()
        }
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
