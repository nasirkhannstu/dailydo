//
//  DailyNote.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/11/25.
//

import Foundation
import SwiftData

@Model
class DailyNote {
    @Attribute(.unique) var id: UUID
    var date: Date
    var content: String
    var createdDate: Date
    var lastModifiedDate: Date
    var mood: String // Store NoteMood enum rawValue

    init(
        id: UUID = UUID(),
        date: Date,
        content: String = "",
        createdDate: Date = Date(),
        lastModifiedDate: Date = Date(),
        mood: String = NoteMood.neutral.rawValue
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.content = content
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.mood = mood
    }

    // Computed property for easy mood access
    var noteMood: NoteMood {
        get {
            NoteMood(rawValue: mood) ?? .neutral
        }
        set {
            mood = newValue.rawValue
        }
    }
}
