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

        // 5. Packing List
        SubtypeTemplate(
            name: "Packing List",
            icon: "suitcase.fill",
            color: "purple",
            type: .list,
            shortDescription: "Travel prepared",
            todos: [
                TodoTemplate(title: "Phone charger", description: "Don't forget!", recurring: .oneTime),
                TodoTemplate(title: "Toiletries", description: "Toothbrush, shampoo, etc", recurring: .oneTime),
                TodoTemplate(title: "Medications", description: "Prescriptions & vitamins", recurring: .oneTime),
                TodoTemplate(title: "ID/Passport", description: "Essential documents", recurring: .oneTime),
                TodoTemplate(title: "Underwear", description: "Enough for trip + extra", recurring: .oneTime),
                TodoTemplate(title: "Socks", description: "Multiple pairs", recurring: .oneTime),
                TodoTemplate(title: "Shirts", description: "Mix & match", recurring: .oneTime),
                TodoTemplate(title: "Pants/Shorts", description: "Weather appropriate", recurring: .oneTime),
                TodoTemplate(title: "Shoes", description: "Comfortable walking shoes", recurring: .oneTime),
                TodoTemplate(title: "Jacket/Sweater", description: "Layer for weather", recurring: .oneTime),
                TodoTemplate(title: "Books/Entertainment", description: "For travel time", recurring: .oneTime),
                TodoTemplate(title: "Headphones", description: "For flights/trains", recurring: .oneTime),
                TodoTemplate(title: "Snacks", description: "Travel snacks", recurring: .oneTime)
            ]
        )
    ]
}
