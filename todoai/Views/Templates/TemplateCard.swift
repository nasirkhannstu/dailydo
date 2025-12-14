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
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // Compact colorful header - vertical layout
                VStack(spacing: 12) {
                    // Icon only
                    HStack {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.25))
                                .frame(width: 50, height: 50)

                            Image(systemName: template.icon)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }

                        Spacer()
                    }

                    // Title
                    Text(template.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
                .padding(14)
                .background(
                    LinearGradient(
                        colors: [
                            vibrantHeaderColor,
                            vibrantHeaderColor.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

                // Soft pastel content area with task previews
                VStack(alignment: .leading, spacing: 8) {
                    // Show 2-3 tasks
                    ForEach(template.todos.prefix(2), id: \.title) { todo in
                        HStack(spacing: 8) {
                            // Colored checkmark circle
                            ZStack {
                                Circle()
                                    .fill(vibrantHeaderColor.opacity(0.3))
                                    .frame(width: 20, height: 20)

                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(vibrantHeaderColor)
                            }

                            // Task title
                            Text(todo.title)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }

                    // More tasks indicator
                    if template.todos.count > 2 {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(vibrantHeaderColor.opacity(0.2))
                                    .frame(width: 20, height: 20)

                                Image(systemName: "ellipsis")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundStyle(vibrantHeaderColor.opacity(0.7))
                            }

                            Text("+\(template.todos.count - 2) more")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(softBodyColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: templateColor.opacity(0.3), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 1.5)
            )

            // Floating add button at the border between header and body - right edge
            Button(action: {
                onAdd()
            }) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 32, height: 32)
                        .shadow(color: vibrantHeaderColor.opacity(0.4), radius: 6, x: 0, y: 3)

                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(vibrantHeaderColor)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(TapGesture().onEnded {
                // Prevents NavigationLink from triggering
            })
            .offset(x: 0, y: 90) // No margin, centered at header/body border
        }
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
