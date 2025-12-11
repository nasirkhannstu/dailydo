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
    @State private var newListShowInCalendar = false
    @State private var newListRemindersEnabled = false
    @FocusState private var isListNameFocused: Bool

    // Search states
    @State private var searchText = ""
    @State private var isSearching = false

    var filteredLists: [Subtype] {
        guard !searchText.isEmpty else { return lists }
        return lists.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

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
                    VStack(spacing: 0) {
                        // Title and Search in one row
                        HStack {
                            Text("Lists")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Spacer()

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
                                    .foregroundStyle(isSearching ? .red : .orange)
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
                                TextField("Search lists...", text: $searchText)
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

                        if filteredLists.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView(
                                "No Results",
                                systemImage: "magnifyingglass",
                                description: Text("No lists match '\(searchText)'")
                            )
                            .padding(.top, 60)
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(filteredLists) { list in
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
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddList = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isListNameFocused = true
                    }
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
                VStack(spacing: 20) {
                    // Name field
                    TextField("List Name", text: $newListName)
                        .font(.title3)
                        .focused($isListNameFocused)
                        .padding()
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Toggle buttons and Add button
                    HStack(spacing: 12) {
                        // Calendar toggle button
                        Button {
                            newListShowInCalendar.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newListShowInCalendar ? "calendar.badge.checkmark" : "calendar")
                                    .font(.subheadline)
                                Text("Calendar")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newListShowInCalendar ? .white : .orange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newListShowInCalendar ? Color.orange : Color.orange.opacity(0.1))
                            )
                        }

                        // Reminder toggle button
                        Button {
                            newListRemindersEnabled.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: newListRemindersEnabled ? "bell.badge.fill" : "bell")
                                    .font(.subheadline)
                                Text("Reminder")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(newListRemindersEnabled ? .white : .orange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(newListRemindersEnabled ? Color.orange : Color.orange.opacity(0.1))
                            )
                        }

                        Spacer()

                        // Add button
                        Button {
                            addList()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(newListName.isEmpty ? Color.gray : Color.orange)
                                )
                        }
                        .disabled(newListName.isEmpty)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private func addList() {
        let newList = Subtype(
            name: newListName,
            type: .list,
            showInCalendar: newListShowInCalendar,
            notificationEnabled: newListRemindersEnabled,
            sortOrder: lists.count
        )
        modelContext.insert(newList)
        resetAddListForm()
    }

    private func resetAddListForm() {
        showingAddList = false
        newListName = ""
        newListShowInCalendar = false
        newListRemindersEnabled = false
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
