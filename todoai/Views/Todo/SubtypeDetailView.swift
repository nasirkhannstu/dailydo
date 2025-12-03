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
    @Bindable var subtype: Subtype

    @State private var showingAddTodo = false
    @State private var newTodoTitle = ""
    @State private var newTodoDescription = ""
    @State private var newTodoDueDate: Date?
    @State private var showDueDatePicker = false
    @State private var enableReminder = false
    @State private var recurringType: RecurringType = .none
    @State private var notificationService = NotificationService.shared

    // Edit subtype states
    @State private var showingEditSubtype = false
    @State private var showingIconPicker = false
    @State private var editName = ""
    @State private var editIcon = ""
    @State private var editShowInCalendar = false

    var incompleteTodos: [TodoItem] {
        subtype.todos.filter { !$0.completed }.sorted(by: { $0.createdDate > $1.createdDate })
    }

    var completedTodos: [TodoItem] {
        subtype.todos.filter { $0.completed }.sorted(by: { $0.completedDate ?? $0.createdDate > $1.completedDate ?? $1.createdDate })
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
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddTodo = true
                } label: {
                    Label("Add Todo", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTodo) {
            NavigationStack {
                Form {
                    Section("Task Details") {
                        TextField("Title", text: $newTodoTitle)
                        TextField("Description (optional)", text: $newTodoDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }

                    Section {
                        Toggle("Set Due Date", isOn: $showDueDatePicker)

                        if showDueDatePicker {
                            DatePicker(
                                "Due Date",
                                selection: Binding(
                                    get: { newTodoDueDate ?? Date() },
                                    set: { newTodoDueDate = $0 }
                                ),
                                displayedComponents: [.date, .hourAndMinute]
                            )

                            Toggle("Set Reminder", isOn: $enableReminder)
                                .disabled(!showDueDatePicker)
                        }
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
            }
            .presentationDetents([.medium])
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(selectedIcon: $editIcon)
            }
        }
    }

    private func addTodo() {
        let newTodo = TodoItem(
            title: newTodoTitle,
            itemDescription: newTodoDescription.isEmpty ? nil : newTodoDescription,
            dueDate: showDueDatePicker ? newTodoDueDate : nil,
            reminderEnabled: enableReminder && showDueDatePicker,
            recurringType: recurringType,
            sortOrder: subtype.todos.count,
            subtype: subtype
        )
        modelContext.insert(newTodo)

        // Schedule notification if enabled
        if enableReminder && showDueDatePicker {
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
        newTodoDueDate = nil
        showDueDatePicker = false
        enableReminder = false
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
    }

    private func saveEditedSubtype() {
        subtype.name = editName
        if !editIcon.isEmpty {
            subtype.icon = editIcon
        }
        subtype.showInCalendar = editShowInCalendar
        showingEditSubtype = false
    }
}

struct TodoRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var todo: TodoItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Completion Button
            Button {
                handleCompletion()
            } label: {
                Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(todo.completed ? .green : .gray)
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
                        await NotificationService.shared.scheduleNotification(for: nextTodo)
                    }
                }
            }
        }

        // Toggle completion of current todo
        todo.toggleCompletion()
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
