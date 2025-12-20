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
            return Color(red: 0.4, green: 0.8, blue: 0.4) // Vibrant green - joyful and energetic
        case .calm:
            return Color(red: 0.596, green: 0.875, blue: 0.596) // Soft pastel green - peaceful and gentle
        case .neutral:
            return Color(red: 0.506, green: 0.631, blue: 0.757) // Soft blue-gray - calm and balanced
        case .sad:
            return Color(red: 0.878, green: 0.478, blue: 0.373) // Soft coral - warmer, less harsh
        case .stressed:
            return Color(red: 1.0, green: 0.647, blue: 0.4) // Cute orange - warm and approachable
        case .angry:
            return Color(red: 1.0, green: 0.4, blue: 0.5) // Cute red - soft and less aggressive
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
