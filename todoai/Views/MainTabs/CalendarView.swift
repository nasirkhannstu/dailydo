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
    @State private var newTodoTitle = ""
    @State private var newTodoDescription = ""
    @State private var newTodoDueDate: Date = Date()
    @State private var enableReminder = false
    @State private var showInCalendar = true
    @State private var recurringType: RecurringType = .none
    @State private var notificationService = NotificationService.shared

    private let calendar = Calendar.current

    var currentWeekDates: [Date] {
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: Date())!))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var todosForSelectedDate: [TodoItem] {
        // 1. Get regular todos and completion instances for this date
        // Exclude recurring templates - they are handled separately below
        var filtered = allTodos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            guard calendar.isDate(dueDate, inSameDayAs: selectedDate) && todo.showInCalendar else { return false }

            // Only include non-recurring todos OR completion instances
            // Exclude recurring templates (they're added via the recurring logic below)
            return !todo.isRecurringTemplate
        }

        // 2. Get recurring templates that should appear on this date
        let recurringTemplates = allTodos.filter { todo in
            guard todo.isRecurringTemplate, todo.showInCalendar else { return false }
            guard let originalDueDate = todo.dueDate else { return false }

            // Only show if selectedDate is on or after the original start date
            guard selectedDate >= calendar.startOfDay(for: originalDueDate) else { return false }

            // Check end date if it exists
            if let endDate = todo.recurringEndDate {
                guard selectedDate <= calendar.startOfDay(for: endDate) else { return false }
            }

            return shouldRecurringTodoAppear(todo: todo, on: selectedDate)
        }

        // 3. Filter out recurring templates that already have a completion instance for this date
        let recurringToShow = recurringTemplates.filter { template in
            !hasCompletionInstance(for: template, on: selectedDate)
        }

        // 4. Combine regular todos and recurring templates
        filtered.append(contentsOf: recurringToShow)

        // Apply status filter
        switch selectedStatusFilter {
        case .all:
            break
        case .active:
            filtered = filtered.filter { !$0.completed }
        case .completed:
            filtered = filtered.filter { $0.completed }
        }

        // Apply type filter
        switch selectedTypeFilter {
        case .all:
            break
        case .habits:
            filtered = filtered.filter { $0.subtype?.type == .habit }
        case .plans:
            filtered = filtered.filter { $0.subtype?.type == .plan }
        case .lists:
            filtered = filtered.filter { $0.subtype?.type == .list }
        }

        return filtered.sorted { todo1, todo2 in
            // Sort by time first
            let time1 = todo1.dueTime ?? todo1.dueDate ?? Date()
            let time2 = todo2.dueTime ?? todo2.dueDate ?? Date()
            return time1 < time2
        }
    }

    // Check if a recurring todo should appear on a given date
    func shouldRecurringTodoAppear(todo: TodoItem, on date: Date) -> Bool {
        guard let originalDueDate = todo.dueDate else { return false }

        switch todo.recurringType {
        case .none:
            return false

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
        // Count regular todos and completion instances for this date
        // Exclude recurring templates - they are counted separately below
        let count = allTodos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            guard calendar.isDate(dueDate, inSameDayAs: date) && todo.showInCalendar else { return false }

            // Only count non-recurring todos OR completion instances
            return !todo.isRecurringTemplate
        }.count

        // Count recurring templates that should appear on this date
        let recurringCount = allTodos.filter { todo in
            guard todo.isRecurringTemplate, todo.showInCalendar else { return false }
            guard let originalDueDate = todo.dueDate else { return false }
            guard date >= calendar.startOfDay(for: originalDueDate) else { return false }

            // Check end date if it exists
            if let endDate = todo.recurringEndDate {
                guard date <= calendar.startOfDay(for: endDate) else { return false }
            }

            // Only count if it should appear and doesn't have a completion instance
            return shouldRecurringTodoAppear(todo: todo, on: date) &&
                   !hasCompletionInstance(for: todo, on: date)
        }.count

        return count + recurringCount
    }

    var body: some View {
        NavigationStack {
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
                                taskCount: taskCount(for: date)
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
                        Text("\(todosForSelectedDate.filter { !$0.completed }.count) active")
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
                    if todosForSelectedDate.isEmpty {
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
                        ForEach(todosForSelectedDate) { todo in
                            TodoCalendarRow(
                                todo: todo,
                                completionDate: selectedDate,
                                onFocus: {
                                    print("🔵 Focus button tapped for: \(todo.title)")
                                    focusedTodo = todo
                                    print("🔵 Set focusedTodo to: \(focusedTodo?.title ?? "nil")")
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
            .fullScreenCover(item: $focusedTodo) { todo in
                let activeTodos = todosForSelectedDate.filter { !$0.completed }
                let _ = print("🔵 Presenting FocusView")
                let _ = print("🔵 focusedTodo: \(todo.title)")
                let _ = print("🔵 activeTodos count: \(activeTodos.count)")
                FocusView(
                    initialTodo: todo,
                    allTodosForDay: activeTodos
                ) {
                    print("🔵 FocusView dismissed")
                    focusedTodo = nil
                }
            }
            .navigationDestination(item: $selectedTodo) { todo in
                TodoDetailView(todo: todo, completionContextDate: selectedDate)
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
                    .onAppear {
                        // Set the date to the selected calendar date
                        newTodoDueDate = selectedDate
                    }
                }
                .presentationDetents([.medium, .large])
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
                .frame(width: 12)

            // White card with content
            Button {
                onTap()
            } label: {
                HStack(spacing: 0) {
                    // Time with margin
                    if let dueTime = todo.dueTime {
                        Text(timeString(from: dueTime))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(todo.completed ? .secondary : .primary)
                            .frame(width: 40, alignment: .leading)
                            .padding(.leading, 12)
                    } else {
                        Spacer()
                            .frame(width: 52)
                    }

                    // Title with margin
                    Text(todo.title)
                        .font(.subheadline)
                        .strikethrough(todo.completed)
                        .foregroundStyle(todo.completed ? .secondary : .primary)
                        .lineLimit(1)
                        .padding(.leading, 6)

                    Spacer()

                    // Circle checkbox with margin
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
                    .padding(.trailing, 12)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color(.systemGray4).opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
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

                    HStack(spacing: 8) {
                        if let subtype = todo.subtype {
                            HStack(spacing: 4) {
                                if !subtype.icon.isEmpty {
                                    Image(systemName: subtype.icon)
                                }
                                Text(subtype.name)
                            }
                            .font(.caption2)
                            .foregroundStyle(.blue)
                        }

                        if todo.recurringType != .none {
                            HStack(spacing: 4) {
                                Image(systemName: "repeat")
                                Text(todo.recurringType.displayName)
                            }
                            .font(.caption2)
                            .foregroundStyle(.purple)
                        }

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
