//
//  ListsView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subtype.sortOrder) private var allSubtypes: [Subtype]

    private var lists: [Subtype] {
        allSubtypes.filter { $0.type == .list }
    }

    @State private var showingAddList = false
    @State private var newListName = ""

    var body: some View {
        NavigationStack {
            Group {
                if lists.isEmpty {
                    ContentUnavailableView(
                        "No Lists Yet",
                        systemImage: "list.bullet.circle",
                        description: Text("Create your first list to get started")
                    )
                } else {
                    List {
                        ForEach(lists) { list in
                            NavigationLink(destination: SubtypeDetailView(subtype: list)) {
                                HStack {
                                    Image(systemName: list.icon)
                                        .foregroundStyle(.orange)
                                    VStack(alignment: .leading) {
                                        Text(list.name)
                                            .font(.headline)
                                        Text("\(list.incompleteTodosCount) active")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if list.completionPercentage > 0 {
                                        Text("\(Int(list.completionPercentage))%")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteLists)
                    }
                }
            }
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddList = true
                    } label: {
                        Label("Add List", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddList) {
                NavigationStack {
                    Form {
                        TextField("List Name", text: $newListName)
                    }
                    .navigationTitle("New List")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddList = false
                                newListName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addList()
                            }
                            .disabled(newListName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }

    private func addList() {
        let newList = Subtype(
            name: newListName,
            type: .list,
            sortOrder: lists.count
        )
        modelContext.insert(newList)
        showingAddList = false
        newListName = ""
    }

    private func deleteLists(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(lists[index])
        }
    }
}

#Preview {
    ListsView()
        .modelContainer(for: [Subtype.self, TodoItem.self])
}
