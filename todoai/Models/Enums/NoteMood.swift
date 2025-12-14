//
//  NoteMood.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/11/25.
//

import Foundation
import SwiftUI

enum NoteMood: String, Codable, CaseIterable {
    case happy = "Happy"
    case calm = "Calm"
    case neutral = "Neutral"
    case sad = "Sad"
    case stressed = "Stressed"
    case angry = "Angry"

    var color: Color {
        switch self {
        case .happy:
            return Color(red: 0.2, green: 0.8, blue: 0.4) // Green
        case .calm:
            return Color(red: 0.4, green: 0.7, blue: 0.9) // Light blue
        case .neutral:
            return Color(red: 0.6, green: 0.6, blue: 0.6) // Gray
        case .sad:
            return Color(red: 0.4, green: 0.5, blue: 0.8) // Soft blue
        case .stressed:
            return Color(red: 0.9, green: 0.6, blue: 0.3) // Orange
        case .angry:
            return Color(red: 0.9, green: 0.3, blue: 0.3) // Red
        }
    }

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .neutral: return "😐"
        case .sad: return "😔"
        case .stressed: return "😫"
        case .angry: return "😤"
        }
    }

    var description: String {
        switch self {
        case .happy: return "Feeling good and positive"
        case .calm: return "Peaceful and relaxed"
        case .neutral: return "Just an ordinary day"
        case .sad: return "Feeling down or blue"
        case .stressed: return "Overwhelmed and tired"
        case .angry: return "Frustrated or upset"
        }
    }
}
