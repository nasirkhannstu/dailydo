//
//  HabitTemplates.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import Foundation

extension SubtypeTemplate {
    /// Pre-configured habit templates - Each template is specific and focused
    static let habitTemplates: [SubtypeTemplate] = [
        // 1. Water Intake Tracker
        SubtypeTemplate(
            name: "Water Intake",
            icon: "drop.fill",
            color: "blue",
            type: .habit,
            shortDescription: "Stay hydrated with 8 glasses daily",
            todos: [
                TodoTemplate(title: "Morning water (7 AM)", description: "First glass when you wake up", recurring: .daily),
                TodoTemplate(title: "Mid-morning (10 AM)", description: "Second glass", recurring: .daily),
                TodoTemplate(title: "Before lunch (12 PM)", description: "Third glass", recurring: .daily),
                TodoTemplate(title: "Afternoon (3 PM)", description: "Fourth glass", recurring: .daily),
                TodoTemplate(title: "Before dinner (6 PM)", description: "Fifth glass", recurring: .daily),
                TodoTemplate(title: "Evening (8 PM)", description: "Sixth glass", recurring: .daily),
                TodoTemplate(title: "Track total intake", description: "Aim for 8 glasses", recurring: .daily)
            ]
        ),

        // 2. Exercise Routine
        SubtypeTemplate(
            name: "Exercise",
            icon: "figure.run",
            color: "red",
            type: .habit,
            shortDescription: "Daily workout routine",
            todos: [
                TodoTemplate(title: "Warm up", description: "5 minutes stretching", recurring: .daily),
                TodoTemplate(title: "Cardio workout", description: "20 minutes running/cycling", recurring: .daily),
                TodoTemplate(title: "Strength training", description: "15 minutes weights", recurring: .daily),
                TodoTemplate(title: "Core exercises", description: "10 minutes abs", recurring: .daily),
                TodoTemplate(title: "Cool down", description: "5 minutes stretching", recurring: .daily),
                TodoTemplate(title: "Track workout", description: "Log in fitness app", recurring: .daily)
            ]
        ),

        // 3. Medication Reminder
        SubtypeTemplate(
            name: "Medication",
            icon: "pills.fill",
            color: "pink",
            type: .habit,
            shortDescription: "Never miss your medication",
            todos: [
                TodoTemplate(title: "Morning medication", description: "Take with breakfast", recurring: .daily),
                TodoTemplate(title: "Afternoon medication", description: "Take with lunch", recurring: .daily),
                TodoTemplate(title: "Evening medication", description: "Take with dinner", recurring: .daily),
                TodoTemplate(title: "Check medication stock", description: "Refill if needed", recurring: .weekly),
                TodoTemplate(title: "Track symptoms", description: "Note any changes", recurring: .daily)
            ]
        ),

        // 4. Healthy Breakfast
        SubtypeTemplate(
            name: "Healthy Breakfast",
            icon: "fork.knife",
            color: "orange",
            type: .habit,
            shortDescription: "Start your day with nutrition",
            todos: [
                TodoTemplate(title: "Monday: Oatmeal & berries", description: "Fiber-rich breakfast", recurring: .weekly),
                TodoTemplate(title: "Tuesday: Eggs & toast", description: "Protein-packed", recurring: .weekly),
                TodoTemplate(title: "Wednesday: Smoothie bowl", description: "Fruits & greens", recurring: .weekly),
                TodoTemplate(title: "Thursday: Greek yogurt", description: "With granola & honey", recurring: .weekly),
                TodoTemplate(title: "Friday: Avocado toast", description: "Healthy fats", recurring: .weekly),
                TodoTemplate(title: "Weekend: Special breakfast", description: "Try new recipes", recurring: .weekly)
            ]
        ),

        // 5. Skin Care Routine
        SubtypeTemplate(
            name: "Skin Care",
            icon: "sparkles",
            color: "purple",
            type: .habit,
            shortDescription: "Morning & evening skin care",
            todos: [
                TodoTemplate(title: "Morning: Cleanser", description: "Gentle face wash", recurring: .daily),
                TodoTemplate(title: "Morning: Toner", description: "Balance pH", recurring: .daily),
                TodoTemplate(title: "Morning: Moisturizer", description: "Hydrate skin", recurring: .daily),
                TodoTemplate(title: "Morning: Sunscreen", description: "SPF 30+", recurring: .daily),
                TodoTemplate(title: "Evening: Remove makeup", description: "Cleanse thoroughly", recurring: .daily),
                TodoTemplate(title: "Evening: Night cream", description: "Repair overnight", recurring: .daily),
                TodoTemplate(title: "Weekly: Face mask", description: "Deep treatment", recurring: .weekly)
            ]
        ),

        // 6. Dental Care
        SubtypeTemplate(
            name: "Dental Care",
            icon: "mouth.fill",
            color: "cyan",
            type: .habit,
            shortDescription: "Complete oral hygiene routine",
            todos: [
                TodoTemplate(title: "Brush teeth (morning)", description: "2 minutes", recurring: .daily),
                TodoTemplate(title: "Floss (morning)", description: "Between all teeth", recurring: .daily),
                TodoTemplate(title: "Mouthwash (morning)", description: "30 seconds", recurring: .daily),
                TodoTemplate(title: "Brush teeth (evening)", description: "2 minutes", recurring: .daily),
                TodoTemplate(title: "Floss (evening)", description: "Before bed", recurring: .daily),
                TodoTemplate(title: "Replace toothbrush", description: "Every 3 months", recurring: .monthly)
            ]
        ),

        // 7. Feed Pets
        SubtypeTemplate(
            name: "Feed Pets",
            icon: "pawprint.fill",
            color: "brown",
            type: .habit,
            shortDescription: "Daily pet care routine",
            todos: [
                TodoTemplate(title: "Morning feeding", description: "Measured portion", recurring: .daily),
                TodoTemplate(title: "Fresh water (AM)", description: "Clean bowl", recurring: .daily),
                TodoTemplate(title: "Evening feeding", description: "Measured portion", recurring: .daily),
                TodoTemplate(title: "Fresh water (PM)", description: "Refill bowl", recurring: .daily),
                TodoTemplate(title: "Clean food bowls", description: "Wash daily", recurring: .daily),
                TodoTemplate(title: "Vet checkup reminder", description: "Schedule appointment", recurring: .monthly)
            ]
        ),

        // 8. Prayer Time
        SubtypeTemplate(
            name: "Prayer Time",
            icon: "hands.sparkles.fill",
            color: "teal",
            type: .habit,
            shortDescription: "Daily spiritual practice",
            todos: [
                TodoTemplate(title: "Fajr (Dawn prayer)", description: "Before sunrise", recurring: .daily),
                TodoTemplate(title: "Dhuhr (Noon prayer)", description: "Afternoon", recurring: .daily),
                TodoTemplate(title: "Asr (Afternoon prayer)", description: "Late afternoon", recurring: .daily),
                TodoTemplate(title: "Maghrib (Sunset prayer)", description: "After sunset", recurring: .daily),
                TodoTemplate(title: "Isha (Night prayer)", description: "Evening", recurring: .daily),
                TodoTemplate(title: "Quran reading", description: "Daily recitation", recurring: .daily)
            ]
        ),

        // 9. Daily Reading
        SubtypeTemplate(
            name: "Daily Reading",
            icon: "book.fill",
            color: "indigo",
            type: .habit,
            shortDescription: "Build a reading habit",
            todos: [
                TodoTemplate(title: "Morning reading", description: "15 minutes", recurring: .daily),
                TodoTemplate(title: "Evening reading", description: "30 minutes before bed", recurring: .daily),
                TodoTemplate(title: "Track pages read", description: "Log progress", recurring: .daily),
                TodoTemplate(title: "Choose next book", description: "Plan ahead", recurring: .weekly),
                TodoTemplate(title: "Reading goal review", description: "Weekly progress check", recurring: .weekly)
            ]
        ),

        // 10. Steps Goal
        SubtypeTemplate(
            name: "Steps Goal",
            icon: "figure.walk",
            color: "green",
            type: .habit,
            shortDescription: "Track 10,000 steps daily",
            todos: [
                TodoTemplate(title: "Morning walk", description: "15 minutes", recurring: .daily),
                TodoTemplate(title: "Lunch break walk", description: "10 minutes", recurring: .daily),
                TodoTemplate(title: "Evening walk", description: "20 minutes", recurring: .daily),
                TodoTemplate(title: "Check step count", description: "Monitor progress", recurring: .daily),
                TodoTemplate(title: "Reach 10,000 steps", description: "Daily goal", recurring: .daily)
            ]
        )
    ]
}
