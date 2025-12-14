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
    @State private var newPlanDescription = ""
    @State private var newPlanShowInCalendar = false
    @State private var newPlanRemindersEnabled = false
    @State private var selectedPlan: Subtype?
    @State private var planToDelete: Subtype?
    @State private var showingDeleteAlert = false
    @State private var showingTemplateGallery = false
    @FocusState private var isPlanNameFocused: Bool

    // Search states
    @State private var searchText = ""
    @State private var isSearching = false

    var filteredPlans: [Subtype] {
        guard !searchText.isEmpty else { return plans }
        return plans.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                        // Title and Search in one row
                        HStack {
                            Text("Plans")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Spacer()

                            Button {
                                showingTemplateGallery = true
                            } label: {
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundStyle(.orange)
                            }

                            Button {
                                withAnimation {
                                    isSearching.toggle()
                                    if !isSearching {
                                        searchText = ""
                                    }
                                }
                            } label: {
                                Image(systemName: isSearching ? "xmark.circle.fill" : "magnifyingglass")
                                    .font(.title2)
                                    .foregroundStyle(isSearching ? .red : .blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        .background(Color(.systemGray6))

                        // Search Bar (when searching)
                        if isSearching {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                TextField("Search plans...", text: $searchText)
                                    .textFieldStyle(.plain)
                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .background(Color(.systemGray6))
                        }

                if plans.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.checkmark",
                        title: "No Plans Yet",
                        message: "Start planning your projects and goals"
                    ) {
                        VStack(spacing: 12) {
                            Button {
                                showingTemplateGallery = true
                            } label: {
                                Label("Browse Templates", systemImage: "sparkles")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                showingAddPlan = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    isPlanNameFocused = true
                                }
                            } label: {
                                Label("Create Custom", systemImage: "plus")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else if filteredPlans.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView(
                                "No Results",
                                systemImage: "magnifyingglass",
                                description: Text("No plans match '\(searchText)'")
                            )
                        } else {
                            List {
                                ForEach(filteredPlans) { plan in
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
            .navigationBarHidden(true)
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
                                .fill(Color.blue.gradient)
                        )
                        .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingAddPlan) {
                VStack(spacing: 16) {
                    // Name field
                    TextField("Plan Name", text: $newPlanName)
                        .font(.title3)
                        .focused($isPlanNameFocused)
                        .padding()
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Description field
                    TextField("Description (optional)", text: $newPlanDescription)
                        .font(.body)
                        .padding()
                        .padding(.horizontal)

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
                            .foregroundStyle(newPlanShowInCalendar ? .white : .blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newPlanShowInCalendar ? Color.blue : Color.blue.opacity(0.1))
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
                            .foregroundStyle(newPlanRemindersEnabled ? .white : .blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newPlanRemindersEnabled ? Color.blue : Color.blue.opacity(0.1))
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
                                        .fill(newPlanName.isEmpty ? Color.gray : Color.blue)
                                )
                        }
                        .disabled(newPlanName.isEmpty)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .presentationDetents([.height(280)])
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
            .sheet(isPresented: $showingTemplateGallery) {
                TemplateGalleryView(type: .plan)
            }
        }
    }

    private func addPlan() {
        let newPlan = Subtype(
            name: newPlanName,
            itemDescription: newPlanDescription.isEmpty ? nil : newPlanDescription,
            type: .plan,
            showInCalendar: newPlanShowInCalendar,
            notificationEnabled: newPlanRemindersEnabled,
            sortOrder: plans.count
        )
        modelContext.insert(newPlan)

        // Navigate to the newly created plan after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            selectedPlan = newPlan
        }

        resetAddPlanForm()
    }

    private func resetAddPlanForm() {
        showingAddPlan = false
        newPlanName = ""
        newPlanDescription = ""
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
                    .foregroundStyle(.blue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(plan.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)

                    if let description = plan.itemDescription, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

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
                        .fill(Color.blue.opacity(0.1))
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
                        .fill(Color.green.opacity(0.1))
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
