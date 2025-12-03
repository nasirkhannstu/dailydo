//
//  HabitsViewModel.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class HabitsViewModel {
    private var modelContext: ModelContext

    var subtypes: [Subtype] = []
    var isLoading = false
    var errorMessage: String?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Fetch all habit subtypes
    func fetchHabits() {
        isLoading = true
        errorMessage = nil

        do {
            let descriptor = FetchDescriptor<Subtype>(
                sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdDate)]
            )
            let allSubtypes = try modelContext.fetch(descriptor)
            subtypes = allSubtypes.filter { $0.type == .habit }
        } catch {
            errorMessage = "Failed to load habits: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Create a new habit subtype
    func createHabit(name: String, icon: String = "", showInCalendar: Bool = true) {
        let newHabit = Subtype(
            name: name,
            type: .habit,
            icon: icon,
            showInCalendar: showInCalendar,
            sortOrder: subtypes.count
        )

        modelContext.insert(newHabit)
        saveContext()
        fetchHabits()
    }

    // Delete a habit subtype
    func deleteHabit(_ subtype: Subtype) {
        modelContext.delete(subtype)
        saveContext()
        fetchHabits()
    }

    // Save context
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
