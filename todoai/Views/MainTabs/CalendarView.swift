//
//  CalendarView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTodos: [TodoItem]
    @Query private var allSubtypes: [Subtype]
    @Query private var dailyNotes: [DailyNote]

    @State private var selectedDate = Date()
    @State private var currentWeekOffset = 0
    @State private var selectedStatusFilter: StatusFilter = .all
    @State private var selectedTypeFilter: TypeFilter = .all
    @State private var showingMonthYearPicker = false
    @State private var pickerDate = Date()
    @State private var showingFilterSheet = false
    @State private var focusedTodo: TodoItem? = nil
    @State private var selectedTodo: TodoItem? = nil
    @State private var showingAddTodo = false
    @State private var showingDailyNote = false
    @State private var newTodoTitle = ""
    @State private var newTodoDescription = ""
    @State private var newTodoDueDate: Date = Date()
    @State private var enableReminder = false
    @State private var showInCalendar = true
    @State private var recurringType: RecurringType = .oneTime
    @State private var notificationService = NotificationService.shared
    @State private var showDatePicker = false
    @State private var showRecurringOptions = false
    @FocusState private var isTodoTitleFocused: Bool

    private let calendar = Calendar.current

    var currentWeekDates: [Date] {
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: Date())!))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var todosForSelectedDate: [TodoItem] {
        // Cache frequently used values
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: selectedDate)

        // Build a set of completion instance parent IDs for O(1) lookup
        var completionInstanceParentIds = Set<UUID>()
        var filtered: [TodoItem] = []

        // Single pass through all todos
        for todo in allTodos {
            // Skip if not shown in calendar
            guard todo.showInCalendar else { continue }

            // Track completion instances for later filtering
            if todo.isCompletionInstance, let parentId = todo.parentRecurringTodoId {
                if let dueDate = todo.dueDate, calendar.isDate(dueDate, inSameDayAs: selectedDate) {
                    completionInstanceParentIds.insert(parentId)

                    // Apply filters and add if passes
                    if passesFilters(todo) {
                        filtered.append(todo)
                    }
                }
                continue
            }

            // Handle based on recurring type
            switch todo.recurringType {
            case .dueDate:
                // Show only on specific due date
                guard let dueDate = todo.dueDate else { continue }
                if calendar.isDate(dueDate, inSameDayAs: selectedDate) && passesFilters(todo) {
                    filtered.append(todo)
                }

            case .oneTime:
                if todo.completed {
                    // If completed, show only on completion date
                    guard let dueDate = todo.dueDate else { continue }
                    if calendar.isDate(dueDate, inSameDayAs: selectedDate) && passesFilters(todo) {
                        filtered.append(todo)
                    }
                } else {
                    // If not completed, show on today and future dates
                    if selectedDay >= today && passesFilters(todo) {
                        filtered.append(todo)
                    }
                }

            case .daily, .weekly, .monthly, .yearly:
                // Handle recurring templates
                guard let originalDueDate = todo.dueDate else { continue }
                let originalDay = calendar.startOfDay(for: originalDueDate)

                // Check if date is within range
                guard selectedDay >= originalDay else { continue }

                // Check end date if exists
                if let endDate = todo.recurringEndDate {
                    let endDay = calendar.startOfDay(for: endDate)
                    guard selectedDay <= endDay else { continue }
                }

                // Check if should appear on this date based on recurrence pattern
                let shouldAppear: Bool
                switch todo.recurringType {
                case .daily:
                    shouldAppear = true

                case .weekly:
                    let originalWeekday = calendar.component(.weekday, from: originalDueDate)
                    let targetWeekday = calendar.component(.weekday, from: selectedDate)
                    shouldAppear = originalWeekday == targetWeekday

                case .monthly:
                    let originalDayOfMonth = calendar.component(.day, from: originalDueDate)
                    let targetDayOfMonth = calendar.component(.day, from: selectedDate)
                    shouldAppear = originalDayOfMonth == targetDayOfMonth

                case .yearly:
                    let originalMonth = calendar.component(.month, from: originalDueDate)
                    let originalDayOfMonth = calendar.component(.day, from: originalDueDate)
                    let targetMonth = calendar.component(.month, from: selectedDate)
                    let targetDayOfMonth = calendar.component(.day, from: selectedDate)
                    shouldAppear = originalMonth == targetMonth && originalDayOfMonth == targetDayOfMonth

                default:
                    shouldAppear = false
                }

                // Only add if should appear and passes filters
                // Will filter out those with completion instances below
                if shouldAppear && passesFilters(todo) {
                    filtered.append(todo)
                }
            }
        }

        // Remove recurring templates that have completion instances
        filtered.removeAll { todo in
            todo.isRecurringTemplate && completionInstanceParentIds.contains(todo.id)
        }

        // Sort by time
        return filtered.sorted { todo1, todo2 in
            let time1 = todo1.dueTime ?? todo1.dueDate ?? Date()
            let time2 = todo2.dueTime ?? todo2.dueDate ?? Date()
            return time1 < time2
        }
    }

    // Helper function to check if todo passes status and type filters
    private func passesFilters(_ todo: TodoItem) -> Bool {
        // Check status filter
        switch selectedStatusFilter {
        case .all:
            break
        case .active:
            if todo.completed { return false }
        case .completed:
            if !todo.completed { return false }
        }

        // Check type filter
        switch selectedTypeFilter {
        case .all:
            break
        case .habits:
            if todo.subtype?.type != .habit { return false }
        case .plans:
            if todo.subtype?.type != .plan { return false }
        case .lists:
            if todo.subtype?.type != .list { return false }
        }

        return true
    }

    // MARK: - Daily Note Helpers

    var noteForSelectedDate: DailyNote? {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        return dailyNotes.first { calendar.isDate($0.date, inSameDayAs: startOfDay) }
    }

    var hasNoteForDate: Bool {
        guard let note = noteForSelectedDate else { return false }
        let hasText = !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return note.noteMood != .meh || hasText
    }

    func getOrCreateNote(for date: Date) -> DailyNote {
        let startOfDay = calendar.startOfDay(for: date)

        // Check if note exists
        if let existingNote = dailyNotes.first(where: {
            calendar.isDate($0.date, inSameDayAs: startOfDay)
        }) {
            return existingNote
        }

        // Create new note
        let newNote = DailyNote(date: startOfDay)
        modelContext.insert(newNote)
        return newNote
    }

    func hasNote(for date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)
        if let note = dailyNotes.first(where: { calendar.isDate($0.date, inSameDayAs: startOfDay) }) {
            let hasText = !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return note.noteMood != .meh || hasText
        }
        return false
    }

    func moodColor(for date: Date) -> Color {
        let startOfDay = calendar.startOfDay(for: date)
        if let note = dailyNotes.first(where: { calendar.isDate($0.date, inSameDayAs: startOfDay) }) {
            return note.noteMood.color
        }
        return NoteMood.meh.color
    }

    var selectedDateMoodColor: Color {
        noteForSelectedDate?.noteMood.color ?? NoteMood.meh.color
    }

    // Check if a recurring todo should appear on a given date
    func shouldRecurringTodoAppear(todo: TodoItem, on date: Date) -> Bool {
        guard let originalDueDate = todo.dueDate else { return false }

        switch todo.recurringType {
        case .dueDate, .oneTime:
            return false // Handled separately in todosForSelectedDate

        case .daily:
            return true // Appears every day

        case .weekly:
            // Appears if day of week matches
            let originalWeekday = calendar.component(.weekday, from: originalDueDate)
            let targetWeekday = calendar.component(.weekday, from: date)
            return originalWeekday == targetWeekday

        case .monthly:
            // Appears if day of month matches
            let originalDay = calendar.component(.day, from: originalDueDate)
            let targetDay = calendar.component(.day, from: date)
            return originalDay == targetDay

        case .yearly:
            // Appears if day and month match
            let originalMonth = calendar.component(.month, from: originalDueDate)
            let originalDay = calendar.component(.day, from: originalDueDate)
            let targetMonth = calendar.component(.month, from: date)
            let targetDay = calendar.component(.day, from: date)
            return originalMonth == targetMonth && originalDay == targetDay
        }
    }

    // Check if a recurring template has a completion instance for a given date
    func hasCompletionInstance(for template: TodoItem, on date: Date) -> Bool {
        return allTodos.contains { todo in
            todo.parentRecurringTodoId == template.id &&
            todo.dueDate != nil &&
            calendar.isDate(todo.dueDate!, inSameDayAs: date)
        }
    }

    func taskCount(for date: Date) -> Int {
        // Cache frequently used values
        let today = calendar.startOfDay(for: Date())
        let targetDay = calendar.startOfDay(for: date)

        var count = 0
        var completionInstanceParentIds = Set<UUID>()

        // Single pass through all todos
        for todo in allTodos {
            guard todo.showInCalendar else { continue }

            // Track completion instances
            if todo.isCompletionInstance, let parentId = todo.parentRecurringTodoId {
                if let dueDate = todo.dueDate, calendar.isDate(dueDate, inSameDayAs: date) {
                    completionInstanceParentIds.insert(parentId)
                    count += 1
                }
                continue
            }

            // Count based on recurring type
            switch todo.recurringType {
            case .dueDate:
                if let dueDate = todo.dueDate, calendar.isDate(dueDate, inSameDayAs: date) {
                    count += 1
                }

            case .oneTime:
                if todo.completed {
                    if let dueDate = todo.dueDate, calendar.isDate(dueDate, inSameDayAs: date) {
                        count += 1
                    }
                } else {
                    if targetDay >= today {
                        count += 1
                    }
                }

            case .daily, .weekly, .monthly, .yearly:
                guard let originalDueDate = todo.dueDate else { continue }
                let originalDay = calendar.startOfDay(for: originalDueDate)

                // Check if within range
                guard targetDay >= originalDay else { continue }

                if let endDate = todo.recurringEndDate {
                    let endDay = calendar.startOfDay(for: endDate)
                    guard targetDay <= endDay else { continue }
                }

                // Check recurrence pattern
                let shouldAppear: Bool
                switch todo.recurringType {
                case .daily:
                    shouldAppear = true

                case .weekly:
                    let originalWeekday = calendar.component(.weekday, from: originalDueDate)
                    let targetWeekday = calendar.component(.weekday, from: date)
                    shouldAppear = originalWeekday == targetWeekday

                case .monthly:
                    let originalDayOfMonth = calendar.component(.day, from: originalDueDate)
                    let targetDayOfMonth = calendar.component(.day, from: date)
                    shouldAppear = originalDayOfMonth == targetDayOfMonth

                case .yearly:
                    let originalMonth = calendar.component(.month, from: originalDueDate)
                    let originalDayOfMonth = calendar.component(.day, from: originalDueDate)
                    let targetMonth = calendar.component(.month, from: date)
                    let targetDayOfMonth = calendar.component(.day, from: date)
                    shouldAppear = originalMonth == targetMonth && originalDayOfMonth == targetDayOfMonth

                default:
                    shouldAppear = false
                }

                // Only count if should appear and doesn't have completion instance
                if shouldAppear && !completionInstanceParentIds.contains(todo.id) {
                    count += 1
                }
            }
        }

        return count
    }

    var body: some View {
        // Compute todos once for this render
        let todos = todosForSelectedDate

        return NavigationStack {
            VStack(spacing: 0) {
                // Month/Year Header with Gradient Background
                VStack(spacing: 8) {
                    HStack {
                        Button {
                            withAnimation {
                                currentWeekOffset -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                        }

                        Spacer()

                        Button {
                            pickerDate = currentWeekDates[3] // Set to middle of current week
                            showingMonthYearPicker = true
                        } label: {
                            HStack(spacing: 4) {
                                Text(monthYearText)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Button {
                            withAnimation {
                                currentWeekOffset += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // Compact Week View
                    HStack(spacing: 0) {
                        ForEach(currentWeekDates, id: \.self) { date in
                            DayButton(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(date),
                                taskCount: taskCount(for: date),
                                hasNote: hasNote(for: date),
                                noteMoodColor: moodColor(for: date)
                            ) {
                                withAnimation {
                                    selectedDate = date
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.bottom, 4)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.6, green: 0.4, blue: 0.9),
                            Color(red: 0.5, green: 0.4, blue: 0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            if value.translation.width < 0 {
                                // Swiped left - next week
                                withAnimation {
                                    currentWeekOffset += 1
                                }
                            } else if value.translation.width > 0 {
                                // Swiped right - previous week
                                withAnimation {
                                    currentWeekOffset -= 1
                                }
                            }
                        }
                )

                // Quick Actions
                HStack {
                    if !calendar.isDateInToday(selectedDate) {
                        Button {
                            withAnimation {
                                selectedDate = Date()
                                currentWeekOffset = 0
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.uturn.left")
                                Text("Today")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Text("\(todos.filter { !$0.completed }.count) active")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button {
                            showingFilterSheet = true
                        } label: {
                            Text("Filter")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider()

                // Tasks List
                List {
                    if todos.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: calendar.isDateInToday(selectedDate) ? "checkmark.circle.fill" : "calendar")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)

                            VStack(spacing: 4) {
                                Text(calendar.isDateInToday(selectedDate) ? "All Clear!" : "No Tasks")
                                    .font(.title3)
                                    .fontWeight(.semibold)

                                Text(calendar.isDateInToday(selectedDate) ? "You're all caught up for today" : "No tasks scheduled for this date")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    } else {
                        ForEach(todos) { todo in
                            TodoCalendarRow(
                                todo: todo,
                                completionDate: selectedDate,
                                onFocus: {
                                    focusedTodo = todo
                                },
                                onTap: {
                                    selectedTodo = todo
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }

                    // Daily Note Button (always shown at bottom)
                    HStack {
                        Spacer()

                        Button {
                            showingDailyNote = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "note.text")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)

                                Text("Daily Note")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(hasNoteForDate ? selectedDateMoodColor.gradient : Color.blue.gradient)
                            )
                            .shadow(color: (hasNoteForDate ? selectedDateMoodColor : Color.blue).opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                .listStyle(.plain)
                .background(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.05),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scrollContentBackground(.hidden)
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                // Add Todo Button
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
                                .fill(Color.purple.gradient)
                        )
                        .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 4)
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
            .sheet(isPresented: $showingMonthYearPicker) {
                MonthYearPickerView(selectedDate: $pickerDate) {
                    jumpToDate(pickerDate)
                    showingMonthYearPicker = false
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterSheetView(
                    selectedStatusFilter: $selectedStatusFilter,
                    selectedTypeFilter: $selectedTypeFilter
                )
            }
            .sheet(isPresented: $showingDailyNote) {
                let note = getOrCreateNote(for: selectedDate)
                DailyNoteView(note: note)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(12)
            }
            .fullScreenCover(item: $focusedTodo) { todo in
                let activeTodos = todos.filter { !$0.completed }
                FocusView(
                    initialTodo: todo,
                    allTodosForDay: activeTodos
                ) {
                    focusedTodo = nil
                }
            }
            .navigationDestination(item: $selectedTodo) { todo in
                TodoDetailView(todo: todo, completionContextDate: selectedDate)
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
                                .foregroundStyle(showDatePicker ? .white : .purple)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(showDatePicker ? Color.purple : Color.purple.opacity(0.1))
                                )
                        }

                        // Reminder button
                        Button {
                            enableReminder.toggle()
                        } label: {
                            Image(systemName: enableReminder ? "bell.badge.fill" : "bell")
                                .font(.body)
                                .foregroundStyle(enableReminder ? .white : .purple)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(enableReminder ? Color.purple : Color.purple.opacity(0.1))
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
                                .foregroundStyle((recurringType != .dueDate && recurringType != .oneTime) ? .white : .purple)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill((recurringType != .dueDate && recurringType != .oneTime) ? Color.purple : Color.purple.opacity(0.1))
                                )
                        }

                        // Calendar visibility button
                        Button {
                            showInCalendar.toggle()
                        } label: {
                            Image(systemName: showInCalendar ? "calendar.badge.checkmark" : "calendar.badge.minus")
                                .font(.body)
                                .foregroundStyle(showInCalendar ? .white : .purple)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(showInCalendar ? Color.purple : Color.purple.opacity(0.1))
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
                                        .fill(newTodoTitle.isEmpty ? Color.gray : Color.purple)
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
                                                .foregroundStyle(.purple)
                                        }
                                    }
                                    .padding()
                                    .background(recurringType == type ? Color.purple.opacity(0.1) : Color.clear)
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
                .onAppear {
                    // Set the date to the selected calendar date
                    newTodoDueDate = selectedDate
                }
            }
        }
    }

    private func addTodo() {
        // Find or create "Random" list
        let allLists = allSubtypes.filter { $0.type == .list }
        let randomList: Subtype
        if let existingRandomList = allLists.first(where: { $0.name == "Random" }) {
            randomList = existingRandomList
        } else {
            // Create new "Random" list
            randomList = Subtype(
                name: "Random",
                type: .list,
                icon: "tray.fill",
                sortOrder: allLists.count
            )
            modelContext.insert(randomList)
        }

        // Create todo with Random list as subtype
        let newTodo = TodoItem(
            title: newTodoTitle,
            itemDescription: newTodoDescription.isEmpty ? nil : newTodoDescription,
            dueDate: newTodoDueDate,
            dueTime: newTodoDueDate,
            reminderEnabled: enableReminder,
            showInCalendar: showInCalendar,
            recurringType: recurringType,
            sortOrder: randomList.todos.count,
            subtype: randomList
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

    private func jumpToDate(_ date: Date) {
        // Calculate week offset from today to the selected date
        let today = Date()
        let weeksBetween = calendar.dateComponents([.weekOfYear], from: today, to: date).weekOfYear ?? 0

        withAnimation {
            currentWeekOffset = weeksBetween
            // Set selected date to the first day of that week
            if let firstDayOfWeek = currentWeekDates.first {
                selectedDate = firstDayOfWeek
            }
        }
    }

    private var monthYearText: String {
        let referenceDate = currentWeekDates[3] // Middle of week
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: referenceDate)
    }
}

// MARK: - Day Button Component

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let taskCount: Int
    let hasNote: Bool
    let noteMoodColor: Color
    let action: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Text(dayName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.7))

                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 15, weight: isSelected ? .bold : .semibold))
                    .foregroundStyle(isSelected ? Color(red: 0.5, green: 0.4, blue: 0.85) : .white)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.white : (isToday ? Color.white.opacity(0.2) : Color.clear))
                    )
                    .overlay(
                        Circle()
                            .stroke(isToday && !isSelected ? Color.white.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
                    .overlay(
                        // Mood color ring for notes
                        Circle()
                            .stroke(hasNote ? noteMoodColor : Color.clear, lineWidth: 2)
                            .frame(width: 40, height: 40)
                    )

                if taskCount > 0 {
                    Circle()
                        .fill(isSelected ? .white : .white.opacity(0.8))
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

// MARK: - Todo Calendar Row

struct TodoCalendarRow: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var todo: TodoItem
    let completionDate: Date
    let onFocus: () -> Void
    let onTap: () -> Void

    var isHabit: Bool {
        todo.subtype?.type == .habit
    }

    var subtypeColor: Color {
        switch todo.subtype?.type {
        case .habit:
            return .green
        case .plan:
            return .blue
        case .list:
            return .orange
        case .none:
            return .blue
        }
    }

    var body: some View {
        if isHabit {
            // Simple flat design for Habits
            habitRow
        } else {
            // Card design for Plans and Lists
            planListRow
        }
    }

    // MARK: - Habit Row (Unified with Left Bar)
    private var habitRow: some View {
        HStack(spacing: 0) {
            // Continuous left bar (full height, no gaps)
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 1)

            // Space between line and card
            Spacer()
                .frame(width: 8)

            // White card with content
            Button {
                onTap()
            } label: {
                HStack(spacing: 0) {
                    // Time with AM/PM
                    if let dueTime = todo.dueTime {
                        VStack(alignment: .center, spacing: 1) {
                            Text(timeString(from: dueTime))
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .foregroundStyle(todo.completed ? .secondary : .primary)
                            Text(amPMString(from: dueTime))
                                .font(.system(size: 7))
                                .foregroundStyle(todo.completed ? .secondary : .secondary)
                        }
                        .frame(width: 38, alignment: .center)
                    } else {
                        Spacer()
                            .frame(width: 38)
                    }

                    // Title and metadata
                    VStack(alignment: .leading, spacing: 2) {
                        Text(todo.title)
                            .font(.system(size: 13))
                            .strikethrough(todo.completed)
                            .foregroundStyle(todo.completed ? .secondary : .primary)
                            .lineLimit(1)

                        // Metadata: subtype, recurring, starred
                        HStack(spacing: 6) {
                            if let subtype = todo.subtype {
                                HStack(spacing: 3) {
                                    if !subtype.icon.isEmpty {
                                        Image(systemName: subtype.icon)
                                            .font(.system(size: 9))
                                    }
                                    Text(subtype.name.prefix(10))
                                        .font(.system(size: 9))
                                }
                                .foregroundStyle(subtypeColor)
                            }

                            // Show recurring type for all types
                            HStack(spacing: 3) {
                                Image(systemName: todo.recurringType.icon)
                                    .font(.system(size: 9))
                                Text(todo.recurringType.displayName)
                                    .font(.system(size: 9))
                            }
                            .foregroundStyle(.purple)

                            if todo.starred {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.system(size: 9))
                            }
                        }
                    }
                    .padding(.leading, 6)

                    Spacer()

                    // Circle checkbox with margin
                    Button {
                        withAnimation {
                            handleCompletion()
                        }
                    } label: {
                        Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18))
                            .foregroundStyle(todo.completed ? .green : .gray)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 8)
                }
                .padding(.vertical, 6)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color(.systemGray4).opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    // MARK: - Plan/List Row (Card)
    private var planListRow: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .center, spacing: 0) {
                // Time on the left with full-height gray background
                if let dueTime = todo.dueTime {
                    VStack(spacing: 2) {
                        Text(timeString(from: dueTime))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(todo.completed ? .secondary : .primary)

                        Text(amPMString(from: dueTime))
                            .font(.system(size: 9))
                            .fontWeight(.medium)
                            .foregroundStyle(todo.completed ? .tertiary : .secondary)
                    }
                    .frame(width: 60)
                    .frame(maxHeight: .infinity)
                    .background(Color.blue.opacity(0.08))
                } else {
                    VStack(spacing: 2) {
                        Text("")
                            .font(.caption)
                        Text("")
                            .font(.system(size: 9))
                    }
                    .frame(width: 60)
                    .frame(maxHeight: .infinity)
                    .background(Color.blue.opacity(0.08))
                }

                // Title and details in the middle
                VStack(alignment: .leading, spacing: 4) {
                    Text(todo.title)
                        .font(.body)
                        .strikethrough(todo.completed)
                        .foregroundStyle(todo.completed ? .secondary : .primary)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        if let subtype = todo.subtype {
                            HStack(spacing: 4) {
                                if !subtype.icon.isEmpty {
                                    Image(systemName: subtype.icon)
                                }
                                Text(subtype.name.prefix(10))
                            }
                            .font(.caption2)
                            .foregroundStyle(subtypeColor)
                        }

                        // Show recurring type for all types
                        HStack(spacing: 4) {
                            Image(systemName: todo.recurringType.icon)
                            Text(todo.recurringType.displayName)
                        }
                        .font(.caption2)
                        .foregroundStyle(.purple)

                        if todo.starred {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption2)
                        }

                        // Show Focus button only for Plans and Lists (not Habits)
                        if !todo.completed {
                            Button {
                                onFocus()
                            } label: {
                                Text("Focus")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.purple.gradient)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.leading, 12)
                .padding(.vertical, 12)

                Spacer()

                // Circle checkbox on the right
                Button {
                    withAnimation {
                        handleCompletion()
                    }
                } label: {
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(todo.completed ? .green : .gray)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private func handleCompletion() {
        // Special handling for oneTime type
        if todo.recurringType == .oneTime && !todo.completed {
            let now = Date()

            // Create a new completed todo with today's date
            let completedTodo = TodoItem(
                title: todo.title,
                itemDescription: todo.itemDescription,
                dueDate: now,
                dueTime: now,
                completed: true,
                starred: todo.starred,
                reminderEnabled: false,
                showInCalendar: todo.showInCalendar,
                recurringType: .oneTime,
                aiGenerated: todo.aiGenerated,
                colorID: todo.colorID,
                textureID: todo.textureID,
                flagColor: todo.flagColor,
                sortOrder: todo.sortOrder,
                completedDate: now,
                subtype: todo.subtype
            )

            // Insert new completed todo
            modelContext.insert(completedTodo)

            // Delete the original todo
            modelContext.delete(todo)

            // Save context
            try? modelContext.save()
            return
        }

        // Check if this is a recurring template being marked as complete
        if !todo.completed && todo.isRecurringTemplate {
            // Create a completion instance instead of marking template as complete
            let completionInstance = TodoItem(
                title: todo.title,
                itemDescription: todo.itemDescription,
                dueDate: completionDate, // Use the date being viewed/completed for
                dueTime: todo.dueTime,
                completed: true,
                starred: todo.starred,
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
        } else {
            // For non-recurring or completion instances, toggle normally
            todo.toggleCompletion()
        }
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: date)
    }

    private func amPMString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter.string(from: date)
    }
}

// MARK: - Filter Components

enum StatusFilter {
    case all, active, completed
}

enum TypeFilter {
    case all, habits, plans, lists
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color(.systemGray5))
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Sheet

struct FilterSheetView: View {
    @Binding var selectedStatusFilter: StatusFilter
    @Binding var selectedTypeFilter: TypeFilter
    @Environment(\.dismiss) private var dismiss

    var hasActiveFilters: Bool {
        selectedStatusFilter != .all || selectedTypeFilter != .all
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Status") {
                    FilterRow(
                        title: "All",
                        icon: "circle.grid.3x3.fill",
                        isSelected: selectedStatusFilter == .all
                    ) {
                        withAnimation {
                            selectedStatusFilter = .all
                            dismiss()
                        }
                    }

                    FilterRow(
                        title: "Active",
                        icon: "circle",
                        isSelected: selectedStatusFilter == .active
                    ) {
                        withAnimation {
                            selectedStatusFilter = .active
                            dismiss()
                        }
                    }

                    FilterRow(
                        title: "Completed",
                        icon: "checkmark.circle.fill",
                        isSelected: selectedStatusFilter == .completed
                    ) {
                        withAnimation {
                            selectedStatusFilter = .completed
                            dismiss()
                        }
                    }
                }

                Section("Type") {
                    FilterRow(
                        title: "All Types",
                        icon: "square.grid.2x2.fill",
                        isSelected: selectedTypeFilter == .all
                    ) {
                        withAnimation {
                            selectedTypeFilter = .all
                            dismiss()
                        }
                    }

                    FilterRow(
                        title: "Habits",
                        icon: "repeat.circle.fill",
                        isSelected: selectedTypeFilter == .habits
                    ) {
                        withAnimation {
                            selectedTypeFilter = .habits
                            dismiss()
                        }
                    }

                    FilterRow(
                        title: "Plans",
                        icon: "calendar.badge.checkmark",
                        isSelected: selectedTypeFilter == .plans
                    ) {
                        withAnimation {
                            selectedTypeFilter = .plans
                            dismiss()
                        }
                    }

                    FilterRow(
                        title: "Lists",
                        icon: "list.bullet.circle.fill",
                        isSelected: selectedTypeFilter == .lists
                    ) {
                        withAnimation {
                            selectedTypeFilter = .lists
                            dismiss()
                        }
                    }
                }

                if hasActiveFilters {
                    Section {
                        Button {
                            withAnimation {
                                selectedStatusFilter = .all
                                selectedTypeFilter = .all
                            }
                        } label: {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                Text("Clear All Filters")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct FilterRow: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .frame(width: 28)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Month/Year Picker

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    let onDone: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Month",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()

                Spacer()
            }
            .navigationTitle("Jump to Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: [Subtype.self, TodoItem.self])
}
