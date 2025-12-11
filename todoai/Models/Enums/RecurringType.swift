//
//  RecurringType.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation

enum RecurringType: String, Codable, CaseIterable {
    case dueDate
    case oneTime
    case daily
    case weekly
    case monthly
    case yearly

    var displayName: String {
        switch self {
        case .dueDate:
            return "Due Date"
        case .oneTime:
            return "One Time"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }

    var icon: String {
        switch self {
        case .dueDate:
            return "calendar.badge.clock"
        case .oneTime:
            return "clock.badge.checkmark"
        case .daily:
            return "sun.max.fill"
        case .weekly:
            return "calendar"
        case .monthly:
            return "calendar.badge.clock"
        case .yearly:
            return "calendar.circle.fill"
        }
    }
}
