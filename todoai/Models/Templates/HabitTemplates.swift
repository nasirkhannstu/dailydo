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
                TodoTemplate(title: "Morning water (7 AM)", description: "First glass when you wake up", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Mid-morning (10 AM)", description: "Second glass", recurring: .daily, hour: 10, minute: 0),
                TodoTemplate(title: "Before lunch (12 PM)", description: "Third glass", recurring: .daily, hour: 12, minute: 0),
                TodoTemplate(title: "Afternoon (3 PM)", description: "Fourth glass", recurring: .daily, hour: 15, minute: 0),
                TodoTemplate(title: "Before dinner (6 PM)", description: "Fifth glass", recurring: .daily, hour: 18, minute: 0),
                TodoTemplate(title: "Evening (8 PM)", description: "Sixth glass", recurring: .daily, hour: 20, minute: 0),
                TodoTemplate(title: "Track total intake", description: "Aim for 8 glasses", recurring: .daily, hour: 21, minute: 0)
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
                TodoTemplate(title: "Warm up", description: "5 minutes stretching", recurring: .daily, hour: 6, minute: 0),
                TodoTemplate(title: "Cardio workout", description: "20 minutes running/cycling", recurring: .daily, hour: 6, minute: 10),
                TodoTemplate(title: "Strength training", description: "15 minutes weights", recurring: .daily, hour: 6, minute: 35),
                TodoTemplate(title: "Core exercises", description: "10 minutes abs", recurring: .daily, hour: 6, minute: 50),
                TodoTemplate(title: "Cool down", description: "5 minutes stretching", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Track workout", description: "Log in fitness app", recurring: .daily, hour: 7, minute: 10)
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
                TodoTemplate(title: "Morning medication", description: "Take with breakfast", recurring: .daily, hour: 8, minute: 0),
                TodoTemplate(title: "Afternoon medication", description: "Take with lunch", recurring: .daily, hour: 13, minute: 0),
                TodoTemplate(title: "Evening medication", description: "Take with dinner", recurring: .daily, hour: 19, minute: 0),
                TodoTemplate(title: "Check medication stock", description: "Refill if needed", recurring: .weekly, hour: 10, minute: 0),
                TodoTemplate(title: "Track symptoms", description: "Note any changes", recurring: .daily, hour: 21, minute: 0)
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
                TodoTemplate(title: "Monday: Oatmeal & berries", description: "Fiber-rich breakfast", recurring: .weekly, hour: 8, minute: 0),
                TodoTemplate(title: "Tuesday: Eggs & toast", description: "Protein-packed", recurring: .weekly, hour: 8, minute: 0),
                TodoTemplate(title: "Wednesday: Smoothie bowl", description: "Fruits & greens", recurring: .weekly, hour: 8, minute: 0),
                TodoTemplate(title: "Thursday: Greek yogurt", description: "With granola & honey", recurring: .weekly, hour: 8, minute: 0),
                TodoTemplate(title: "Friday: Avocado toast", description: "Healthy fats", recurring: .weekly, hour: 8, minute: 0),
                TodoTemplate(title: "Weekend: Special breakfast", description: "Try new recipes", recurring: .weekly, hour: 9, minute: 0)
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
                TodoTemplate(title: "Morning: Cleanser", description: "Gentle face wash", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Morning: Toner", description: "Balance pH", recurring: .daily, hour: 7, minute: 5),
                TodoTemplate(title: "Morning: Moisturizer", description: "Hydrate skin", recurring: .daily, hour: 7, minute: 10),
                TodoTemplate(title: "Morning: Sunscreen", description: "SPF 30+", recurring: .daily, hour: 7, minute: 15),
                TodoTemplate(title: "Evening: Remove makeup", description: "Cleanse thoroughly", recurring: .daily, hour: 21, minute: 0),
                TodoTemplate(title: "Evening: Night cream", description: "Repair overnight", recurring: .daily, hour: 21, minute: 10),
                TodoTemplate(title: "Weekly: Face mask", description: "Deep treatment", recurring: .weekly, hour: 20, minute: 0)
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
                TodoTemplate(title: "Brush teeth (morning)", description: "2 minutes", recurring: .daily, hour: 7, minute: 30),
                TodoTemplate(title: "Floss (morning)", description: "Between all teeth", recurring: .daily, hour: 7, minute: 35),
                TodoTemplate(title: "Mouthwash (morning)", description: "30 seconds", recurring: .daily, hour: 7, minute: 40),
                TodoTemplate(title: "Brush teeth (evening)", description: "2 minutes", recurring: .daily, hour: 22, minute: 0),
                TodoTemplate(title: "Floss (evening)", description: "Before bed", recurring: .daily, hour: 22, minute: 5),
                TodoTemplate(title: "Replace toothbrush", description: "Every 3 months", recurring: .monthly, hour: 10, minute: 0)
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
                TodoTemplate(title: "Morning feeding", description: "Measured portion", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Fresh water (AM)", description: "Clean bowl", recurring: .daily, hour: 7, minute: 10),
                TodoTemplate(title: "Evening feeding", description: "Measured portion", recurring: .daily, hour: 18, minute: 0),
                TodoTemplate(title: "Fresh water (PM)", description: "Refill bowl", recurring: .daily, hour: 18, minute: 10),
                TodoTemplate(title: "Clean food bowls", description: "Wash daily", recurring: .daily, hour: 20, minute: 0),
                TodoTemplate(title: "Vet checkup reminder", description: "Schedule appointment", recurring: .monthly, hour: 10, minute: 0)
            ]
        ),

        // 8. Daily Reading
        SubtypeTemplate(
            name: "Daily Reading",
            icon: "book.fill",
            color: "indigo",
            type: .habit,
            shortDescription: "Build a reading habit",
            todos: [
                TodoTemplate(title: "Morning reading", description: "15 minutes", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Evening reading", description: "30 minutes before bed", recurring: .daily, hour: 21, minute: 30),
                TodoTemplate(title: "Track pages read", description: "Log progress", recurring: .daily, hour: 22, minute: 0),
                TodoTemplate(title: "Choose next book", description: "Plan ahead", recurring: .weekly, hour: 11, minute: 0),
                TodoTemplate(title: "Reading goal review", description: "Weekly progress check", recurring: .weekly, hour: 11, minute: 30)
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
                TodoTemplate(title: "Morning walk", description: "15 minutes", recurring: .daily, hour: 7, minute: 0),
                TodoTemplate(title: "Lunch break walk", description: "10 minutes", recurring: .daily, hour: 12, minute: 30),
                TodoTemplate(title: "Evening walk", description: "20 minutes", recurring: .daily, hour: 18, minute: 30),
                TodoTemplate(title: "Check step count", description: "Monitor progress", recurring: .daily, hour: 20, minute: 0),
                TodoTemplate(title: "Reach 10,000 steps", description: "Daily goal", recurring: .daily, hour: 21, minute: 0)
            ]
        )
    ]
}
