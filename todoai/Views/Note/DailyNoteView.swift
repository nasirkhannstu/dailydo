//
//  DailyNoteView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/11/25.
//

import SwiftUI
import SwiftData

struct DailyNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var note: DailyNote

    @State private var saveWorkItem: DispatchWorkItem?
    @State private var showingDeleteConfirmation = false
    @State private var initialMood: NoteMood = .neutral // Track original mood
    @State private var userSelectedMood = false // Track if user clicked a mood button
    @FocusState private var isEditorFocused: Bool

    private var hasContent: Bool {
        userSelectedMood || !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var checkmarkColor: Color {
        (userSelectedMood || !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? note.noteMood.color : .white
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Row: Delete, Date, Done
                HStack(spacing: 16) {
                    if hasContent {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.subheadline)
                                .foregroundStyle(note.noteMood.color)
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Delete note")
                        .accessibilityHint("Deletes this daily note")
                    } else {
                        // Invisible spacer to balance layout
                        Color.clear
                            .frame(width: 36, height: 36)
                    }

                    Spacer()

                    Text(dateFormatter.string(from: note.date))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Spacer()

                    Button {
                        finalSave()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(checkmarkColor)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Save and close")
                    .accessibilityHint("Saves your mood and returns to calendar")
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [note.noteMood.color, note.noteMood.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        // Glass effect overlay
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .blendMode(.overlay)
                    }
                )

                // How was your day + Mood Picker
                VStack(spacing: 12) {
                    Text("How was your day?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.9))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(NoteMood.allCases, id: \.self) { mood in
                                MoodButton(
                                    mood: mood,
                                    isSelected: note.noteMood == mood
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        note.noteMood = mood
                                        userSelectedMood = true // Mark that user clicked a mood
                                        scheduleAutoSave()
                                    }
                                }
                                .accessibilityLabel(mood.rawValue)
                                .accessibilityHint(mood.description)
                                .accessibilityAddTraits(note.noteMood == mood ? [.isSelected] : [])
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                    .background(Color.clear)
                }
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [note.noteMood.color, note.noteMood.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        // Glass effect overlay
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .blendMode(.overlay)
                    }
                )

                // Prompt Text
                Text("Write what's special today (optional)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .background(
                        ZStack {
                            LinearGradient(
                                colors: [note.noteMood.color, note.noteMood.color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )

                            // Glass effect overlay
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .blendMode(.overlay)
                        }
                    )

                // Text Editor
                TextEditor(text: $note.content)
                    .font(.body)
                    .focused($isEditorFocused)
                    .scrollContentBackground(.hidden)
                    .background(note.noteMood.color.opacity(0.05))
                    .onChange(of: note.content) { _, _ in
                        scheduleAutoSave()
                    }
                    .padding(.horizontal, 8)
                    .accessibilityLabel("Daily note content")
                    .accessibilityHint("Write about your day here")
            }
            .background(note.noteMood.color.opacity(0.05))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .confirmationDialog("Delete this note?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(note)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
            .onAppear {
                // Initialize: if note already has a mood other than default OR has text content
                initialMood = note.noteMood
                let hasText = !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                userSelectedMood = (note.noteMood != .neutral) || hasText
            }
            .onDisappear {
                finalSave()
            }
        }
    }

    // MARK: - Auto-save Logic

    private func scheduleAutoSave() {
        // Cancel any pending save
        saveWorkItem?.cancel()

        // Create new save task with 1 second delay
        let task = DispatchWorkItem {
            note.lastModifiedDate = Date()
            try? modelContext.save()
        }
        saveWorkItem = task

        // Schedule the save
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: task)
    }

    private func finalSave() {
        // Cancel pending auto-save
        saveWorkItem?.cancel()

        // Check if user has entered anything (mood or text)
        let hasText = !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        // Final save or delete if no content
        if !userSelectedMood && !hasText {
            // Delete notes where user hasn't done anything
            modelContext.delete(note)
        } else {
            // Save note with updated timestamp
            note.lastModifiedDate = Date()
            try? modelContext.save()
        }
    }
}

// MARK: - Mood Button Component

struct MoodButton: View {
    let mood: NoteMood
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Text(mood.emoji)
                        .font(.system(size: 28))
                }
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: isSelected ? 3 : 0)
                        .frame(width: 44, height: 44)
                )

                Text(mood.rawValue)
                    .font(.system(size: 10))
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyNote.self, configurations: config)

    let note = DailyNote(date: Date(), content: "This is a sample daily note.\n\nIt can contain multiple lines of text.")
    container.mainContext.insert(note)

    return DailyNoteView(note: note)
        .modelContainer(container)
}
