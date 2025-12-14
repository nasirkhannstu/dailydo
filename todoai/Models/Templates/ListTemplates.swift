//
//  ListTemplates.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import Foundation

extension SubtypeTemplate {
    /// Pre-configured list templates
    static let listTemplates: [SubtypeTemplate] = [
        // 1. Grocery Shopping
        SubtypeTemplate(
            name: "Grocery Shopping",
            icon: "cart.fill",
            color: "green",
            type: .list,
            shortDescription: "Never forget an item",
            todos: [
                TodoTemplate(title: "Fruits", description: "Apples, bananas, berries", recurring: .oneTime),
                TodoTemplate(title: "Vegetables", description: "Lettuce, tomatoes, carrots", recurring: .oneTime),
                TodoTemplate(title: "Herbs", description: "Basil, cilantro, parsley", recurring: .oneTime),
                TodoTemplate(title: "Milk", description: "Dairy or alternative", recurring: .oneTime),
                TodoTemplate(title: "Eggs", description: "Free-range if possible", recurring: .oneTime),
                TodoTemplate(title: "Cheese", description: "Various types", recurring: .oneTime),
                TodoTemplate(title: "Rice/Pasta", description: "Pantry staples", recurring: .oneTime),
                TodoTemplate(title: "Canned goods", description: "Beans, tomatoes, etc", recurring: .oneTime),
                TodoTemplate(title: "Snacks", description: "Healthy options", recurring: .oneTime),
                TodoTemplate(title: "Meat/Protein", description: "Chicken, fish, tofu", recurring: .oneTime),
                TodoTemplate(title: "Bread", description: "Whole grain preferred", recurring: .oneTime),
                TodoTemplate(title: "Condiments", description: "Oil, vinegar, sauces", recurring: .oneTime)
            ]
        ),

        // 2. Meal Planning
        SubtypeTemplate(
            name: "Meal Planning",
            icon: "fork.knife",
            color: "orange",
            type: .list,
            shortDescription: "Plan healthy meals",
            todos: [
                TodoTemplate(title: "Monday Breakfast", description: "Oatmeal with berries", recurring: .oneTime),
                TodoTemplate(title: "Monday Lunch", description: "Grilled chicken salad", recurring: .oneTime),
                TodoTemplate(title: "Monday Dinner", description: "Pasta with vegetables", recurring: .oneTime),
                TodoTemplate(title: "Tuesday Breakfast", description: "Scrambled eggs & toast", recurring: .oneTime),
                TodoTemplate(title: "Tuesday Lunch", description: "Quinoa bowl", recurring: .oneTime),
                TodoTemplate(title: "Tuesday Dinner", description: "Baked salmon & rice", recurring: .oneTime),
                TodoTemplate(title: "Wednesday Breakfast", description: "Smoothie bowl", recurring: .oneTime),
                TodoTemplate(title: "Wednesday Lunch", description: "Soup & sandwich", recurring: .oneTime),
                TodoTemplate(title: "Wednesday Dinner", description: "Stir-fry with tofu", recurring: .oneTime),
                TodoTemplate(title: "Prep ingredients Sunday", description: "Meal prep day", recurring: .oneTime)
            ]
        ),

        // 3. Reading List
        SubtypeTemplate(
            name: "Reading List",
            icon: "book.closed.fill",
            color: "brown",
            type: .list,
            shortDescription: "Books to read",
            todos: [
                TodoTemplate(title: "Fiction: The Midnight Library", description: "By Matt Haig", recurring: .oneTime),
                TodoTemplate(title: "Non-fiction: Atomic Habits", description: "By James Clear", recurring: .oneTime),
                TodoTemplate(title: "Biography: Steve Jobs", description: "By Walter Isaacson", recurring: .oneTime),
                TodoTemplate(title: "Self-help: The 7 Habits", description: "By Stephen Covey", recurring: .oneTime),
                TodoTemplate(title: "Business: Good to Great", description: "By Jim Collins", recurring: .oneTime),
                TodoTemplate(title: "Psychology: Thinking Fast and Slow", description: "By Daniel Kahneman", recurring: .oneTime),
                TodoTemplate(title: "Science: A Brief History of Time", description: "By Stephen Hawking", recurring: .oneTime),
                TodoTemplate(title: "Philosophy: Meditations", description: "By Marcus Aurelius", recurring: .oneTime)
            ]
        ),

        // 4. Cleaning Schedule
        SubtypeTemplate(
            name: "Cleaning Schedule",
            icon: "sparkles",
            color: "blue",
            type: .list,
            shortDescription: "Keep your space tidy",
            todos: [
                TodoTemplate(title: "Make bed", description: "Start day fresh", recurring: .daily),
                TodoTemplate(title: "Wash dishes", description: "Don't let them pile up", recurring: .daily),
                TodoTemplate(title: "Wipe counters", description: "Kitchen & bathroom", recurring: .daily),
                TodoTemplate(title: "Vacuum floors", description: "All rooms", recurring: .weekly),
                TodoTemplate(title: "Laundry", description: "Wash, dry, fold", recurring: .weekly),
                TodoTemplate(title: "Clean bathrooms", description: "Toilet, sink, shower", recurring: .weekly),
                TodoTemplate(title: "Dust surfaces", description: "Shelves, tables", recurring: .weekly),
                TodoTemplate(title: "Mop floors", description: "Kitchen & bathroom", recurring: .weekly),
                TodoTemplate(title: "Deep clean kitchen", description: "Oven, fridge, pantry", recurring: .monthly),
                TodoTemplate(title: "Organize closets", description: "Declutter", recurring: .monthly)
            ]
        ),

        // 5. Travel Checklist
        SubtypeTemplate(
            name: "Travel Checklist",
            icon: "airplane",
            color: "purple",
            type: .list,
            shortDescription: "Plan the perfect trip",
            todos: [
                TodoTemplate(title: "Book flights & hotels", description: "Reserve accommodations", recurring: .oneTime),
                TodoTemplate(title: "Check passport validity", description: "6+ months remaining", recurring: .oneTime),
                TodoTemplate(title: "Apply for visa if needed", description: "Check requirements", recurring: .oneTime),
                TodoTemplate(title: "Travel insurance", description: "Get coverage", recurring: .oneTime),
                TodoTemplate(title: "Notify bank of travel", description: "Avoid card blocks", recurring: .oneTime),
                TodoTemplate(title: "Pack essentials", description: "Clothes, toiletries, meds", recurring: .oneTime),
                TodoTemplate(title: "Phone charger & adapters", description: "International plugs", recurring: .oneTime),
                TodoTemplate(title: "Download offline maps", description: "For navigation", recurring: .oneTime),
                TodoTemplate(title: "Check-in online", description: "24 hours before", recurring: .oneTime),
                TodoTemplate(title: "Arrange airport transfer", description: "To/from airport", recurring: .oneTime),
                TodoTemplate(title: "Stop mail & deliveries", description: "While away", recurring: .oneTime),
                TodoTemplate(title: "Lock windows & doors", description: "Secure home", recurring: .oneTime),
                TodoTemplate(title: "Turn off utilities", description: "Save energy", recurring: .oneTime)
            ]
        ),

        // 6. Moving Checklist
        SubtypeTemplate(
            name: "Moving Checklist",
            icon: "shippingbox.fill",
            color: "cyan",
            type: .list,
            shortDescription: "Stress-free relocation",
            todos: [
                TodoTemplate(title: "Create moving timeline", description: "Plan ahead", recurring: .oneTime),
                TodoTemplate(title: "Notify landlord/realtor", description: "Give proper notice", recurring: .oneTime),
                TodoTemplate(title: "Hire movers or rent truck", description: "Book in advance", recurring: .oneTime),
                TodoTemplate(title: "Change address", description: "Post office, banks, etc", recurring: .oneTime),
                TodoTemplate(title: "Transfer utilities", description: "Electric, gas, internet", recurring: .oneTime),
                TodoTemplate(title: "Pack essentials box", description: "First day items", recurring: .oneTime),
                TodoTemplate(title: "Label all boxes", description: "Room & contents", recurring: .oneTime),
                TodoTemplate(title: "Take meter readings", description: "Document utilities", recurring: .oneTime),
                TodoTemplate(title: "Clean old place", description: "Get deposit back", recurring: .oneTime),
                TodoTemplate(title: "Update subscriptions", description: "Deliveries & services", recurring: .oneTime),
                TodoTemplate(title: "Unpack & organize", description: "Settle into new home", recurring: .oneTime),
                TodoTemplate(title: "Meet the neighbors", description: "Build community", recurring: .oneTime)
            ]
        )
    ]
}
