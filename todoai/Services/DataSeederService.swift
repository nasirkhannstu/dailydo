//
//  DataSeederService.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import Foundation
import SwiftData

@MainActor
class DataSeederService {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Check if app has been seeded before
    func needsSeeding() -> Bool {
        // Check if any pre-created subtypes exist
        let descriptor = FetchDescriptor<Subtype>()
        let allSubtypes = (try? modelContext.fetch(descriptor)) ?? []
        let preCreatedCount = allSubtypes.filter { $0.isPreCreated }.count

        print("📊 Total subtypes: \(allSubtypes.count), Pre-created: \(preCreatedCount)")

        // If no pre-created subtypes exist, we need to seed
        return preCreatedCount == 0
    }

    // Seed all sample data
    func seedSampleData() {
        let needsSeed = needsSeeding()
        print("🌱 needsSeeding check: \(needsSeed)")

        guard needsSeed else {
            print("⏭️  Skipping seeding - data already exists")
            return
        }

        print("🌱 Starting to seed sample data...")

        seedHabits()
        print("✅ Habits seeded")

        seedPlans()
        print("✅ Plans seeded")

        seedLists()
        print("✅ Lists seeded")

        // Save context
        do {
            try modelContext.save()
            print("✅ Sample data seeded successfully and saved!")
        } catch {
            print("❌ Error seeding data: \(error)")
        }
    }

    // MARK: - Seed Habits

    private func seedHabits() {
        // 1. Water Intake Habit
        let waterHabit = Subtype(
            name: "Water Intake",
            type: .habit,
            icon: "drop.fill",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(waterHabit)

        // Add water intake todos
        let waterTodos = [
            TodoItem(title: "Morning (1 glass)", dueTime: createTime(hour: 8, minute: 0), reminderEnabled: true, recurringType: .daily, aiGenerated: false, subtype: waterHabit),
            TodoItem(title: "After breakfast (1 glass)", dueTime: createTime(hour: 9, minute: 0), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Mid-morning (1 glass)", dueTime: createTime(hour: 11, minute: 0), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "After lunch (1 glass)", dueTime: createTime(hour: 13, minute: 30), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Afternoon (1 glass)", dueTime: createTime(hour: 15, minute: 0), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Evening (1 glass)", dueTime: createTime(hour: 18, minute: 0), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "After dinner (1 glass)", dueTime: createTime(hour: 20, minute: 0), recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Before bed (1 glass)", dueTime: createTime(hour: 22, minute: 0), recurringType: .daily, subtype: waterHabit)
        ]

        waterTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 2. Walking Habit
        let walkingHabit = Subtype(
            name: "Daily Walking",
            type: .habit,
            icon: "figure.walk",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(walkingHabit)

        let walkingTodos = [
            TodoItem(title: "Morning walk - 30 minutes", dueTime: createTime(hour: 7, minute: 0), reminderEnabled: true, recurringType: .daily, subtype: walkingHabit),
            TodoItem(title: "After lunch walk - 15 minutes", dueTime: createTime(hour: 14, minute: 0), recurringType: .daily, subtype: walkingHabit),
            TodoItem(title: "Evening walk - 30 minutes", dueTime: createTime(hour: 18, minute: 30), recurringType: .daily, subtype: walkingHabit)
        ]

        walkingTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 3. Reading Habit
        let readingHabit = Subtype(
            name: "Daily Reading",
            type: .habit,
            icon: "book.fill",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 2
        )
        modelContext.insert(readingHabit)

        let readingTodos = [
            TodoItem(title: "Morning reading - 30 minutes", dueTime: createTime(hour: 6, minute: 30), recurringType: .daily, subtype: readingHabit),
            TodoItem(title: "Lunch break reading - 15 minutes", dueTime: createTime(hour: 13, minute: 0), recurringType: .daily, subtype: readingHabit),
            TodoItem(title: "Night reading - 30 minutes", dueTime: createTime(hour: 21, minute: 0), reminderEnabled: true, recurringType: .daily, subtype: readingHabit)
        ]

        readingTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 4. Exercise Habit
        let exerciseHabit = Subtype(
            name: "Exercise Routine",
            type: .habit,
            icon: "figure.strengthtraining.traditional",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 3
        )
        modelContext.insert(exerciseHabit)

        let exerciseTodos = [
            TodoItem(title: "Morning workout - 45 minutes", dueTime: createTime(hour: 6, minute: 0), reminderEnabled: true, recurringType: .daily, subtype: exerciseHabit),
            TodoItem(title: "Stretching - 15 minutes", dueTime: createTime(hour: 7, minute: 0), recurringType: .daily, subtype: exerciseHabit),
            TodoItem(title: "Evening yoga - 30 minutes", dueTime: createTime(hour: 19, minute: 0), recurringType: .daily, subtype: exerciseHabit)
        ]

        exerciseTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }
    }

    // MARK: - Seed Plans

    private func seedPlans() {
        // 1. Study Plan
        let studyPlan = Subtype(
            name: "IELTS Preparation",
            type: .plan,
            icon: "graduationcap.fill",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(studyPlan)

        let studyTodos = [
            TodoItem(title: "Take diagnostic test", itemDescription: "Assess current level in all sections", starred: true, subtype: studyPlan),
            TodoItem(title: "Identify weak areas", itemDescription: "Review test results and note areas needing improvement", subtype: studyPlan),
            TodoItem(title: "Create study schedule", itemDescription: "Plan daily study time for next 8 weeks", subtype: studyPlan),
            TodoItem(title: "Practice listening - Day 1", dueDate: addDays(to: Date(), days: 1), recurringType: .daily, subtype: studyPlan),
            TodoItem(title: "Practice reading comprehension", dueDate: addDays(to: Date(), days: 1), recurringType: .daily, subtype: studyPlan),
            TodoItem(title: "Writing task practice", dueDate: addDays(to: Date(), days: 2), recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Speaking practice with partner", dueDate: addDays(to: Date(), days: 3), recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Take mock test", dueDate: addDays(to: Date(), days: 7), recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Review and improve weak areas", dueDate: addDays(to: Date(), days: 8), subtype: studyPlan)
        ]

        studyTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 2. Fitness Plan
        let fitnessPlan = Subtype(
            name: "30-Day Fitness Challenge",
            type: .plan,
            icon: "heart.fill",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(fitnessPlan)

        let fitnessTodos = [
            TodoItem(title: "Week 1: Establish baseline", itemDescription: "Record weight, measurements, and fitness level", starred: true, subtype: fitnessPlan),
            TodoItem(title: "Week 1: Cut sugary drinks", itemDescription: "Replace with water and healthy alternatives", completed: true, subtype: fitnessPlan),
            TodoItem(title: "Week 2: Add morning cardio (20 min)", dueDate: addDays(to: Date(), days: 7), subtype: fitnessPlan),
            TodoItem(title: "Week 2: Track calorie intake", dueDate: addDays(to: Date(), days: 7), subtype: fitnessPlan),
            TodoItem(title: "Week 3: Increase workout to 30 min", dueDate: addDays(to: Date(), days: 14), subtype: fitnessPlan),
            TodoItem(title: "Week 3: Meal prep Sundays", dueDate: addDays(to: Date(), days: 14), subtype: fitnessPlan),
            TodoItem(title: "Week 4: Add strength training", dueDate: addDays(to: Date(), days: 21), subtype: fitnessPlan),
            TodoItem(title: "Week 4: Final measurements", dueDate: addDays(to: Date(), days: 28), starred: true, subtype: fitnessPlan)
        ]

        fitnessTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 3. Travel Plan
        let travelPlan = Subtype(
            name: "Europe Trip Planning",
            type: .plan,
            icon: "airplane",
            showInCalendar: true,
            isPreCreated: true,
            sortOrder: 2
        )
        modelContext.insert(travelPlan)

        let travelTodos = [
            TodoItem(title: "Research destinations", itemDescription: "Paris, Rome, Barcelona, Amsterdam", subtype: travelPlan),
            TodoItem(title: "Book flights", itemDescription: "Compare prices on different booking sites", starred: true, subtype: travelPlan),
            TodoItem(title: "Reserve accommodations", itemDescription: "Book hotels or Airbnb for each city", starred: true, subtype: travelPlan),
            TodoItem(title: "Plan daily itinerary", itemDescription: "Research attractions and create day-by-day plan", subtype: travelPlan),
            TodoItem(title: "Get travel insurance", starred: true, subtype: travelPlan),
            TodoItem(title: "Pack luggage", itemDescription: "Create packing checklist", subtype: travelPlan),
            TodoItem(title: "Print important documents", itemDescription: "Tickets, hotel confirmations, insurance", subtype: travelPlan),
            TodoItem(title: "Check passport validity", itemDescription: "Ensure 6+ months validity", starred: true, subtype: travelPlan)
        ]

        travelTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }
    }

    // MARK: - Seed Lists

    private func seedLists() {
        // 1. Shopping List
        let shoppingList = Subtype(
            name: "Grocery Shopping",
            type: .list,
            icon: "cart.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(shoppingList)

        let shoppingTodos = [
            TodoItem(title: "🥦 Broccoli", completed: true, subtype: shoppingList),
            TodoItem(title: "🥕 Carrots", subtype: shoppingList),
            TodoItem(title: "🍅 Tomatoes", subtype: shoppingList),
            TodoItem(title: "🥛 Milk", subtype: shoppingList),
            TodoItem(title: "🧀 Cheese", subtype: shoppingList),
            TodoItem(title: "🥩 Chicken breast", subtype: shoppingList),
            TodoItem(title: "🍞 Whole wheat bread", completed: true, subtype: shoppingList),
            TodoItem(title: "🥚 Eggs", subtype: shoppingList),
            TodoItem(title: "🧻 Paper towels", subtype: shoppingList),
            TodoItem(title: "🧼 Dish soap", subtype: shoppingList)
        ]

        shoppingTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 2. Movies to Watch
        let moviesList = Subtype(
            name: "Movies to Watch",
            type: .list,
            icon: "film.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(moviesList)

        let movieTodos = [
            TodoItem(title: "Interstellar (2014)", itemDescription: "Sci-Fi • Christopher Nolan", starred: true, subtype: moviesList),
            TodoItem(title: "The Martian (2015)", itemDescription: "Sci-Fi • Matt Damon", subtype: moviesList),
            TodoItem(title: "Arrival (2016)", itemDescription: "Sci-Fi • Amy Adams", subtype: moviesList),
            TodoItem(title: "Blade Runner 2049 (2017)", itemDescription: "Sci-Fi • Ryan Gosling", completed: true, subtype: moviesList),
            TodoItem(title: "Dune (2021)", itemDescription: "Sci-Fi • Timothée Chalamet", starred: true, subtype: moviesList),
            TodoItem(title: "Everything Everywhere All at Once (2022)", itemDescription: "Sci-Fi • Michelle Yeoh", completed: true, subtype: moviesList)
        ]

        movieTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 3. Books to Read
        let booksList = Subtype(
            name: "Reading List",
            type: .list,
            icon: "book.closed.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 2
        )
        modelContext.insert(booksList)

        let bookTodos = [
            TodoItem(title: "Atomic Habits", itemDescription: "James Clear - Self-improvement", starred: true, subtype: booksList),
            TodoItem(title: "The 7 Habits of Highly Effective People", itemDescription: "Stephen Covey", subtype: booksList),
            TodoItem(title: "Deep Work", itemDescription: "Cal Newport - Productivity", subtype: booksList),
            TodoItem(title: "Thinking, Fast and Slow", itemDescription: "Daniel Kahneman", completed: true, subtype: booksList),
            TodoItem(title: "The Power of Now", itemDescription: "Eckhart Tolle - Mindfulness", subtype: booksList),
            TodoItem(title: "Man's Search for Meaning", itemDescription: "Viktor Frankl", completed: true, subtype: booksList)
        ]

        bookTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 4. Food to Try
        let foodList = Subtype(
            name: "Food to Try",
            type: .list,
            icon: "fork.knife",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 3
        )
        modelContext.insert(foodList)

        let foodTodos = [
            TodoItem(title: "🍕 Authentic Italian pizza", itemDescription: "Neapolitan style from Italy", subtype: foodList),
            TodoItem(title: "🍜 Japanese ramen", itemDescription: "Traditional tonkotsu or miso", completed: true, subtype: foodList),
            TodoItem(title: "🌮 Mexican street tacos", itemDescription: "Al pastor or carnitas", subtype: foodList),
            TodoItem(title: "🍛 Indian biryani", itemDescription: "Hyderabadi or Lucknowi style", subtype: foodList),
            TodoItem(title: "🥐 French croissants", itemDescription: "Fresh from a Parisian bakery", subtype: foodList),
            TodoItem(title: "🍝 Thai pad thai", itemDescription: "Authentic street food version", completed: true, subtype: foodList)
        ]

        foodTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }
    }

    // MARK: - Helper Functions

    private func createTime(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }

    private func addDays(to date: Date, days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
}
