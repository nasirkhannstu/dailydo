//
//  SubtypeTemplate.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import Foundation

/// Template for creating pre-configured todos
struct TodoTemplate {
    let title: String
    let description: String
    let recurring: RecurringType
}

/// Template for creating pre-configured subtypes with todos
/// This is NOT a SwiftData model - it exists only in code
/// When user selects a template, it creates real Subtype and TodoItem objects
struct SubtypeTemplate: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: String
    let type: SubtypeType
    let shortDescription: String
    let todos: [TodoTemplate]
}
