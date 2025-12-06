//
//  SubtypeDetailView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct SubtypeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var subtype: Subtype

    @State private var showingAddTodo = false
    @State private var newTodoTitle = ""
    @State private var newTodoDescription = ""
    @State private var newTodoDueDate: Date = Date()
    @State private var enableReminder = false
    @State private var showInCalendar = true
    @State private var recurringType: RecurringType = .none
    @State private var notificationService = NotificationService.shared

    // Edit subtype states
    @State private var showingEditSubtype = false
    @State private var showingIconPicker = false
    @State private var editName = ""
    @State private var editIcon = ""
    @State private var editShowInCalendar = false
    @State private var editRemindersEnabled = false
    @State private var showingDeleteAlert = false
    @State private var showingCalendarToggleAlert = false
    @State private var pendingCalendarValue = false
    @State private var showingRemindersToggleAlert = false
    @State private var pendingRemindersValue = false

    var incompleteTodos: [TodoItem] {
        subtype.todos.filter {
            !$0.completed && !$0.isCompletionInstance && !$0.hasRecurringEnded
        }.sorted(by: { $0.createdDate > $1.createdDate })
    }

    var completedTodos: [TodoItem] {
        subtype.todos.filter {
            $0.completed && !$0.isCompletionInstance && !$0.hasRecurringEnded
        }.sorted(by: { $0.completedDate ?? $0.createdDate > $1.completedDate ?? $1.createdDate })
    }

    var fabColor: Color {
        switch subtype.type {
        case .habit:
            return .blue
        case .plan:
            return .green
        case .list:
            return .orange
        }
    }

    var body: some View {
        List {
            // Active Todos
            if !incompleteTodos.isEmpty {
                Section("Active") {
                    ForEach(incompleteTodos) { todo in
                        NavigationLink(destination: TodoDetailView(todo: todo)) {
                            TodoRowView(todo: todo)
                        }
                    }
                    .onDelete { offsets in
                        deleteTodos(from: incompleteTodos, at: offsets)
                    }
                }
            }

            // Completed Todos
            if !completedTodos.isEmpty {
                Section("Completed") {
                    ForEach(completedTodos) { todo in
                        NavigationLink(destination: TodoDetailView(todo: todo)) {
                            TodoRowView(todo: todo)
                        }
                    }
                    .onDelete { offsets in
                        deleteTodos(from: completedTodos, at: offsets)
                    }
                }
            }

            if subtype.todos.isEmpty {
                ContentUnavailableView(
                    "No Tasks Yet",
                    systemImage: "checklist",
                    description: Text("Add your first task to get started")
                )
            }
        }
        .navigationTitle(subtype.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    prepareEditForm()
                    showingEditSubtype = true
                } label: {
                    Text("Edit")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.blue)

                    Toggle("", isOn: Binding(
                        get: { subtype.showInCalendar },
                        set: { newValue in
                            pendingCalendarValue = newValue
                            showingCalendarToggleAlert = true
                        }
                    ))
                    .labelsHidden()
                    .controlSize(.mini)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                showingAddTodo = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(fabColor.gradient)
                    )
                    .shadow(color: fabColor.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingAddTodo) {
            NavigationStack {
                Form {
                    Section("Task Details") {
                        TextField("Title", text: $newTodoTitle)
                        TextField("Description (optional)", text: $newTodoDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }

                    Section("Due Date & Time") {
                        DatePicker(
                            "Date",
                            selection: $newTodoDueDate,
                            displayedComponents: [.date]
                        )

                        DatePicker(
                            "Time",
                            selection: $newTodoDueDate,
                            displayedComponents: [.hourAndMinute]
                        )

                        Toggle("Set Reminder", isOn: $enableReminder)
                    }

                    Section("Repeat") {
                        Picker("Recurring", selection: $recurringType) {
                            Text("Never").tag(RecurringType.none)
                            Text("Daily").tag(RecurringType.daily)
                            Text("Weekly").tag(RecurringType.weekly)
                            Text("Monthly").tag(RecurringType.monthly)
                            Text("Yearly").tag(RecurringType.yearly)
                        }
                        .pickerStyle(.menu)
                    }

                    Section("Display") {
                        Toggle("Show in Calendar", isOn: $showInCalendar)
                    }
                }
                .navigationTitle("New Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            resetForm()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addTodo()
                        }
                        .disabled(newTodoTitle.isEmpty)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingEditSubtype) {
            NavigationStack {
                Form {
                    Section("Details") {
                        TextField("Name", text: $editName)

                        Button {
                            showingIconPicker = true
                        } label: {
                            HStack {
                                Text("Icon")
                                    .foregroundStyle(.primary)
                                Spacer()
                                if !editIcon.isEmpty {
                                    Image(systemName: editIcon)
                                        .font(.title3)
                                        .foregroundStyle(.blue)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Toggle("Show in Calendar", isOn: $editShowInCalendar)

                        Toggle("Enable Reminders", isOn: Binding(
                            get: { editRemindersEnabled },
                            set: { newValue in
                                pendingRemindersValue = newValue
                                showingRemindersToggleAlert = true
                            }
                        ))
                    }

                    Section {
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete \(subtype.type.displayName)")
                            }
                        }
                    }
                }
                .navigationTitle("Edit \(subtype.type.displayName)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingEditSubtype = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveEditedSubtype()
                        }
                        .disabled(editName.isEmpty)
                    }
                }
                .alert("Delete \(subtype.type.displayName)?", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteSubtype()
                    }
                } message: {
                    Text("This will permanently delete this \(subtype.type.displayName.lowercased()) and all \(subtype.todos.count) task\(subtype.todos.count == 1 ? "" : "s"). This action cannot be undone.")
                }
            }
            .presentationDetents([.medium])
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(selectedIcon: $editIcon)
            }
        }
        .alert("Update Calendar Visibility?", isPresented: $showingCalendarToggleAlert) {
            Button("Cancel", role: .cancel) {
                // Toggle will revert to original value
            }
            Button(pendingCalendarValue ? "Show All" : "Hide All") {
                updateAllTodosCalendarVisibility(pendingCalendarValue)
            }
        } message: {
            Text("This will \(pendingCalendarValue ? "show" : "hide") all \(subtype.todos.count) tasks in this \(subtype.type.displayName.lowercased()) \(pendingCalendarValue ? "in" : "from") the calendar view.")
        }
        .alert("Update Reminders?", isPresented: $showingRemindersToggleAlert) {
            Button("Cancel", role: .cancel) {
                // Toggle will revert to original value
            }
            Button(pendingRemindersValue ? "Enable All" : "Disable All") {
                updateAllTodosReminders(pendingRemindersValue)
            }
        } message: {
            Text("This will \(pendingRemindersValue ? "enable" : "disable") reminders for all \(subtype.todos.count) task\(subtype.todos.count == 1 ? "" : "s") in this \(subtype.type.displayName.lowercased()).")
        }
    }

    private func addTodo() {
        let newTodo = TodoItem(
            title: newTodoTitle,
            itemDescription: newTodoDescription.isEmpty ? nil : newTodoDescription,
            dueDate: newTodoDueDate,
            dueTime: newTodoDueDate,
            reminderEnabled: enableReminder,
            showInCalendar: showInCalendar,
            recurringType: recurringType,
            sortOrder: subtype.todos.count,
            subtype: subtype
        )
        modelContext.insert(newTodo)

        // Schedule notification if enabled
        if enableReminder {
            Task {
                let authorized = await notificationService.requestAuthorization()
                if authorized {
                    await notificationService.scheduleNotification(for: newTodo)
                } else {
                    newTodo.reminderEnabled = false
                }
            }
        }

        resetForm()
    }

    private func resetForm() {
        showingAddTodo = false
        newTodoTitle = ""
        newTodoDescription = ""
        newTodoDueDate = Date()
        enableReminder = false
        showInCalendar = true
        recurringType = .none
    }

    private func deleteTodos(from array: [TodoItem], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(array[index])
        }
    }

    private func prepareEditForm() {
        editName = subtype.name
        editIcon = subtype.icon ?? ""
        editShowInCalendar = subtype.showInCalendar
        editRemindersEnabled = false
    }

    private func saveEditedSubtype() {
        subtype.name = editName
        if !editIcon.isEmpty {
            subtype.icon = editIcon
        }
        subtype.showInCalendar = editShowInCalendar

        // Explicitly save the context to ensure changes persist
        do {
            try modelContext.save()
        } catch {
            print("Error saving subtype changes: \(error)")
        }

        showingEditSubtype = false
    }

    private func deleteSubtype() {
        showingEditSubtype = false
        modelContext.delete(subtype)
        dismiss()
    }

    private func updateAllTodosCalendarVisibility(_ value: Bool) {
        // Update the subtype's showInCalendar property
        subtype.showInCalendar = value

        // Update all todos in this subtype
        for todo in subtype.todos {
            todo.showInCalendar = value
        }

        // Explicitly save the context
        do {
            try modelContext.save()
        } catch {
            print("Error updating calendar visibility: \(error)")
        }
    }

    private func updateAllTodosReminders(_ value: Bool) {
        // Update the edit state
        editRemindersEnabled = value

        // Update all todos in this subtype
        for todo in subtype.todos {
            todo.reminderEnabled = value

            if value {
                // Schedule notification
                Task {
                    let authorized = await notificationService.requestAuthorization()
                    if authorized {
                        await notificationService.scheduleNotification(for: todo)
                    }
                }
            } else {
                // Cancel notification
                notificationService.cancelNotification(for: todo)
            }
        }

        // Explicitly save the context
        do {
            try modelContext.save()
        } catch {
            print("Error updating reminders: \(error)")
        }
    }
}

struct TodoRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var todo: TodoItem
    @Query private var allTodos: [TodoItem]

    private var isCompletedToday: Bool {
        guard todo.isRecurringTemplate else { return todo.completed }

        // Check if there's a completion instance for today
        return allTodos.contains { completion in
            completion.parentRecurringTodoId == todo.id &&
            completion.dueDate != nil &&
            Calendar.current.isDateInToday(completion.dueDate!)
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Completion Button
            Button {
                handleCompletion()
            } label: {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isCompletedToday ? .green : .gray)
            }
            .buttonStyle(.plain)

            // Todo Content
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.completed)

                if let description = todo.itemDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                // Due Date
                if let dueDate = todo.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(dueDate, style: .date)
                        if let dueTime = todo.dueTime {
                            Text(dueTime, style: .time)
                        }
                    }
                    .font(.caption2)
                    .foregroundStyle(todo.isOverdue ? .red : .blue)
                }

                // Recurring indicator
                if todo.recurringType != .none {
                    HStack(spacing: 4) {
                        Image(systemName: "repeat")
                        Text(todo.recurringType.displayName)
                    }
                    .font(.caption2)
                    .foregroundStyle(.purple)
                }

                // Subtasks indicator
                if !todo.subtasks.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                        Text("\(todo.subtasks.filter { $0.completed }.count)/\(todo.subtasks.count)")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Starred
            if todo.starred {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                // Delete handled by parent
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                todo.toggleStarred()
            } label: {
                Label(todo.starred ? "Unstar" : "Star", systemImage: "star")
            }
            .tint(.yellow)
        }
    }

    private func handleCompletion() {
        // Handle recurring templates differently
        if todo.isRecurringTemplate {
            // Check if there's already a completion instance for today
            if let todayCompletion = allTodos.first(where: { completion in
                completion.parentRecurringTodoId == todo.id &&
                completion.dueDate != nil &&
                Calendar.current.isDateInToday(completion.dueDate!)
            }) {
                // Already completed today - uncomplete by deleting the instance
                modelContext.delete(todayCompletion)
            } else {
                // Not completed today - create completion instance
                let completionInstance = TodoItem(
                    title: todo.title,
                    itemDescription: todo.itemDescription,
                    dueDate: Date(), // Use today's date
                    dueTime: todo.dueTime,
                    completed: true,
                    starred: todo.starred,
                    reminderEnabled: false,
                    showInCalendar: todo.showInCalendar,
                    recurringType: .none,
                    aiGenerated: todo.aiGenerated,
                    colorID: todo.colorID,
                    textureID: todo.textureID,
                    flagColor: todo.flagColor,
                    sortOrder: todo.sortOrder,
                    completedDate: Date(),
                    parentRecurringTodoId: todo.id,
                    subtype: todo.subtype
                )
                modelContext.insert(completionInstance)
            }
        } else {
            // For non-recurring todos, toggle normally
            todo.toggleCompletion()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Subtype.self, TodoItem.self, configurations: config)

    let subtype = Subtype(name: "Sample Plan", type: .plan)
    container.mainContext.insert(subtype)

    return NavigationStack {
        SubtypeDetailView(subtype: subtype)
    }
    .modelContainer(container)
}
