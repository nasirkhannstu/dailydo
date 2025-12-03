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
        // Initialize model container
        do {
            modelContainer = try ModelContainer(
                for: User.self,
                Subtype.self,
                TodoItem.self,
                Subtask.self,
                PurchasedProduct.self
            )
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
