//
//  PlansViewModel.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class PlansViewModel {
    private var modelContext: ModelContext

    var subtypes: [Subtype] = []
    var isLoading = false
    var errorMessage: String?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Fetch all plan subtypes
    func fetchPlans() {
        isLoading = true
        errorMessage = nil

        do {
            let descriptor = FetchDescriptor<Subtype>(
                sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdDate)]
            )
            let allSubtypes = try modelContext.fetch(descriptor)
            subtypes = allSubtypes.filter { $0.type == .plan }
        } catch {
            errorMessage = "Failed to load plans: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Create a new plan subtype
    func createPlan(name: String, icon: String = "", showInCalendar: Bool = true) {
        let newPlan = Subtype(
            name: name,
            type: .plan,
            icon: icon,
            showInCalendar: showInCalendar,
            sortOrder: subtypes.count
        )

        modelContext.insert(newPlan)
        saveContext()
        fetchPlans()
    }

    // Delete a plan subtype
    func deletePlan(_ subtype: Subtype) {
        modelContext.delete(subtype)
        saveContext()
        fetchPlans()
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
