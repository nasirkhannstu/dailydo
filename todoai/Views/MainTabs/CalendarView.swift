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

    @State private var selectedDate = Date()
    @State private var currentWeekOffset = 0
    @State private var selectedStatusFilter: StatusFilter = .all
    @State private var selectedTypeFilter: TypeFilter = .all
    @State private var showingMonthYearPicker = false
    @State private var pickerDate = Date()
    @State private var showingFilterSheet = false
    @State private var focusedTodo: TodoItem? = nil
    @State private var selectedTodo: TodoItem? = nil

    private let calendar = Calendar.current

    var currentWeekDates: [Date] {
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: Date())!))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var todosForSelectedDate: [TodoItem] {
        var filtered = allTodos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: selectedDate)
        }

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

        return filtered.sorted { !$0.completed && $1.completed }
    }

    func taskCount(for date: Date) -> Int {
        allTodos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }.count
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
                            TodoCalendarRow(todo: todo, onFocus: {
                                print("🔵 Focus button tapped for: \(todo.title)")
                                focusedTodo = todo
                                print("🔵 Set focusedTodo to: \(focusedTodo?.title ?? "nil")")
                            }, onTap: {
                                selectedTodo = todo
                            })
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemGray6))
                .scrollContentBackground(.hidden)
            }
            .navigationBarHidden(true)
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
                TodoDetailView(todo: todo)
            }
        }
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
    @Bindable var todo: TodoItem
    let onFocus: () -> Void
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .center, spacing: 12) {
                Button {
                    todo.toggleCompletion()
                } label: {
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(todo.completed ? .green : .gray)
                }
                .buttonStyle(.plain)

                HStack(spacing: 12) {
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

                            if let dueTime = todo.dueTime {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                    Text(dueTime, style: .time)
                                }
                                .font(.caption2)
                                .foregroundStyle(.orange)
                            }

                            if todo.recurringType != .none {
                                HStack(spacing: 4) {
                                    Image(systemName: "repeat")
                                    Text(todo.recurringType.displayName)
                                }
                                .font(.caption2)
                                .foregroundStyle(.purple)
                            }

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

                    Spacer()

                    if todo.starred {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                    }

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
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
