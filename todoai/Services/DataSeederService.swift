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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(waterHabit)

        // Add water intake todos
        let time1 = createTime(hour: 8, minute: 0)
        let time2 = createTime(hour: 9, minute: 0)
        let time3 = createTime(hour: 11, minute: 0)
        let time4 = createTime(hour: 13, minute: 30)
        let time5 = createTime(hour: 15, minute: 0)
        let time6 = createTime(hour: 18, minute: 0)
        let time7 = createTime(hour: 20, minute: 0)
        let time8 = createTime(hour: 22, minute: 0)

        let waterTodos = [
            TodoItem(title: "Morning (1 glass)", dueDate: time1, dueTime: time1, reminderEnabled: true, showInCalendar: false, recurringType: .daily, aiGenerated: false, subtype: waterHabit),
            TodoItem(title: "After breakfast (1 glass)", dueDate: time2, dueTime: time2, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Mid-morning (1 glass)", dueDate: time3, dueTime: time3, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "After lunch (1 glass)", dueDate: time4, dueTime: time4, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Afternoon (1 glass)", dueDate: time5, dueTime: time5, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Evening (1 glass)", dueDate: time6, dueTime: time6, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "After dinner (1 glass)", dueDate: time7, dueTime: time7, showInCalendar: false, recurringType: .daily, subtype: waterHabit),
            TodoItem(title: "Before bed (1 glass)", dueDate: time8, dueTime: time8, showInCalendar: false, recurringType: .daily, subtype: waterHabit)
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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(walkingHabit)

        let wTime1 = createTime(hour: 7, minute: 0)
        let wTime2 = createTime(hour: 14, minute: 0)
        let wTime3 = createTime(hour: 18, minute: 30)

        let walkingTodos = [
            TodoItem(title: "Morning walk - 30 minutes", dueDate: wTime1, dueTime: wTime1, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: walkingHabit),
            TodoItem(title: "After lunch walk - 15 minutes", dueDate: wTime2, dueTime: wTime2, showInCalendar: false, recurringType: .daily, subtype: walkingHabit),
            TodoItem(title: "Evening walk - 30 minutes", dueDate: wTime3, dueTime: wTime3, showInCalendar: false, recurringType: .daily, subtype: walkingHabit)
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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 2
        )
        modelContext.insert(readingHabit)

        let rTime1 = createTime(hour: 6, minute: 30)
        let rTime2 = createTime(hour: 13, minute: 0)
        let rTime3 = createTime(hour: 21, minute: 0)

        let readingTodos = [
            TodoItem(title: "Morning reading - 30 minutes", dueDate: rTime1, dueTime: rTime1, showInCalendar: false, recurringType: .daily, subtype: readingHabit),
            TodoItem(title: "Lunch break reading - 15 minutes", dueDate: rTime2, dueTime: rTime2, showInCalendar: false, recurringType: .daily, subtype: readingHabit),
            TodoItem(title: "Night reading - 30 minutes", dueDate: rTime3, dueTime: rTime3, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: readingHabit)
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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 3
        )
        modelContext.insert(exerciseHabit)

        let eTime1 = createTime(hour: 6, minute: 0)
        let eTime2 = createTime(hour: 7, minute: 0)
        let eTime3 = createTime(hour: 19, minute: 0)

        let exerciseTodos = [
            TodoItem(title: "Morning workout - 45 minutes", dueDate: eTime1, dueTime: eTime1, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: exerciseHabit),
            TodoItem(title: "Stretching - 15 minutes", dueDate: eTime2, dueTime: eTime2, showInCalendar: false, recurringType: .daily, subtype: exerciseHabit),
            TodoItem(title: "Evening yoga - 30 minutes", dueDate: eTime3, dueTime: eTime3, showInCalendar: false, recurringType: .daily, subtype: exerciseHabit)
        ]

        exerciseTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 5. Medication Reminder Habit
        let medicationHabit = Subtype(
            name: "Medication Reminder",
            type: .habit,
            icon: "cross.case.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 4
        )
        modelContext.insert(medicationHabit)

        let mTime1 = createTime(hour: 8, minute: 30)
        let mTime2 = createTime(hour: 13, minute: 0)
        let mTime3 = createTime(hour: 20, minute: 0)
        let mTime4 = createTime(hour: 22, minute: 0)
        let mTime5 = createTime(hour: 7, minute: 0)

        let medicationTodos = [
            TodoItem(title: "Vitamin D - 1000 IU", itemDescription: "Take with breakfast", dueDate: mTime1, dueTime: mTime1, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: medicationHabit),
            TodoItem(title: "Multivitamin", itemDescription: "Take with morning meal", dueDate: mTime1, dueTime: mTime1, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: medicationHabit),
            TodoItem(title: "Omega-3 Fish Oil", itemDescription: "Take with lunch", dueDate: mTime2, dueTime: mTime2, showInCalendar: false, recurringType: .daily, subtype: medicationHabit),
            TodoItem(title: "Blood Pressure Medication", itemDescription: "Take in evening", dueDate: mTime3, dueTime: mTime3, reminderEnabled: true, showInCalendar: false, recurringType: .daily, subtype: medicationHabit),
            TodoItem(title: "Calcium + Vitamin K2", itemDescription: "Take before bed", dueDate: mTime4, dueTime: mTime4, showInCalendar: false, recurringType: .daily, subtype: medicationHabit),
            TodoItem(title: "Probiotic", itemDescription: "Take on empty stomach", dueDate: mTime5, dueTime: mTime5, showInCalendar: false, recurringType: .daily, subtype: medicationHabit)
        ]

        medicationTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }
    }

    // MARK: - Seed Plans

    private func seedPlans() {
        // 1. Study Plan (60-Day IELTS Preparation with end date)
        let studyPlan = Subtype(
            name: "IELTS Preparation",
            type: .plan,
            icon: "graduationcap.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(studyPlan)

        let today = Date()
        let examDate = addDays(to: today, days: 60)
        let morningStudyTime = createTime(hour: 7, minute: 0)
        let eveningStudyTime = createTime(hour: 19, minute: 0)

        let studyTodos = [
            // Initial tasks - using oneTime type
            TodoItem(
                title: "Take diagnostic test",
                itemDescription: "Assess current level in all sections",
                dueDate: today,
                dueTime: today,
                priority: .high,
                showInCalendar: false,
                recurringType: .oneTime,
                subtype: studyPlan
            ),
            TodoItem(
                title: "Create study schedule",
                itemDescription: "Plan daily study time for next 60 days",
                dueDate: today,
                dueTime: today,
                showInCalendar: false,
                recurringType: .oneTime,
                subtype: studyPlan
            ),

            // Daily recurring tasks until exam
            TodoItem(
                title: "Listening practice - 30 minutes",
                itemDescription: "IELTS listening exercises and mock tests",
                dueDate: morningStudyTime,
                dueTime: morningStudyTime,
                reminderEnabled: true,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),
            TodoItem(
                title: "Reading comprehension - 45 minutes",
                itemDescription: "Practice reading passages and questions",
                dueDate: morningStudyTime,
                dueTime: morningStudyTime,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),
            TodoItem(
                title: "Vocabulary building - 20 minutes",
                itemDescription: "Learn 10 new words and review previous",
                dueDate: eveningStudyTime,
                dueTime: eveningStudyTime,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),

            // Weekly recurring tasks
            TodoItem(
                title: "Writing task 1 & 2 practice",
                itemDescription: "Complete full writing test under timed conditions",
                dueDate: addDays(to: today, days: 5),
                dueTime: addDays(to: today, days: 5),
                priority: .high,
                showInCalendar: false,
                recurringType: .weekly,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),
            TodoItem(
                title: "Speaking practice session",
                itemDescription: "Practice with partner or record yourself",
                dueDate: addDays(to: today, days: 6),
                dueTime: addDays(to: today, days: 6),
                showInCalendar: false,
                recurringType: .weekly,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),
            TodoItem(
                title: "Full mock test",
                itemDescription: "Complete all 4 sections under exam conditions",
                dueDate: addDays(to: today, days: 7),
                dueTime: addDays(to: today, days: 7),
                priority: .high,
                showInCalendar: false,
                recurringType: .weekly,
                recurringEndDate: examDate,
                subtype: studyPlan
            ),

            // Final exam day - using dueDate type
            TodoItem(
                title: "IELTS Exam Day",
                itemDescription: "Good luck! You've prepared well.",
                dueDate: examDate,
                dueTime: examDate,
                priority: .high,
                showInCalendar: false,
                recurringType: .dueDate,
                subtype: studyPlan
            )
        ]

        studyTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }

        // 2. Fitness Plan (30-Day Challenge with recurring end dates)
        let fitnessPlan = Subtype(
            name: "30-Day Fitness Challenge",
            type: .plan,
            icon: "heart.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(fitnessPlan)

        let fitnessEndDate = addDays(to: today, days: 30)
        let fitnessMorningTime = createTime(hour: 6, minute: 30)
        let fitnessEveningTime = createTime(hour: 18, minute: 0)
        let fitnessNightTime = createTime(hour: 21, minute: 0)

        let fitnessTodos = [
            // Daily recurring tasks with 30-day end date
            TodoItem(
                title: "Morning cardio - 20 minutes",
                itemDescription: "Running, cycling, or brisk walking",
                dueDate: fitnessMorningTime,
                dueTime: fitnessMorningTime,
                priority: .high,
                reminderEnabled: true,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: fitnessEndDate,
                subtype: fitnessPlan
            ),
            TodoItem(
                title: "Track daily calorie intake",
                itemDescription: "Log all meals and snacks",
                dueDate: fitnessNightTime,
                dueTime: fitnessNightTime,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: fitnessEndDate,
                subtype: fitnessPlan
            ),
            TodoItem(
                title: "Drink 8 glasses of water",
                itemDescription: "Stay hydrated throughout the day",
                dueDate: fitnessEveningTime,
                dueTime: fitnessEveningTime,
                showInCalendar: false,
                recurringType: .daily,
                recurringEndDate: fitnessEndDate,
                subtype: fitnessPlan
            ),

            // Weekly milestones - using dueDate type for specific dates
            TodoItem(
                title: "Week 1: Establish baseline",
                itemDescription: "Record weight, measurements, and fitness level",
                dueDate: today,
                dueTime: today,
                priority: .high,
                showInCalendar: false,
                recurringType: .dueDate,
                subtype: fitnessPlan
            ),
            TodoItem(
                title: "Week 2: Progress check",
                itemDescription: "Review progress and adjust plan if needed",
                dueDate: addDays(to: today, days: 7),
                dueTime: addDays(to: today, days: 7),
                showInCalendar: false,
                recurringType: .dueDate,
                subtype: fitnessPlan
            ),
            TodoItem(
                title: "Week 3: Increase intensity",
                itemDescription: "Add 10 minutes to cardio sessions",
                dueDate: addDays(to: today, days: 14),
                dueTime: addDays(to: today, days: 14),
                showInCalendar: false,
                recurringType: .dueDate,
                subtype: fitnessPlan
            ),
            TodoItem(
                title: "Week 4: Final measurements",
                itemDescription: "Record final weight, measurements, and celebrate success!",
                dueDate: fitnessEndDate,
                dueTime: fitnessEndDate,
                priority: .high,
                showInCalendar: false,
                recurringType: .dueDate,
                subtype: fitnessPlan
            )
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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 2
        )
        modelContext.insert(travelPlan)

        let travelTodos = [
            TodoItem(title: "Research destinations", itemDescription: "Paris, Rome, Barcelona, Amsterdam", showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Book flights", itemDescription: "Compare prices on different booking sites", priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Reserve accommodations", itemDescription: "Book hotels or Airbnb for each city", priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Plan daily itinerary", itemDescription: "Research attractions and create day-by-day plan", showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Get travel insurance", priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Pack luggage", itemDescription: "Create packing checklist", showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Print important documents", itemDescription: "Tickets, hotel confirmations, insurance", showInCalendar: false, recurringType: .oneTime, subtype: travelPlan),
            TodoItem(title: "Check passport validity", itemDescription: "Ensure 6+ months validity", priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: travelPlan)
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

        let shopDate = Date()

        let shoppingTodos = [
            TodoItem(title: "🥦 Broccoli", dueDate: shopDate, dueTime: shopDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🥕 Carrots", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🍅 Tomatoes", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🥛 Milk", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🧀 Cheese", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🥩 Chicken breast", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🍞 Whole wheat bread", dueDate: shopDate, dueTime: shopDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🥚 Eggs", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🧻 Paper towels", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList),
            TodoItem(title: "🧼 Dish soap", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, recurringType: .oneTime, subtype: shoppingList)
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

        let movieDate = Date()

        let movieTodos = [
            TodoItem(title: "Interstellar (2014)", itemDescription: "Sci-Fi • Christopher Nolan", dueDate: movieDate, dueTime: movieDate, priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: moviesList),
            TodoItem(title: "The Martian (2015)", itemDescription: "Sci-Fi • Matt Damon", dueDate: movieDate, dueTime: movieDate, showInCalendar: false, recurringType: .oneTime, subtype: moviesList),
            TodoItem(title: "Arrival (2016)", itemDescription: "Sci-Fi • Amy Adams", dueDate: movieDate, dueTime: movieDate, showInCalendar: false, recurringType: .oneTime, subtype: moviesList),
            TodoItem(title: "Blade Runner 2049 (2017)", itemDescription: "Sci-Fi • Ryan Gosling", dueDate: movieDate, dueTime: movieDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: moviesList),
            TodoItem(title: "Dune (2021)", itemDescription: "Sci-Fi • Timothée Chalamet", dueDate: movieDate, dueTime: movieDate, priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: moviesList),
            TodoItem(title: "Everything Everywhere All at Once (2022)", itemDescription: "Sci-Fi • Michelle Yeoh", dueDate: movieDate, dueTime: movieDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: moviesList)
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

        let bookDate = Date()

        let bookTodos = [
            TodoItem(title: "Atomic Habits", itemDescription: "James Clear - Self-improvement", dueDate: bookDate, dueTime: bookDate, priority: .high, showInCalendar: false, recurringType: .oneTime, subtype: booksList),
            TodoItem(title: "The 7 Habits of Highly Effective People", itemDescription: "Stephen Covey", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, recurringType: .oneTime, subtype: booksList),
            TodoItem(title: "Deep Work", itemDescription: "Cal Newport - Productivity", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, recurringType: .oneTime, subtype: booksList),
            TodoItem(title: "Thinking, Fast and Slow", itemDescription: "Daniel Kahneman", dueDate: bookDate, dueTime: bookDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: booksList),
            TodoItem(title: "The Power of Now", itemDescription: "Eckhart Tolle - Mindfulness", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, recurringType: .oneTime, subtype: booksList),
            TodoItem(title: "Man's Search for Meaning", itemDescription: "Viktor Frankl", dueDate: bookDate, dueTime: bookDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: booksList)
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

        let foodDate = Date()

        let foodTodos = [
            TodoItem(title: "🍕 Authentic Italian pizza", itemDescription: "Neapolitan style from Italy", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, recurringType: .oneTime, subtype: foodList),
            TodoItem(title: "🍜 Japanese ramen", itemDescription: "Traditional tonkotsu or miso", dueDate: foodDate, dueTime: foodDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: foodList),
            TodoItem(title: "🌮 Mexican street tacos", itemDescription: "Al pastor or carnitas", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, recurringType: .oneTime, subtype: foodList),
            TodoItem(title: "🍛 Indian biryani", itemDescription: "Hyderabadi or Lucknowi style", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, recurringType: .oneTime, subtype: foodList),
            TodoItem(title: "🥐 French croissants", itemDescription: "Fresh from a Parisian bakery", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, recurringType: .oneTime, subtype: foodList),
            TodoItem(title: "🍝 Thai pad thai", itemDescription: "Authentic street food version", dueDate: foodDate, dueTime: foodDate, completed: true, showInCalendar: false, recurringType: .oneTime, subtype: foodList)
        ]

        foodTodos.enumerated().forEach { index, todo in
            todo.sortOrder = index
            modelContext.insert(todo)
        }
    }

    // MARK: - Helper Functions

    private func createTime(hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }

    private func addDays(to date: Date, days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
}
