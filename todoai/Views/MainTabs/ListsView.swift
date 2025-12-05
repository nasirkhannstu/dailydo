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

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

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
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(lists) { list in
                                NavigationLink(destination: SubtypeDetailView(subtype: list)) {
                                    ListCardView(list: list)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemGray6))
                }
            }
            .navigationTitle("Lists")
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddList = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color.orange.gradient)
                        )
                        .shadow(color: Color.orange.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
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

// MARK: - List Card View

struct ListCardView: View {
    let list: Subtype

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: list.icon)
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                    )

                Spacer()

                if list.completionPercentage > 0 {
                    Text("\(Int(list.completionPercentage))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.1))
                        )
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text("\(list.incompleteTodosCount) active")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ListsView()
        .modelContainer(for: [Subtype.self, TodoItem.self])
}
