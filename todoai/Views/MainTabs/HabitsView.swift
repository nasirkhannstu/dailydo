//
//  HabitsView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subtype.sortOrder) private var allSubtypes: [Subtype]

    private var habits: [Subtype] {
        allSubtypes.filter { $0.type == .habit }
    }

    @State private var showingAddHabit = false
    @State private var newHabitName = ""
    @State private var newHabitDescription = ""
    @State private var newHabitShowInCalendar = false
    @State private var newHabitRemindersEnabled = false
    @State private var selectedHabit: Subtype?
    @State private var habitToDelete: Subtype?
    @State private var showingDeleteAlert = false
    @State private var showingTemplateGallery = false
    @FocusState private var isHabitNameFocused: Bool

    // Search states
    @State private var searchText = ""
    @State private var isSearching = false

    var filteredHabits: [Subtype] {
        guard !searchText.isEmpty else { return habits }
        return habits.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                        // Title and Search in one row
                        HStack {
                            Text("Habits")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Spacer()

                            Button {
                                showingTemplateGallery = true
                            } label: {
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundStyle(.orange)
                            }

                            Button {
                                withAnimation {
                                    isSearching.toggle()
                                    if !isSearching {
                                        searchText = ""
                                    }
                                }
                            } label: {
                                Image(systemName: isSearching ? "xmark.circle.fill" : "magnifyingglass")
                                    .font(.title2)
                                    .foregroundStyle(isSearching ? .red : .green)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        .background(Color(.systemGray6))

                        // Search Bar (when searching)
                        if isSearching {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                TextField("Search habits...", text: $searchText)
                                    .textFieldStyle(.plain)
                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .background(Color(.systemGray6))
                        }

                if habits.isEmpty {
                    EmptyStateView(
                        icon: "repeat.circle",
                        title: "No Habits Yet",
                        message: "Start building better habits today"
                    ) {
                        VStack(spacing: 12) {
                            Button {
                                showingTemplateGallery = true
                            } label: {
                                Label("Browse Templates", systemImage: "sparkles")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                showingAddHabit = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    isHabitNameFocused = true
                                }
                            } label: {
                                Label("Create Custom", systemImage: "plus")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else if filteredHabits.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView(
                                "No Results",
                                systemImage: "magnifyingglass",
                                description: Text("No habits match '\(searchText)'")
                            )
                        } else {
                            List {
                                ForEach(filteredHabits) { habit in
                            Button {
                                selectedHabit = habit
                            } label: {
                                HabitCardRow(habit: habit)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete(perform: deleteHabits)
                            }
                            .listStyle(.plain)
                            .background(Color(.systemGray6))
                            .scrollContentBackground(.hidden)
                        }
                }
            .navigationDestination(item: $selectedHabit) { habit in
                SubtypeDetailView(subtype: habit)
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddHabit = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isHabitNameFocused = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color.green.gradient)
                        )
                        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingAddHabit) {
                VStack(spacing: 16) {
                    // Name field
                    TextField("Habit Name", text: $newHabitName)
                        .font(.title3)
                        .focused($isHabitNameFocused)
                        .padding()
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Description field
                    TextField("Description (optional)", text: $newHabitDescription)
                        .font(.body)
                        .padding()
                        .padding(.horizontal)

                    // Toggle buttons and Add button
                    HStack(spacing: 12) {
                        // Calendar toggle button
                        Button {
                            newHabitShowInCalendar.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newHabitShowInCalendar ? "calendar.badge.checkmark" : "calendar")
                                    .font(.subheadline)
                                Text("Calendar")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newHabitShowInCalendar ? .white : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newHabitShowInCalendar ? Color.green : Color.green.opacity(0.1))
                            )
                        }

                        // Reminder toggle button
                        Button {
                            newHabitRemindersEnabled.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newHabitRemindersEnabled ? "bell.badge.fill" : "bell")
                                    .font(.subheadline)
                                Text("Reminder")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newHabitRemindersEnabled ? .white : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newHabitRemindersEnabled ? Color.green : Color.green.opacity(0.1))
                            )
                        }

                        Spacer()

                        // Add button
                        Button {
                            addHabit()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(newHabitName.isEmpty ? Color.gray : Color.green)
                                )
                        }
                        .disabled(newHabitName.isEmpty)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
            }
            .alert("Delete Habit?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    habitToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let habit = habitToDelete {
                        modelContext.delete(habit)
                        habitToDelete = nil
                    }
                }
            } message: {
                if let habit = habitToDelete {
                    Text("This will permanently delete this habit and all \(habit.todos.count) task\(habit.todos.count == 1 ? "" : "s"). This action cannot be undone.")
                }
            }
            .sheet(isPresented: $showingTemplateGallery) {
                TemplateGalleryView(type: .habit)
            }
        }
    }

    private func addHabit() {
        let newHabit = Subtype(
            name: newHabitName,
            itemDescription: newHabitDescription.isEmpty ? nil : newHabitDescription,
            type: .habit,
            showInCalendar: newHabitShowInCalendar,
            notificationEnabled: newHabitRemindersEnabled,
            sortOrder: habits.count
        )
        modelContext.insert(newHabit)
        resetAddHabitForm()
    }

    private func resetAddHabitForm() {
        showingAddHabit = false
        newHabitName = ""
        newHabitDescription = ""
        newHabitShowInCalendar = false
        newHabitRemindersEnabled = false
    }

    private func deleteHabits(at offsets: IndexSet) {
        if let index = offsets.first {
            habitToDelete = habits[index]
            showingDeleteAlert = true
        }
    }
}

// MARK: - Habit Card Row

struct HabitCardRow: View {
    let habit: Subtype

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: habit.icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.green.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                if let description = habit.itemDescription, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Text("\(habit.incompleteTodosCount) active")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if habit.completionPercentage > 0 {
                Text("\(Int(habit.completionPercentage))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.1))
                    )
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    // Create sample data for preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Subtype.self, TodoItem.self,
        configurations: config
    )

    // Add sample habits
    let habit1 = Subtype(name: "Morning Walk", type: .habit, icon: "figure.walk")
    let habit2 = Subtype(name: "Water Intake", type: .habit, icon: "drop.fill")
    let habit3 = Subtype(name: "Reading", type: .habit, icon: "book.fill")

    container.mainContext.insert(habit1)
    container.mainContext.insert(habit2)
    container.mainContext.insert(habit3)

    // Add sample todos to first habit
    let todo1 = TodoItem(title: "Walk 30 minutes", subtype: habit1)
    let todo2 = TodoItem(title: "Stretch after walk", completed: true, subtype: habit1)

    container.mainContext.insert(todo1)
    container.mainContext.insert(todo2)

    return HabitsView()
        .modelContainer(container)
}
