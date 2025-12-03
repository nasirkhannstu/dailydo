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

    init() {
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Set a beautiful purple-blue gradient background color
        appearance.backgroundColor = UIColor(red: 0.93, green: 0.91, blue: 0.98, alpha: 1.0)  // Soft lavender

        // Selected item color - Deep purple for contrast
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.4, green: 0.3, blue: 0.8, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.4, green: 0.3, blue: 0.8, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]

        // Unselected item color - Medium purple
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.55, green: 0.45, blue: 0.7, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.55, green: 0.45, blue: 0.7, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]

        // Add subtle shadow at top
        appearance.shadowColor = UIColor(red: 0.4, green: 0.3, blue: 0.8, alpha: 0.2)
        appearance.shadowImage = UIImage()

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Habits
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: selectedTab == 0 ? "repeat.circle.fill" : "repeat.circle")
                }
                .tag(0)

            // Tab 2: Plans
            PlansView()
                .tabItem {
                    Label("Plans", systemImage: selectedTab == 1 ? "calendar.badge.checkmark" : "calendar.badge.clock")
                }
                .tag(1)

            // Tab 3: Calendar
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: selectedTab == 2 ? "calendar.circle.fill" : "calendar")
                }
                .tag(2)

            // Tab 4: Lists
            ListsView()
                .tabItem {
                    Label("Lists", systemImage: selectedTab == 3 ? "list.bullet.circle.fill" : "list.bullet.circle")
                }
                .tag(3)

            // Tab 5: Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                }
                .tag(4)
        }
        .tint(Color(red: 0.4, green: 0.3, blue: 0.8))
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
