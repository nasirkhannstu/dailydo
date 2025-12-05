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
        // 1. Study Plan
        let studyPlan = Subtype(
            name: "IELTS Preparation",
            type: .plan,
            icon: "graduationcap.fill",
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 0
        )
        modelContext.insert(studyPlan)

        let sDate1 = addDays(to: Date(), days: 1)
        let sDate2 = addDays(to: Date(), days: 2)
        let sDate3 = addDays(to: Date(), days: 3)
        let sDate4 = addDays(to: Date(), days: 7)
        let sDate5 = addDays(to: Date(), days: 8)

        let studyTodos = [
            TodoItem(title: "Take diagnostic test", itemDescription: "Assess current level in all sections", starred: true, showInCalendar: false, subtype: studyPlan),
            TodoItem(title: "Identify weak areas", itemDescription: "Review test results and note areas needing improvement", showInCalendar: false, subtype: studyPlan),
            TodoItem(title: "Create study schedule", itemDescription: "Plan daily study time for next 8 weeks", showInCalendar: false, subtype: studyPlan),
            TodoItem(title: "Practice listening - Day 1", dueDate: sDate1, dueTime: sDate1, showInCalendar: false, recurringType: .daily, subtype: studyPlan),
            TodoItem(title: "Practice reading comprehension", dueDate: sDate1, dueTime: sDate1, showInCalendar: false, recurringType: .daily, subtype: studyPlan),
            TodoItem(title: "Writing task practice", dueDate: sDate2, dueTime: sDate2, showInCalendar: false, recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Speaking practice with partner", dueDate: sDate3, dueTime: sDate3, showInCalendar: false, recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Take mock test", dueDate: sDate4, dueTime: sDate4, showInCalendar: false, recurringType: .weekly, subtype: studyPlan),
            TodoItem(title: "Review and improve weak areas", dueDate: sDate5, dueTime: sDate5, showInCalendar: false, subtype: studyPlan)
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
            showInCalendar: false,
            isPreCreated: true,
            sortOrder: 1
        )
        modelContext.insert(fitnessPlan)

        let fDate1 = addDays(to: Date(), days: 7)
        let fDate2 = addDays(to: Date(), days: 14)
        let fDate3 = addDays(to: Date(), days: 21)
        let fDate4 = addDays(to: Date(), days: 28)

        let fitnessTodos = [
            TodoItem(title: "Week 1: Establish baseline", itemDescription: "Record weight, measurements, and fitness level", starred: true, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 1: Cut sugary drinks", itemDescription: "Replace with water and healthy alternatives", completed: true, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 2: Add morning cardio (20 min)", dueDate: fDate1, dueTime: fDate1, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 2: Track calorie intake", dueDate: fDate1, dueTime: fDate1, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 3: Increase workout to 30 min", dueDate: fDate2, dueTime: fDate2, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 3: Meal prep Sundays", dueDate: fDate2, dueTime: fDate2, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 4: Add strength training", dueDate: fDate3, dueTime: fDate3, showInCalendar: false, subtype: fitnessPlan),
            TodoItem(title: "Week 4: Final measurements", dueDate: fDate4, dueTime: fDate4, starred: true, showInCalendar: false, subtype: fitnessPlan)
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
            TodoItem(title: "Research destinations", itemDescription: "Paris, Rome, Barcelona, Amsterdam", showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Book flights", itemDescription: "Compare prices on different booking sites", starred: true, showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Reserve accommodations", itemDescription: "Book hotels or Airbnb for each city", starred: true, showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Plan daily itinerary", itemDescription: "Research attractions and create day-by-day plan", showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Get travel insurance", starred: true, showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Pack luggage", itemDescription: "Create packing checklist", showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Print important documents", itemDescription: "Tickets, hotel confirmations, insurance", showInCalendar: false, subtype: travelPlan),
            TodoItem(title: "Check passport validity", itemDescription: "Ensure 6+ months validity", starred: true, showInCalendar: false, subtype: travelPlan)
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
            TodoItem(title: "🥦 Broccoli", dueDate: shopDate, dueTime: shopDate, completed: true, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🥕 Carrots", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🍅 Tomatoes", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🥛 Milk", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🧀 Cheese", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🥩 Chicken breast", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🍞 Whole wheat bread", dueDate: shopDate, dueTime: shopDate, completed: true, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🥚 Eggs", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🧻 Paper towels", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList),
            TodoItem(title: "🧼 Dish soap", dueDate: shopDate, dueTime: shopDate, showInCalendar: false, subtype: shoppingList)
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
            TodoItem(title: "Interstellar (2014)", itemDescription: "Sci-Fi • Christopher Nolan", dueDate: movieDate, dueTime: movieDate, starred: true, showInCalendar: false, subtype: moviesList),
            TodoItem(title: "The Martian (2015)", itemDescription: "Sci-Fi • Matt Damon", dueDate: movieDate, dueTime: movieDate, showInCalendar: false, subtype: moviesList),
            TodoItem(title: "Arrival (2016)", itemDescription: "Sci-Fi • Amy Adams", dueDate: movieDate, dueTime: movieDate, showInCalendar: false, subtype: moviesList),
            TodoItem(title: "Blade Runner 2049 (2017)", itemDescription: "Sci-Fi • Ryan Gosling", dueDate: movieDate, dueTime: movieDate, completed: true, showInCalendar: false, subtype: moviesList),
            TodoItem(title: "Dune (2021)", itemDescription: "Sci-Fi • Timothée Chalamet", dueDate: movieDate, dueTime: movieDate, starred: true, showInCalendar: false, subtype: moviesList),
            TodoItem(title: "Everything Everywhere All at Once (2022)", itemDescription: "Sci-Fi • Michelle Yeoh", dueDate: movieDate, dueTime: movieDate, completed: true, showInCalendar: false, subtype: moviesList)
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
            TodoItem(title: "Atomic Habits", itemDescription: "James Clear - Self-improvement", dueDate: bookDate, dueTime: bookDate, starred: true, showInCalendar: false, subtype: booksList),
            TodoItem(title: "The 7 Habits of Highly Effective People", itemDescription: "Stephen Covey", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, subtype: booksList),
            TodoItem(title: "Deep Work", itemDescription: "Cal Newport - Productivity", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, subtype: booksList),
            TodoItem(title: "Thinking, Fast and Slow", itemDescription: "Daniel Kahneman", dueDate: bookDate, dueTime: bookDate, completed: true, showInCalendar: false, subtype: booksList),
            TodoItem(title: "The Power of Now", itemDescription: "Eckhart Tolle - Mindfulness", dueDate: bookDate, dueTime: bookDate, showInCalendar: false, subtype: booksList),
            TodoItem(title: "Man's Search for Meaning", itemDescription: "Viktor Frankl", dueDate: bookDate, dueTime: bookDate, completed: true, showInCalendar: false, subtype: booksList)
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
            TodoItem(title: "🍕 Authentic Italian pizza", itemDescription: "Neapolitan style from Italy", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, subtype: foodList),
            TodoItem(title: "🍜 Japanese ramen", itemDescription: "Traditional tonkotsu or miso", dueDate: foodDate, dueTime: foodDate, completed: true, showInCalendar: false, subtype: foodList),
            TodoItem(title: "🌮 Mexican street tacos", itemDescription: "Al pastor or carnitas", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, subtype: foodList),
            TodoItem(title: "🍛 Indian biryani", itemDescription: "Hyderabadi or Lucknowi style", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, subtype: foodList),
            TodoItem(title: "🥐 French croissants", itemDescription: "Fresh from a Parisian bakery", dueDate: foodDate, dueTime: foodDate, showInCalendar: false, subtype: foodList),
            TodoItem(title: "🍝 Thai pad thai", itemDescription: "Authentic street food version", dueDate: foodDate, dueTime: foodDate, completed: true, showInCalendar: false, subtype: foodList)
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
