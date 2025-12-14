//
//  TemplateDetailView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/14/24.
//

import SwiftUI
import SwiftData

struct TemplateDetailView: View {
    let template: SubtypeTemplate
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private var templateColor: Color {
        Color(template.color)
    }

    private var vibrantHeaderColor: Color {
        switch template.color.lowercased() {
        case "blue": return Color(red: 0.2, green: 0.5, blue: 1.0)
        case "red": return Color(red: 1.0, green: 0.2, blue: 0.3)
        case "pink": return Color(red: 1.0, green: 0.3, blue: 0.7)
        case "orange": return Color(red: 1.0, green: 0.5, blue: 0.1)
        case "purple": return Color(red: 0.6, green: 0.3, blue: 1.0)
        case "cyan": return Color(red: 0.2, green: 0.8, blue: 1.0)
        case "brown": return Color(red: 0.7, green: 0.4, blue: 0.2)
        case "teal": return Color(red: 0.2, green: 0.8, blue: 0.7)
        case "indigo": return Color(red: 0.3, green: 0.4, blue: 1.0)
        case "green": return Color(red: 0.2, green: 0.8, blue: 0.3)
        default: return templateColor
        }
    }

    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Hero Header with gradient
                    ZStack {
                        // Gradient background
                        LinearGradient(
                            colors: [
                                vibrantHeaderColor,
                                vibrantHeaderColor.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        // Decorative circles
                        Circle()
                            .fill(.white.opacity(0.15))
                            .frame(width: 200, height: 200)
                            .offset(x: -100, y: -50)

                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 150, height: 150)
                            .offset(x: 120, y: 40)

                        // Content
                        VStack(spacing: 16) {
                            // Large icon
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 120, height: 120)

                                Image(systemName: template.icon)
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)

                            // Title
                            Text(template.name)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            // Description
                            Text(template.shortDescription)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            // Task count
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                Text("\(template.todos.count) tasks included")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.25))
                            )
                        }
                        .padding(.vertical, 40)
                    }

                    // Tasks list
                    VStack(spacing: 16) {
                        // Section header
                        HStack {
                            Text("What's Included")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.primary)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 8)

                        // All tasks
                        VStack(spacing: 12) {
                            ForEach(Array(template.todos.enumerated()), id: \.element.title) { index, todo in
                                HStack(spacing: 14) {
                                    // Number badge
                                    ZStack {
                                        Circle()
                                            .fill(vibrantHeaderColor.opacity(0.15))
                                            .frame(width: 36, height: 36)

                                        Text("\(index + 1)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(vibrantHeaderColor)
                                    }

                                    // Task info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(todo.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(.primary)

                                        if !todo.description.isEmpty {
                                            Text(todo.description)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.secondary)
                                        }

                                        // Recurring badge
                                        HStack(spacing: 4) {
                                            Image(systemName: recurringIcon(for: todo.recurring))
                                                .font(.system(size: 11))
                                            Text(recurringText(for: todo.recurring))
                                                .font(.system(size: 12, weight: .medium))
                                        }
                                        .foregroundStyle(vibrantHeaderColor)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(vibrantHeaderColor.opacity(0.1))
                                        )
                                    }

                                    Spacer()
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Disclaimer card
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(vibrantHeaderColor)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Important Notice")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.primary)

                                Text("This template is for informational purposes only. Consult professionals for medical, health, or specialized advice. Tasks and schedules are suggestions based on general guidelines.")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(vibrantHeaderColor.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(vibrantHeaderColor.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // Bottom spacing
                        Color.clear.frame(height: 20)
                    }
                }
            }

            // Floating header buttons - always on top
            VStack {
                HStack {
                    // Back button - left
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(vibrantHeaderColor)
                                    .shadow(color: vibrantHeaderColor.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }

                    Spacer()

                    // Add button - right
                    Button(action: {
                        addTemplate()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(vibrantHeaderColor)
                                    .shadow(color: vibrantHeaderColor.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 50)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    private func addTemplate() {
        // Create Subtype from template - calendar disabled by default
        let subtype = Subtype(
            name: template.name,
            type: template.type,
            icon: template.icon,
            showInCalendar: false
        )
        modelContext.insert(subtype)

        // Create all TodoItems from template - calendar disabled by default
        for todoTemplate in template.todos {
            let todo = TodoItem(
                title: todoTemplate.title,
                itemDescription: todoTemplate.description,
                dueDate: Date(),
                showInCalendar: false,
                recurringType: todoTemplate.recurring,
                subtype: subtype
            )
            modelContext.insert(todo)
        }

        // Save to database
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save template: \(error)")
        }
    }

    private func recurringIcon(for type: RecurringType) -> String {
        switch type {
        case .daily: return "repeat.circle.fill"
        case .weekly: return "calendar.circle.fill"
        case .monthly: return "calendar.badge.clock"
        case .yearly: return "calendar"
        default: return "circle"
        }
    }

    private func recurringText(for type: RecurringType) -> String {
        switch type {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .oneTime: return "One-time"
        default: return "Custom"
        }
    }
}

#Preview {
    NavigationStack {
        TemplateDetailView(template: SubtypeTemplate.habitTemplates[0])
            .modelContainer(for: [Subtype.self, TodoItem.self], inMemory: true)
    }
}
