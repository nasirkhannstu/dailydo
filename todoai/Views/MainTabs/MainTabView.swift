//
//  MainTabView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 2  // Default to Calendar tab
    @State private var hasSeededData = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Habits
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "repeat.circle.fill")
                }
                .tag(0)

            // Tab 2: Plans
            PlansView()
                .tabItem {
                    Label("Plans", systemImage: "calendar.badge.checkmark")
                }
                .tag(1)

            // Tab 3: Calendar
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)

            // Tab 4: Lists
            ListsView()
                .tabItem {
                    Label("Lists", systemImage: "list.bullet.circle.fill")
                }
                .tag(3)

            // Tab 5: Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .onAppear {
            if !hasSeededData {
                seedDataIfNeeded()
                hasSeededData = true
            }
        }
    }

    private func seedDataIfNeeded() {
        print("🌱 MainTabView: Attempting to seed data...")
        let seeder = DataSeederService(modelContext: modelContext)
        seeder.seedSampleData()
        print("🌱 MainTabView: Seeding completed")
    }
}

#Preview("Main App with Tabs") {
    // Create sample data for preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Subtype.self, TodoItem.self,
        configurations: config
    )

    // Add sample data
    let habit = Subtype(name: "Morning Walk", type: .habit, icon: "figure.walk")
    let plan = Subtype(name: "Study Plan", type: .plan, icon: "book.fill")
    let list = Subtype(name: "Shopping List", type: .list, icon: "cart.fill")

    container.mainContext.insert(habit)
    container.mainContext.insert(plan)
    container.mainContext.insert(list)

    let todo1 = TodoItem(title: "Walk 30 minutes", dueDate: Date(), subtype: habit)
    let todo2 = TodoItem(title: "Read Chapter 5", subtype: plan)
    let todo3 = TodoItem(title: "Buy milk", completed: true, subtype: list)

    container.mainContext.insert(todo1)
    container.mainContext.insert(todo2)
    container.mainContext.insert(todo3)

    return MainTabView()
        .modelContainer(container)
}
