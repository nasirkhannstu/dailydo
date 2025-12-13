//
//  DailyDoApp.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/1/25.
//

import SwiftUI
import SwiftData

@main
struct DailyDoApp: App {
    let modelContainer: ModelContainer
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

    init() {
        // Initialize model container with migration configuration
        do {
            let schema = Schema([
                User.self,
                Subtype.self,
                TodoItem.self,
                Subtask.self,
                PurchasedProduct.self,
                DailyNote.self
            ])

            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
            }
        }
        .modelContainer(modelContainer)
    }
}
