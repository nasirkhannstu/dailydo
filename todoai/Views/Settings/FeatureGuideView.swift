//
//  FeatureGuideView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/17/24.
//

import SwiftUI

struct FeatureGuideView: View {
    @State private var expandedSections: Set<FeatureSection> = []

    var body: some View {
        List {
            // Quick Start
            Section {
                FeatureCard(
                    icon: "hand.wave.fill",
                    iconColor: .orange,
                    title: "Welcome to DailyDo",
                    description: "Organize your life with Habits, Plans, and Lists. Use priorities, recurring tasks, and smart features to stay on track."
                )
            }
            .listRowBackground(Color.orange.opacity(0.1))
            .listRowSeparator(.hidden)

            // Understanding Types
            Section("Understanding Types") {
                ExpandableFeatureCard(
                    icon: "repeat.circle.fill",
                    iconColor: .green,
                    title: "Habits",
                    subtitle: "Daily routines & recurring activities",
                    section: .habits,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What are Habits?",
                            description: "Recurring activities you do regularly to build routines and track progress."
                        )

                        FeatureDetail(
                            title: "Examples",
                            description: "• Morning meditation\n• Drink 8 glasses of water\n• Daily exercise\n• Take vitamins\n• Read 30 minutes"
                        )

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Tap Habits tab → + button\n2. Choose template or create custom\n3. Set as Daily, Weekly, or Monthly\n4. Complete each occurrence to build streaks"
                        )
                    }
                }

                ExpandableFeatureCard(
                    icon: "flag.fill",
                    iconColor: .blue,
                    title: "Plans",
                    subtitle: "Projects with goals & deadlines",
                    section: .plans,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What are Plans?",
                            description: "Projects with specific goals, multiple tasks, and timelines."
                        )

                        FeatureDetail(
                            title: "Examples",
                            description: "• Work project deliverables\n• Study & learning plan\n• Home improvement project\n• Event planning\n• Career development goals"
                        )

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Tap Plans tab → + button\n2. Add tasks with due dates and times\n3. Set priorities (High/Medium/Low)\n4. Use Focus Mode for deep work\n5. Track progress in Calendar view"
                        )
                    }
                }

                ExpandableFeatureCard(
                    icon: "list.bullet.circle.fill",
                    iconColor: .orange,
                    title: "Lists",
                    subtitle: "Collections of one-time tasks",
                    section: .lists,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What are Lists?",
                            description: "Collections of related one-time tasks that belong together."
                        )

                        FeatureDetail(
                            title: "Examples",
                            description: "• Grocery shopping list\n• Packing list for travel\n• Books to read\n• Cleaning checklist\n• Meal planning ideas"
                        )

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Tap Lists tab → + button\n2. Add items to your list\n3. Check off as you complete\n4. Archive or delete when done"
                        )
                    }
                }
            }

            // Priority System
            Section("Priority System") {
                ExpandableFeatureCard(
                    icon: "exclamationmark.circle.fill",
                    iconColor: .red,
                    title: "4-Level Priority",
                    subtitle: "Focus on what matters most",
                    section: .priority,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What is Priority?",
                            description: "Priority helps you focus on urgent and important tasks. Every task can have one of 4 levels."
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            PriorityRow(color: .red, label: "High", description: "Urgent & important (deadlines, critical)")
                            PriorityRow(color: .orange, label: "Medium", description: "Important but not urgent (this week)")
                            PriorityRow(color: .green, label: "Low", description: "Nice to have (when you have time)")
                            PriorityRow(color: .gray, label: "None", description: "No specific urgency")
                        }
                        .padding(.vertical, 4)

                        FeatureDetail(
                            title: "How to Set Priority",
                            description: "1. Open any todo\n2. Tap priority button\n3. Choose High, Medium, Low, or None\n4. Priority color shows in Calendar view"
                        )

                        FeatureDetail(
                            title: "How to Filter",
                            description: "Calendar view → Tap priority filter buttons at top → See only tasks of that priority"
                        )
                    }
                }
            }

            // Recurring Tasks
            Section("Recurring Tasks") {
                ExpandableFeatureCard(
                    icon: "arrow.clockwise.circle.fill",
                    iconColor: .purple,
                    title: "Repeat Tasks",
                    subtitle: "Daily, Weekly, Monthly, Yearly",
                    section: .recurring,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What is Recurring?",
                            description: "Tasks that automatically repeat on a schedule. Perfect for habits and regular activities."
                        )

                        VStack(alignment: .leading, spacing: 6) {
                            RecurringTypeRow(icon: "sun.max.fill", label: "Daily", example: "Every day (vitamins, exercise)")
                            RecurringTypeRow(icon: "calendar.badge.clock", label: "Weekly", example: "Every week (team meeting)")
                            RecurringTypeRow(icon: "calendar", label: "Monthly", example: "Every month (pay rent)")
                            RecurringTypeRow(icon: "gift.fill", label: "Yearly", example: "Every year (birthday)")
                            RecurringTypeRow(icon: "calendar.badge.exclamationmark", label: "Due Date", example: "One-time only (default)")
                        }
                        .padding(.vertical, 4)

                        FeatureDetail(
                            title: "How It Works",
                            description: "1. Set recurring type when creating task\n2. Complete it each day/week/month\n3. Task stays active and tracks completions\n4. View completion history in Calendar\n5. Build streaks by completing regularly"
                        )

                        FeatureDetail(
                            title: "Completion Tracking",
                            description: "✅ Filled circle = completed\n⭕ Empty circle = not done yet\n\nCalendar shows all completion dates to track your progress over time."
                        )
                    }
                }
            }

            // Template Gallery
            Section("Templates") {
                ExpandableFeatureCard(
                    icon: "sparkles",
                    iconColor: .orange,
                    title: "Template Gallery",
                    subtitle: "20+ ready-made templates",
                    section: .templates,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What are Templates?",
                            description: "Pre-made habits, plans, and lists to get started quickly. All templates come with realistic scheduling and can be customized."
                        )

                        FeatureDetail(
                            title: "Template Categories",
                            description: "**Habits (10):** Water Intake, Exercise, Medication, Healthy Breakfast, Skin Care, Dental Care, Feed Pets, Prayer Time, Daily Reading, Steps Goal\n\n**Plans (5):** Work Project, Study & Learning, Home Improvement, Event Planning, Career Development\n\n**Lists (5):** Grocery Shopping, Meal Planning, Reading List, Cleaning Schedule, Packing List"
                        )

                        FeatureDetail(
                            title: "How to Use Templates",
                            description: "1. Go to any tab (Habits, Plans, Lists)\n2. Tap sparkles icon (✨) at top right\n3. Browse available templates\n4. Tap \"Use Template\" to add\n5. Customize after creation"
                        )
                    }
                }
            }

            // Focus Mode
            Section("Advanced Features") {
                ExpandableFeatureCard(
                    icon: "scope",
                    iconColor: .purple,
                    title: "Focus Mode",
                    subtitle: "Distraction-free task completion",
                    section: .focus,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What is Focus Mode?",
                            description: "Distraction-free environment to complete a single task. Great for deep work and avoiding interruptions."
                        )

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Go to Calendar view\n2. Tap \"Focus\" button on any task\n3. Task fills screen with minimal UI\n4. Work on task until complete\n5. Tap checkmark when done"
                        )

                        FeatureDetail(
                            title: "Best For",
                            description: "• Deep work sessions\n• Time-sensitive tasks\n• Avoiding distractions\n• Single-task concentration"
                        )
                    }
                }

                ExpandableFeatureCard(
                    icon: "note.text",
                    iconColor: .blue,
                    title: "Daily Notes",
                    subtitle: "Mood tracking & journaling",
                    section: .dailyNotes,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What are Daily Notes?",
                            description: "Reflect on your day and track your mood with emoji and text notes."
                        )

                        HStack(spacing: 12) {
                            MoodRow(emoji: "😊", label: "Happy")
                            MoodRow(emoji: "😌", label: "Calm")
                            MoodRow(emoji: "😐", label: "Neutral")
                        }
                        HStack(spacing: 12) {
                            MoodRow(emoji: "😔", label: "Sad")
                            MoodRow(emoji: "😫", label: "Stressed")
                            MoodRow(emoji: "😤", label: "Angry")
                        }

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Go to Calendar view\n2. Tap \"Daily Note\" button at bottom\n3. Choose your mood emoji\n4. Write optional text notes\n5. Saves automatically"
                        )

                        FeatureDetail(
                            title: "View Past Notes",
                            description: "Select any date in Calendar → Tap \"Daily Note\" → See that day's mood and notes"
                        )
                    }
                }
            }

            // Calendar View
            Section("Calendar View") {
                ExpandableFeatureCard(
                    icon: "calendar.circle.fill",
                    iconColor: .blue,
                    title: "Unified Calendar",
                    subtitle: "All tasks in one timeline",
                    section: .calendar,
                    expandedSections: $expandedSections
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureDetail(
                            title: "What is Calendar View?",
                            description: "See all your habits, plans, and lists together in one unified timeline. The main hub for your daily tasks."
                        )

                        FeatureDetail(
                            title: "Features",
                            description: "• Color-coded priorities (🔴🟠🟢⚪)\n• Filter by priority level\n• Week navigation (swipe or arrows)\n• Quick jump to today\n• Shows all task types together"
                        )

                        FeatureDetail(
                            title: "How to Use",
                            description: "1. Tap Calendar tab\n2. Scroll to see different weeks\n3. Tap priority filters to focus\n4. Tap any task to view details\n5. Tap circle to mark complete"
                        )

                        FeatureDetail(
                            title: "Navigation Tips",
                            description: "• Tap date at top → Jump to specific month/year\n• Swipe week left/right → Navigate weeks\n• Tap \"Today\" button → Jump to current date\n• Use priority filters → Focus on urgent tasks"
                        )
                    }
                }
            }

            // Tips & Tricks
            Section("Tips & Tricks") {
                FeatureCard(
                    icon: "lightbulb.fill",
                    iconColor: .yellow,
                    title: "Pro Tips",
                    description: "• Use templates to get started quickly\n• Set priorities to focus on urgent tasks\n• Enable calendar view for tasks you want to see\n• Use Focus Mode for important work\n• Track daily moods to see patterns\n• Build habits with recurring tasks\n• Organize with subtasks for big projects"
                )
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle("Features Guide")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Feature Section Enum

enum FeatureSection: Hashable {
    case habits
    case plans
    case lists
    case priority
    case recurring
    case templates
    case focus
    case dailyNotes
    case calendar
}

// MARK: - Supporting Views

struct FeatureCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ExpandableFeatureCard<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let section: FeatureSection
    @Binding var expandedSections: Set<FeatureSection>
    @ViewBuilder let content: Content

    private var isExpanded: Bool {
        expandedSections.contains(section)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation {
                    if isExpanded {
                        expandedSections.remove(section)
                    } else {
                        expandedSections.insert(section)
                    }
                }
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(iconColor)
                        .frame(width: 32, height: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)

            if isExpanded {
                content
                    .padding(.top, 8)
                    .padding(.leading, 44)
            }
        }
    }
}

struct FeatureDetail: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PriorityRow: View {
    let color: Color
    let label: String
    let description: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct RecurringTypeRow: View {
    let icon: String
    let label: String
    let example: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.purple)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text(example)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct MoodRow: View {
    let emoji: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.title2)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        FeatureGuideView()
    }
}
