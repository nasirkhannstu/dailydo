//
//  ListsViewModel.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class ListsViewModel {
    private var modelContext: ModelContext

    var subtypes: [Subtype] = []
    var isLoading = false
    var errorMessage: String?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Fetch all list subtypes
    func fetchLists() {
        isLoading = true
        errorMessage = nil

        do {
            let descriptor = FetchDescriptor<Subtype>(
                sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdDate)]
            )
            let allSubtypes = try modelContext.fetch(descriptor)
            subtypes = allSubtypes.filter { $0.type == .list }
        } catch {
            errorMessage = "Failed to load lists: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Create a new list subtype
    func createList(name: String, icon: String = "", showInCalendar: Bool = true) {
        let newList = Subtype(
            name: name,
            type: .list,
            icon: icon,
            showInCalendar: showInCalendar,
            sortOrder: subtypes.count
        )

        modelContext.insert(newList)
        saveContext()
        fetchLists()
    }

    // Delete a list subtype
    func deleteList(_ subtype: Subtype) {
        modelContext.delete(subtype)
        saveContext()
        fetchLists()
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
