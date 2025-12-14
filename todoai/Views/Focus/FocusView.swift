//
//  FocusView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI
import SwiftData

struct FocusView: View {
    @Environment(\.modelContext) private var modelContext
    let initialTodo: TodoItem
    let allTodosForDay: [TodoItem]
    let onDismiss: () -> Void

    @State private var currentTodoIndex: Int = 0
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isPulsing = false

    var currentTodo: TodoItem? {
        guard currentTodoIndex >= 0 && currentTodoIndex < allTodosForDay.count else {
            return nil
        }
        return allTodosForDay[currentTodoIndex]
    }

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.9),
                    Color(red: 0.4, green: 0.5, blue: 1.0),
                    Color(red: 0.5, green: 0.4, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if currentTodoIndex >= 0 && currentTodoIndex < allTodosForDay.count {
                focusContent(for: allTodosForDay[currentTodoIndex])
            }
        }
        .onAppear {
            print("🎯 FocusView appeared")
            print("🎯 allTodosForDay count: \(allTodosForDay.count)")
            print("🎯 initialTodo: \(initialTodo.title)")

            // Set initial index based on the initial todo
            if let index = allTodosForDay.firstIndex(where: { $0.id == initialTodo.id }) {
                currentTodoIndex = index
                print("🎯 Set currentTodoIndex to: \(index)")
            } else {
                print("🎯 ERROR: Could not find initialTodo in allTodosForDay")
                print("🎯 All todos in array:")
                for (idx, todo) in allTodosForDay.enumerated() {
                    print("🎯   [\(idx)] \(todo.title) - ID: \(todo.id)")
                }
                print("🎯 Looking for ID: \(initialTodo.id)")
            }

            startTimer()
            withAnimation {
                isPulsing = true
            }
        }
        .onDisappear {
            stopTimer()
        }
    }

    @ViewBuilder
    private func focusContent(for todo: TodoItem) -> some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.9),
                    Color(red: 0.4, green: 0.5, blue: 1.0),
                    Color(red: 0.5, green: 0.4, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button {
                        stopTimer()
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                            )
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()

                // Task Title
                VStack(spacing: 16) {
                    Text("FOCUS MODE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(2)

                    Text(todo.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    if let description = todo.itemDescription {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .lineLimit(3)
                    }
                }

                Spacer()

                // Timer Circle with Pulsing Animation
                ZStack {
                    // Outer pulsing circles
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 240, height: 240)
                            .scaleEffect(isPulsing ? 1.2 : 1.0)
                            .opacity(isPulsing ? 0 : 0.5)
                            .animation(
                                .easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.4),
                                value: isPulsing
                            )
                    }

                    // Main timer circle
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        .frame(width: 240, height: 240)

                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 240, height: 240)

                    // Timer Text
                    VStack(spacing: 8) {
                        Text(timeString)
                            .font(.system(size: 52, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()

                        Text("Keep Going!")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)

                Spacer()

                // Done Button
                Button {
                    completeTodo()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Complete Task")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green.gradient)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Timer Functions

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private var timeString: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    // MARK: - Task Completion

    private func completeTodo() {
        guard currentTodoIndex >= 0 && currentTodoIndex < allTodosForDay.count else {
            print("❌ completeTodo: invalid index!")
            return
        }

        // Get the todo directly from the array
        let todo = allTodosForDay[currentTodoIndex]

        print("✅ Completing todo: \(todo.title)")

        stopTimer()

        // Handle recurring todos
        if todo.recurringType != .dueDate && todo.recurringType != .oneTime {
            if let nextDate = todo.nextRecurringDate() {
                let nextTodoInstance = TodoItem(
                    title: todo.title,
                    itemDescription: todo.itemDescription,
                    dueDate: nextDate,
                    dueTime: todo.dueTime,
                    priority: todo.priority,
                    reminderEnabled: todo.reminderEnabled,
                    recurringType: todo.recurringType,
                    aiGenerated: todo.aiGenerated,
                    colorID: todo.colorID,
                    textureID: todo.textureID,
                    flagColor: todo.flagColor,
                    sortOrder: todo.sortOrder,
                    subtype: todo.subtype
                )
                modelContext.insert(nextTodoInstance)

                if todo.reminderEnabled {
                    Task {
                        await NotificationService.shared.scheduleNotification(for: nextTodoInstance)
                    }
                }
            }
        }

        // Mark current todo as complete
        todo.completed = true
        todo.completedDate = Date()
        print("✅ Marked as completed")

        // Save current context to persist the completion
        try? modelContext.save()

        // Dismiss immediately
        print("✅ Dismissing")
        onDismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodoItem.self, Subtype.self, configurations: config)

    let todo = TodoItem(
        title: "Complete Project Proposal",
        itemDescription: "Write and submit the Q4 project proposal to the team",
        dueDate: Date()
    )
    container.mainContext.insert(todo)

    return FocusView(
        initialTodo: todo,
        allTodosForDay: [todo]
    ) {
        print("Dismissed")
    }
    .modelContainer(container)
}
