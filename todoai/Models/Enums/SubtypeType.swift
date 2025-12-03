//
//  SubtypeType.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import Foundation

enum SubtypeType: String, Codable, CaseIterable {
    case habit
    case plan
    case list

    var displayName: String {
        switch self {
        case .habit:
            return "Habit"
        case .plan:
            return "Plan"
        case .list:
            return "List"
        }
    }

    var icon: String {
        switch self {
        case .habit:
            return "repeat.circle.fill"
        case .plan:
            return "calendar.badge.checkmark"
        case .list:
            return "list.bullet.circle.fill"
        }
    }
}
