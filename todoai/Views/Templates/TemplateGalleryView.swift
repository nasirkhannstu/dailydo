//
//  TemplateGalleryView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/13/24.
//

import SwiftUI
import SwiftData

struct TemplateGalleryView: View {
    let type: SubtypeType
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var templates: [SubtypeTemplate] {
        switch type {
        case .habit:
            return SubtypeTemplate.habitTemplates
        case .plan:
            return SubtypeTemplate.planTemplates
        case .list:
            return SubtypeTemplate.listTemplates
        }
    }

    var navigationTitle: String {
        switch type {
        case .habit:
            return "Habit Templates"
        case .plan:
            return "Plan Templates"
        case .list:
            return "List Templates"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark neutral background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        // Compact colorful header
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 50, height: 50)

                                Image(systemName: "sparkles")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Template Gallery")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.primary)

                                Text("\(templates.count) ready-made templates")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 4)

                        // Template cards - compact spacing
                        LazyVStack(spacing: 12) {
                            ForEach(templates) { template in
                                NavigationLink(destination: TemplateDetailView(template: template)) {
                                    TemplateCard(
                                        template: template,
                                        onAdd: {
                                            addTemplate(template)
                                        },
                                        onTap: {}
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)

                        // Footer spacing
                        Color.clear.frame(height: 12)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                }
            }
        }
    }

    private func addTemplate(_ template: SubtypeTemplate) {
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
}

#Preview {
    TemplateGalleryView(type: .habit)
        .modelContainer(for: [Subtype.self, TodoItem.self], inMemory: true)
}
