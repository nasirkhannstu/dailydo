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

    var galleryTitle: String {
        switch type {
        case .habit:
            return "Healthy Habits to Build"
        case .plan:
            return "Goals & Plans to Achieve"
        case .list:
            return "Lists to Stay Organized"
        }
    }

    var gallerySubtitle: String {
        switch type {
        case .habit:
            return "Start building better daily routines"
        case .plan:
            return "Achieve your goals step by step"
        case .list:
            return "Keep everything organized & on track"
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
                        // ASO-optimized header with descriptive text
                        VStack(alignment: .leading, spacing: 8) {
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

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(galleryTitle)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.primary)

                                    Text(gallerySubtitle)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }

                            // Template count badge
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.green)

                                Text("\(templates.count) templates ready to use")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.green.opacity(0.1))
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 12)

                        // Template cards - 2-column grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
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
