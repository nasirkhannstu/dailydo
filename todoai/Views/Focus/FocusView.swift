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
    @State private var showingCompletion = false

    var currentTodo: TodoItem? {
        guard currentTodoIndex >= 0 && currentTodoIndex < allTodosForDay.count else {
            return nil
        }
        return allTodosForDay[currentTodoIndex]
    }

    var nextActiveTodoIndex: Int? {
        // Find the next active (non-completed) todo after the current index
        print("🔍 Finding next active todo from index \(currentTodoIndex)")
        print("🔍 Total todos in array: \(allTodosForDay.count)")

        for index in (currentTodoIndex + 1)..<allTodosForDay.count {
            let todo = allTodosForDay[index]
            print("🔍 Checking index \(index): \(todo.title) - completed: \(todo.completed)")
            if !todo.completed {
                print("🔍 Found next active todo at index \(index)")
                return index
            }
        }
        print("🔍 No more active todos found")
        return nil
    }

    var hasNextTodo: Bool {
        nextActiveTodoIndex != nil
    }

    var body: some View {
        ZStack {
            // Always show a background color first
            Color.purple
                .ignoresSafeArea()

            if currentTodoIndex >= 0 && currentTodoIndex < allTodosForDay.count {
                let todo = allTodosForDay[currentTodoIndex]
                if !todo.completed {
                    focusContent(for: todo)
                } else {
                    // Current todo is completed, show completion screen
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.green)
                        Text("Task Completed!")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .onAppear {
                        // Auto-dismiss after showing completion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onDismiss()
                        }
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Text("All tasks completed!")
                        .font(.title)
                        .foregroundStyle(.white)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    Button("Close") {
                        onDismiss()
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .onAppear {
                    print("⚠️ WARNING: Index \(currentTodoIndex) out of bounds (count: \(allTodosForDay.count))")
                }
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
                        Text("Done")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Image(systemName: hasNextTodo ? "arrow.right" : "checkmark")
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
        print("✅ Current index: \(currentTodoIndex)")
        print("✅ Array count: \(allTodosForDay.count)")

        stopTimer()

        // Handle recurring todos
        if todo.recurringType != .none {
            if let nextDate = todo.nextRecurringDate() {
                let nextTodoInstance = TodoItem(
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
                modelContext.insert(nextTodoInstance)

                if todo.reminderEnabled {
                    Task {
                        await NotificationService.shared.scheduleNotification(for: nextTodoInstance)
                    }
                }
            }
        }

        // Mark current todo as complete using modelContext
        todo.completed = true
        todo.completedDate = Date()
        print("✅ Marked as completed: \(todo.completed)")

        // Save current context to persist the completion
        try? modelContext.save()

        // Move to next active task or dismiss
        if let nextIndex = nextActiveTodoIndex {
            print("✅ Next index calculated: \(nextIndex)")
            print("✅ Array count: \(allTodosForDay.count)")

            // Validate the next index before using it
            guard nextIndex >= 0 && nextIndex < allTodosForDay.count else {
                print("❌ ERROR: nextIndex \(nextIndex) is out of bounds (count: \(allTodosForDay.count))")
                print("❌ Dismissing instead of crashing")
                onDismiss()
                return
            }

            // Double-check the todo at that index isn't completed
            let nextTodo = allTodosForDay[nextIndex]
            guard !nextTodo.completed else {
                print("❌ ERROR: Next todo at index \(nextIndex) is already completed!")
                print("❌ Dismissing instead")
                onDismiss()
                return
            }

            // Update to next active todo
            withAnimation {
                currentTodoIndex = nextIndex
                print("✅ Set currentTodoIndex to: \(currentTodoIndex)")
                elapsedTime = 0
                isPulsing = false
                startTimer()
                // Re-trigger pulsing animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isPulsing = true
                    }
                }
            }
        } else {
            // No more active tasks, show completion and dismiss
            print("✅ No more tasks, dismissing")
            showingCompletion = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onDismiss()
            }
        }
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
