//
//  PlansView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct PlansView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subtype.sortOrder) private var allSubtypes: [Subtype]

    private var plans: [Subtype] {
        allSubtypes.filter { $0.type == .plan }
    }

    @State private var showingAddPlan = false
    @State private var newPlanName = ""
    @State private var newPlanShowInCalendar = false
    @State private var newPlanRemindersEnabled = false
    @State private var selectedPlan: Subtype?
    @State private var planToDelete: Subtype?
    @State private var showingDeleteAlert = false
    @FocusState private var isPlanNameFocused: Bool

    var body: some View {
        NavigationStack {
            Group {
                if plans.isEmpty {
                    ContentUnavailableView(
                        "No Plans Yet",
                        systemImage: "calendar.badge.checkmark",
                        description: Text("Create your first plan to get started")
                    )
                } else {
                    List {
                        ForEach(plans) { plan in
                            Button {
                                selectedPlan = plan
                            } label: {
                                PlanCardRow(plan: plan)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete(perform: deletePlans)
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGray6))
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationDestination(item: $selectedPlan) { plan in
                SubtypeDetailView(subtype: plan)
            }
            .navigationTitle("Plans")
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddPlan = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isPlanNameFocused = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color.green.gradient)
                        )
                        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingAddPlan) {
                VStack(spacing: 20) {
                    // Name field
                    TextField("Plan Name", text: $newPlanName)
                        .font(.title3)
                        .focused($isPlanNameFocused)
                        .padding()
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Toggle buttons and Add button
                    HStack(spacing: 12) {
                        // Calendar toggle button
                        Button {
                            newPlanShowInCalendar.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newPlanShowInCalendar ? "calendar.badge.checkmark" : "calendar")
                                    .font(.subheadline)
                                Text("Calendar")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newPlanShowInCalendar ? .white : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newPlanShowInCalendar ? Color.green : Color.green.opacity(0.1))
                            )
                        }

                        // Reminder toggle button
                        Button {
                            newPlanRemindersEnabled.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newPlanRemindersEnabled ? "bell.badge.fill" : "bell")
                                    .font(.subheadline)
                                Text("Reminder")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newPlanRemindersEnabled ? .white : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newPlanRemindersEnabled ? Color.green : Color.green.opacity(0.1))
                            )
                        }

                        Spacer()

                        // Add button
                        Button {
                            addPlan()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(newPlanName.isEmpty ? Color.gray : Color.green)
                                )
                        }
                        .disabled(newPlanName.isEmpty)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
            .alert("Delete Plan?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    planToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let plan = planToDelete {
                        modelContext.delete(plan)
                        planToDelete = nil
                    }
                }
            } message: {
                if let plan = planToDelete {
                    Text("This will permanently delete this plan and all \(plan.todos.count) task\(plan.todos.count == 1 ? "" : "s"). This action cannot be undone.")
                }
            }
        }
    }

    private func addPlan() {
        let newPlan = Subtype(
            name: newPlanName,
            type: .plan,
            showInCalendar: newPlanShowInCalendar,
            notificationEnabled: newPlanRemindersEnabled,
            sortOrder: plans.count
        )
        modelContext.insert(newPlan)
        resetAddPlanForm()
    }

    private func resetAddPlanForm() {
        showingAddPlan = false
        newPlanName = ""
        newPlanShowInCalendar = false
        newPlanRemindersEnabled = false
    }

    private func deletePlans(at offsets: IndexSet) {
        if let index = offsets.first {
            planToDelete = plans[index]
            showingDeleteAlert = true
        }
    }
}

// MARK: - Plan Card Row

struct PlanCardRow: View {
    let plan: Subtype

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon, title and chevron
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: plan.icon)
                    .font(.title2)
                    .foregroundStyle(.green)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.green.opacity(0.1))
                    )

                Text(plan.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Info boxes - full width
            HStack(spacing: 8) {
                // Percent completed
                VStack(spacing: 4) {
                    Text("\(Int(plan.completionPercentage))%")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text("Complete")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                )

                // Total todos
                VStack(spacing: 4) {
                    Text("\(plan.todos.count)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text("Total")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )

                // Remaining todos
                VStack(spacing: 4) {
                    Text("\(plan.incompleteTodosCount)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text("Remaining")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.1))
                )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    // Create sample data for preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Subtype.self, TodoItem.self,
        configurations: config
    )

    // Add sample plans
    let plan1 = Subtype(name: "IELTS Study Plan", type: .plan, icon: "book.fill")
    let plan2 = Subtype(name: "Fitness Plan", type: .plan, icon: "figure.run")
    let plan3 = Subtype(name: "Project Deadline", type: .plan, icon: "calendar")

    container.mainContext.insert(plan1)
    container.mainContext.insert(plan2)
    container.mainContext.insert(plan3)

    // Add sample todos to first plan
    let todo1 = TodoItem(title: "Study grammar", subtype: plan1)
    let todo2 = TodoItem(title: "Practice listening", completed: true, subtype: plan1)

    container.mainContext.insert(todo1)
    container.mainContext.insert(todo2)

    return PlansView()
        .modelContainer(container)
}
