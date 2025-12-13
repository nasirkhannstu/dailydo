//
//  NoteMood.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/11/25.
//

import Foundation
import SwiftUI

enum NoteMood: String, Codable, CaseIterable {
    case amazing = "Amazing"
    case great = "Great"
    case good = "Good"
    case okay = "Okay"
    case meh = "Meh"
    case challenging = "Tough"
    case difficult = "Hard"
    case mixed = "Mixed"

    var color: Color {
        switch self {
        case .amazing:
            return Color(red: 0.13, green: 0.59, blue: 0.36) // Darker Green
        case .great:
            return Color(red: 0.15, green: 0.38, blue: 0.75) // Darker Blue
        case .good:
            return Color(red: 0.42, green: 0.26, blue: 0.75) // Darker Purple
        case .okay:
            return Color(red: 0.13, green: 0.56, blue: 0.67) // Darker Teal
        case .meh:
            return Color(red: 0.45, green: 0.48, blue: 0.52) // Darker Gray
        case .challenging:
            return Color(red: 0.85, green: 0.35, blue: 0.07) // Darker Orange
        case .difficult:
            return Color(red: 0.78, green: 0.18, blue: 0.18) // Darker Red
        case .mixed:
            return Color(red: 0.85, green: 0.50, blue: 0.07) // Darker Yellow
        }
    }

    var icon: String {
        switch self {
        case .amazing: return "star.fill"
        case .great: return "sun.max.fill"
        case .good: return "heart.fill"
        case .okay: return "hand.thumbsup.fill"
        case .meh: return "minus.circle.fill"
        case .challenging: return "exclamationmark.triangle.fill"
        case .difficult: return "cloud.rain.fill"
        case .mixed: return "arrow.up.arrow.down"
        }
    }

    var description: String {
        switch self {
        case .amazing: return "Best day ever!"
        case .great: return "Really good day"
        case .good: return "Nice and positive"
        case .okay: return "Average day"
        case .meh: return "Nothing special"
        case .challenging: return "Tough but managed"
        case .difficult: return "Really hard day"
        case .mixed: return "Ups and downs"
        }
    }
}
