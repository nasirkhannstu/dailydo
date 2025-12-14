//
//  TemplateCard.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import SwiftUI

struct TemplateCard: View {
    let template: SubtypeTemplate
    let onAdd: () -> Void
    let onTap: () -> Void

    private var templateColor: Color {
        Color(template.color)
    }

    // Vibrant saturated header colors
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

    // Soft pastel body colors - lighter shades
    private var softBodyColor: Color {
        switch template.color.lowercased() {
        case "blue": return Color(red: 0.85, green: 0.92, blue: 1.0)
        case "red": return Color(red: 1.0, green: 0.85, blue: 0.88)
        case "pink": return Color(red: 1.0, green: 0.88, blue: 0.95)
        case "orange": return Color(red: 1.0, green: 0.92, blue: 0.85)
        case "purple": return Color(red: 0.92, green: 0.88, blue: 1.0)
        case "cyan": return Color(red: 0.85, green: 0.95, blue: 1.0)
        case "brown": return Color(red: 0.95, green: 0.90, blue: 0.85)
        case "teal": return Color(red: 0.85, green: 0.95, blue: 0.93)
        case "indigo": return Color(red: 0.88, green: 0.90, blue: 1.0)
        case "green": return Color(red: 0.85, green: 0.95, blue: 0.88)
        default: return templateColor.opacity(0.2)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Colorful header with icon and gradient
            ZStack {
                // VIBRANT COLORFUL gradient background
                LinearGradient(
                    colors: [
                        vibrantHeaderColor,
                        vibrantHeaderColor.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative elements
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 120, height: 120)
                    .offset(x: -70, y: -25)

                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 90, height: 90)
                    .offset(x: 80, y: 15)

                // Content
                HStack(spacing: 14) {
                    // Large icon
                    Image(systemName: template.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.2))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                    // Title and description
                    VStack(alignment: .leading, spacing: 5) {
                        Text(template.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text(template.shortDescription)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.95))
                            .lineLimit(2)
                    }

                    Spacer()

                    // Add button - stops event propagation to NavigationLink
                    Button(action: {
                        onAdd()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.3))
                                .frame(width: 50, height: 50)

                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        // Prevents NavigationLink from triggering
                    })
                }
                .padding(18)
            }
            .frame(height: 120)

                // Soft pastel content area with dark text
                VStack(alignment: .leading, spacing: 14) {
                    // Task preview list
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(template.todos.prefix(3), id: \.title) { todo in
                            HStack(spacing: 12) {
                                // Colored checkmark circle
                                ZStack {
                                    Circle()
                                        .fill(vibrantHeaderColor.opacity(0.3))
                                        .frame(width: 28, height: 28)

                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(vibrantHeaderColor)
                                }

                                // Task title
                                Text(todo.title)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                Spacer()
                            }
                        }

                        // More tasks indicator
                        if template.todos.count > 3 {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(vibrantHeaderColor.opacity(0.2))
                                        .frame(width: 28, height: 28)

                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(vibrantHeaderColor.opacity(0.7))
                                }

                                Text("+\(template.todos.count - 3) more tasks")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(18)
                .background(softBodyColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: templateColor.opacity(0.4), radius: 15, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1.5)
        )
    }
}

#Preview {
    TemplateCard(
        template: SubtypeTemplate.habitTemplates[0],
        onAdd: {},
        onTap: {}
    )
    .padding()
}
