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

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "No Habits Yet",
                        systemImage: "repeat.circle",
                        description: Text("Create your first habit to get started")
                    )
                } else {
                    List {
                        ForEach(habits) { habit in
                            NavigationLink(destination: SubtypeDetailView(subtype: habit)) {
                                HStack {
                                    Image(systemName: habit.icon)
                                        .foregroundStyle(.blue)
                                    VStack(alignment: .leading) {
                                        Text(habit.name)
                                            .font(.headline)
                                        Text("\(habit.incompleteTodosCount) active")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if habit.completionPercentage > 0 {
                                        Text("\(Int(habit.completionPercentage))%")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteHabits)
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                NavigationStack {
                    Form {
                        TextField("Habit Name", text: $newHabitName)
                    }
                    .navigationTitle("New Habit")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddHabit = false
                                newHabitName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addHabit()
                            }
                            .disabled(newHabitName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }

    private func addHabit() {
        let newHabit = Subtype(
            name: newHabitName,
            type: .habit,
            sortOrder: habits.count
        )
        modelContext.insert(newHabit)
        showingAddHabit = false
        newHabitName = ""
    }

    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
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
