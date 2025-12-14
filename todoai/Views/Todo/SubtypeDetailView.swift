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
    @State private var recurringType: RecurringType = .dueDate
    @State private var notificationService = NotificationService.shared
    @State private var showDatePicker = false
    @State private var showRecurringOptions = false
    @FocusState private var isTodoTitleFocused: Bool

    // Edit subtype states
    @State private var showingEditSubtype = false
    @State private var showingIconPicker = false
    @State private var editName = ""
    @State private var editDescription = ""
    @State private var editIcon = ""
    @State private var editShowInCalendar = false
    @State private var editRemindersEnabled = false
    @State private var showingDeleteAlert = false
    @State private var showingCalendarToggleAlert = false
    @State private var pendingCalendarValue = false
    @State private var showingRemindersToggleAlert = false
    @State private var pendingRemindersValue = false
    @State private var isDescriptionExpanded = false

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
            return .green
        case .plan:
            return .blue
        case .list:
            return .orange
        }
    }

    var body: some View {
        List {
            // Description section (only for Habits and Plans)
            if subtype.type != .list, let description = subtype.itemDescription, !description.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        // Description icon and label
                        HStack(spacing: 8) {
                            Image(systemName: "text.alignleft")
                                .font(.caption)
                                .foregroundStyle(fabColor)
                            Text("About")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(fabColor)
                        }

                        // Description text with expand/collapse
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .lineLimit(isDescriptionExpanded ? nil : 2)
                            .animation(.easeInOut(duration: 0.2), value: isDescriptionExpanded)

                        // Show more/less button (only if description is long enough)
                        if description.count > 100 {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isDescriptionExpanded.toggle()
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(isDescriptionExpanded ? "Show Less" : "Show More")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Image(systemName: isDescriptionExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                                        .font(.caption)
                                }
                                .foregroundStyle(fabColor)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(fabColor.opacity(0.05))
            }

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
                Section {
                    VStack(spacing: 20) {
                        Image(systemName: "checklist")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)

                        VStack(spacing: 8) {
                            Text("No Tasks Yet")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text("Add your first task to get started")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Button {
                            showingAddTodo = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.body)
                                Text("Create First Todo")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(fabColor.gradient)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                }
                .listRowBackground(Color.clear)
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
        .onChange(of: showingAddTodo) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    isTodoTitleFocused = true
                }
            }
        }
        .sheet(isPresented: $showingAddTodo) {
            VStack(spacing: 16) {
                // Title field
                TextField("Task name", text: $newTodoTitle)
                    .font(.title3)
                    .focused($isTodoTitleFocused)
                    .padding()
                    .padding(.horizontal)
                    .padding(.top, 20)

                // Icon buttons row
                HStack(spacing: 12) {
                    // Date/Time button
                    Button {
                        withAnimation {
                            showDatePicker.toggle()
                            if showDatePicker {
                                showRecurringOptions = false
                            }
                        }
                    } label: {
                        Image(systemName: showDatePicker ? "clock.fill" : "clock")
                            .font(.body)
                            .foregroundStyle(showDatePicker ? .white : fabColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(showDatePicker ? fabColor : fabColor.opacity(0.1))
                            )
                    }

                    // Reminder button
                    Button {
                        enableReminder.toggle()
                    } label: {
                        Image(systemName: enableReminder ? "bell.badge.fill" : "bell")
                            .font(.body)
                            .foregroundStyle(enableReminder ? .white : fabColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(enableReminder ? fabColor : fabColor.opacity(0.1))
                            )
                    }

                    // Repeat button
                    Button {
                        withAnimation {
                            showRecurringOptions.toggle()
                            if showRecurringOptions {
                                showDatePicker = false
                            }
                        }
                    } label: {
                        Image(systemName: (recurringType != .dueDate && recurringType != .oneTime) ? "repeat.circle.fill" : "repeat")
                            .font(.body)
                            .foregroundStyle((recurringType != .dueDate && recurringType != .oneTime) ? .white : fabColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill((recurringType != .dueDate && recurringType != .oneTime) ? fabColor : fabColor.opacity(0.1))
                            )
                    }

                    // Calendar visibility button
                    Button {
                        showInCalendar.toggle()
                    } label: {
                        Image(systemName: showInCalendar ? "calendar.badge.checkmark" : "calendar.badge.minus")
                            .font(.body)
                            .foregroundStyle(showInCalendar ? .white : fabColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(showInCalendar ? fabColor : fabColor.opacity(0.1))
                            )
                    }

                    Spacer()

                    // Add button
                    Button {
                        addTodo()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(newTodoTitle.isEmpty ? Color.gray : fabColor)
                            )
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding(.horizontal)

                // Expandable date picker section
                if showDatePicker {
                    VStack(spacing: 12) {
                        DatePicker("Date", selection: $newTodoDueDate, displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .padding(.horizontal)

                        DatePicker("Time", selection: $newTodoDueDate, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.wheel)
                            .padding(.horizontal)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                // Expandable recurring options section
                if showRecurringOptions {
                    VStack(spacing: 8) {
                        ForEach([RecurringType.dueDate, .oneTime, .daily, .weekly, .monthly, .yearly], id: \.self) { type in
                            Button {
                                recurringType = type
                                withAnimation {
                                    showRecurringOptions = false
                                }
                            } label: {
                                HStack {
                                    Text(type.displayName)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if recurringType == type {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(fabColor)
                                    }
                                }
                                .padding()
                                .background(recurringType == type ? fabColor.opacity(0.1) : Color.clear)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Spacer()
            }
            .presentationDetents([.height(showDatePicker ? 550 : (showRecurringOptions ? 400 : 200))])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingEditSubtype) {
            NavigationStack {
                Form {
                    Section("Details") {
                        TextField("Name", text: $editName)

                        // Show description field only for Habits and Plans
                        if subtype.type != .list {
                            TextField("Description (optional)", text: $editDescription, axis: .vertical)
                                .lineLimit(2...4)
                        }

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

        // Save immediately to persist changes
        try? modelContext.save()

        // Schedule notification if enabled
        if enableReminder {
            Task {
                let authorized = await notificationService.requestAuthorization()
                if authorized {
                    await notificationService.scheduleNotification(for: newTodo)
                } else {
                    newTodo.reminderEnabled = false
                    try? modelContext.save()
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
        recurringType = .dueDate
        showDatePicker = false
        showRecurringOptions = false
        isTodoTitleFocused = false
    }

    private func deleteTodos(from array: [TodoItem], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(array[index])
        }
    }

    private func prepareEditForm() {
        editName = subtype.name
        editDescription = subtype.itemDescription ?? ""
        editIcon = subtype.icon
        editShowInCalendar = subtype.showInCalendar
        editRemindersEnabled = false
    }

    private func saveEditedSubtype() {
        subtype.name = editName
        subtype.itemDescription = editDescription.isEmpty ? nil : editDescription
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
                if todo.recurringType != .dueDate && todo.recurringType != .oneTime {
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

            // Priority indicator
            if todo.priority != .none {
                Circle()
                    .fill(todo.priority.color)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                // Delete handled by parent
            } label: {
                Label("Delete", systemImage: "trash")
            }
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
                    priority: todo.priority,
                    reminderEnabled: false,
                    showInCalendar: todo.showInCalendar,
                    recurringType: .dueDate,
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
