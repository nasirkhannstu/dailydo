//
//  PlanTemplates.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import Foundation

extension SubtypeTemplate {
    /// Pre-configured plan templates
    static let planTemplates: [SubtypeTemplate] = [
        // 1. Work Project
        SubtypeTemplate(
            name: "Work Project",
            icon: "briefcase.fill",
            color: "blue",
            type: .plan,
            shortDescription: "Manage work tasks efficiently",
            todos: [
                TodoTemplate(title: "Project kickoff meeting", description: "Align team on goals", recurring: .oneTime),
                TodoTemplate(title: "Define requirements", description: "Document scope and specs", recurring: .oneTime),
                TodoTemplate(title: "Create timeline", description: "Set milestones and deadlines", recurring: .oneTime),
                TodoTemplate(title: "Assign responsibilities", description: "Delegate tasks to team", recurring: .oneTime),
                TodoTemplate(title: "Weekly check-ins", description: "Review progress", recurring: .weekly),
                TodoTemplate(title: "Review & iterate", description: "Gather feedback", recurring: .oneTime),
                TodoTemplate(title: "Final delivery", description: "Ship the project", recurring: .oneTime)
            ]
        ),

        // 2. Study & Learning
        SubtypeTemplate(
            name: "Study & Learning",
            icon: "book.fill",
            color: "purple",
            type: .plan,
            shortDescription: "Ace your exams & courses",
            todos: [
                TodoTemplate(title: "Review syllabus", description: "Understand course requirements", recurring: .oneTime),
                TodoTemplate(title: "Create study schedule", description: "Plan study sessions", recurring: .oneTime),
                TodoTemplate(title: "Daily practice problems", description: "Reinforce learning", recurring: .daily),
                TodoTemplate(title: "Weekly quiz review", description: "Test understanding", recurring: .weekly),
                TodoTemplate(title: "Office hours/tutoring", description: "Get help when needed", recurring: .weekly),
                TodoTemplate(title: "Group study session", description: "Learn with peers", recurring: .weekly),
                TodoTemplate(title: "Practice exam", description: "Simulate test conditions", recurring: .oneTime),
                TodoTemplate(title: "Final exam prep", description: "Last minute review", recurring: .oneTime)
            ]
        ),

        // 3. Home Improvement
        SubtypeTemplate(
            name: "Home Improvement",
            icon: "house.fill",
            color: "brown",
            type: .plan,
            shortDescription: "DIY projects made simple",
            todos: [
                TodoTemplate(title: "Measure space", description: "Get accurate dimensions", recurring: .oneTime),
                TodoTemplate(title: "Research options", description: "Find inspiration and ideas", recurring: .oneTime),
                TodoTemplate(title: "Budget planning", description: "Calculate costs", recurring: .oneTime),
                TodoTemplate(title: "Purchase materials", description: "Shopping list ready", recurring: .oneTime),
                TodoTemplate(title: "Prep work area", description: "Clear and protect space", recurring: .oneTime),
                TodoTemplate(title: "Execute project", description: "Get it done!", recurring: .oneTime),
                TodoTemplate(title: "Clean up", description: "Restore area", recurring: .oneTime),
                TodoTemplate(title: "Enjoy results!", description: "Admire your work", recurring: .oneTime)
            ]
        ),

        // 4. Event Planning
        SubtypeTemplate(
            name: "Event Planning",
            icon: "calendar.badge.plus",
            color: "pink",
            type: .plan,
            shortDescription: "Throw the perfect party",
            todos: [
                TodoTemplate(title: "Set date & time", description: "Check availability", recurring: .oneTime),
                TodoTemplate(title: "Create guest list", description: "Who to invite", recurring: .oneTime),
                TodoTemplate(title: "Send invitations", description: "Physical or digital", recurring: .oneTime),
                TodoTemplate(title: "Plan menu", description: "Food and drinks", recurring: .oneTime),
                TodoTemplate(title: "Shopping list", description: "Groceries and supplies", recurring: .oneTime),
                TodoTemplate(title: "Decorate venue", description: "Set the mood", recurring: .oneTime),
                TodoTemplate(title: "Day-of coordination", description: "Execute the plan", recurring: .oneTime),
                TodoTemplate(title: "Thank you notes", description: "Show appreciation", recurring: .oneTime)
            ]
        ),

        // 5. Career Development
        SubtypeTemplate(
            name: "Career Development",
            icon: "chart.line.uptrend.xyaxis",
            color: "teal",
            type: .plan,
            shortDescription: "Advance your career",
            todos: [
                TodoTemplate(title: "Update resume", description: "Highlight achievements", recurring: .oneTime),
                TodoTemplate(title: "LinkedIn optimization", description: "Professional profile", recurring: .oneTime),
                TodoTemplate(title: "Skill assessment", description: "Identify gaps", recurring: .oneTime),
                TodoTemplate(title: "Online courses", description: "Upskill yourself", recurring: .oneTime),
                TodoTemplate(title: "Network events", description: "Build connections", recurring: .weekly),
                TodoTemplate(title: "Mock interviews", description: "Practice makes perfect", recurring: .oneTime),
                TodoTemplate(title: "Job applications", description: "Apply to positions", recurring: .weekly),
                TodoTemplate(title: "Follow-ups", description: "Stay on their radar", recurring: .weekly)
            ]
        ),

        // 6. Fitness Transformation
        SubtypeTemplate(
            name: "Fitness Transformation",
            icon: "figure.strengthtraining.traditional",
            color: "red",
            type: .plan,
            shortDescription: "Transform your body & health",
            todos: [
                TodoTemplate(title: "Set fitness goals", description: "Weight, strength, endurance", recurring: .oneTime),
                TodoTemplate(title: "Take before photos", description: "Track visual progress", recurring: .oneTime),
                TodoTemplate(title: "Create workout plan", description: "Weekly schedule", recurring: .oneTime),
                TodoTemplate(title: "Plan meal prep", description: "Healthy eating strategy", recurring: .oneTime),
                TodoTemplate(title: "Daily workouts", description: "Follow the plan", recurring: .daily),
                TodoTemplate(title: "Track macros", description: "Monitor nutrition", recurring: .daily),
                TodoTemplate(title: "Weekly weigh-in", description: "Measure progress", recurring: .weekly),
                TodoTemplate(title: "Rest & recovery", description: "Essential for growth", recurring: .weekly),
                TodoTemplate(title: "Progress photos", description: "Monthly check-in", recurring: .monthly),
                TodoTemplate(title: "Celebrate milestones", description: "Reward achievements", recurring: .oneTime)
            ]
        )
    ]
}
