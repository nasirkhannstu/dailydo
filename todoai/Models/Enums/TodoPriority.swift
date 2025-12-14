//
//  TodoPriority.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/14/25.
//

import Foundation
import SwiftUI

enum TodoPriority: String, Codable, CaseIterable {
    case none = "None"
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        case .none:
            return .gray
        }
    }

    var dotColor: Color? {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        case .none:
            return nil // No dot for none
        }
    }

    var icon: String {
        switch self {
        case .high:
            return "exclamationmark.3"
        case .medium:
            return "exclamationmark.2"
        case .low:
            return "exclamationmark"
        case .none:
            return ""
        }
    }

    var sortOrder: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        case .none: return 3
        }
    }

    var displayName: String {
        return self.rawValue
    }

    // Color to use when task is completed
    var completionColor: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        case .none:
            return Color(.systemGray) // Dark-ish gray for no priority completed tasks
        }
    }
}
