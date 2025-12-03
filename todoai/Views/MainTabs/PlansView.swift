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
                            NavigationLink(destination: SubtypeDetailView(subtype: plan)) {
                                HStack {
                                    Image(systemName: plan.icon)
                                        .foregroundStyle(.green)
                                    VStack(alignment: .leading) {
                                        Text(plan.name)
                                            .font(.headline)
                                        Text("\(plan.incompleteTodosCount) active")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if plan.completionPercentage > 0 {
                                        Text("\(Int(plan.completionPercentage))%")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deletePlans)
                    }
                }
            }
            .navigationTitle("Plans")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddPlan = true
                    } label: {
                        Label("Add Plan", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlan) {
                NavigationStack {
                    Form {
                        TextField("Plan Name", text: $newPlanName)
                    }
                    .navigationTitle("New Plan")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddPlan = false
                                newPlanName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addPlan()
                            }
                            .disabled(newPlanName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }

    private func addPlan() {
        let newPlan = Subtype(
            name: newPlanName,
            type: .plan,
            sortOrder: plans.count
        )
        modelContext.insert(newPlan)
        showingAddPlan = false
        newPlanName = ""
    }

    private func deletePlans(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(plans[index])
        }
    }
}

#Preview {
    PlansView()
        .modelContainer(for: [Subtype.self, TodoItem.self])
}
