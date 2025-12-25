//
//  SettingsView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var notificationsEnabled = true
    @State private var iCloudSyncEnabled = true
    @State private var showCompletedTasks = true
    @State private var autoDeleteCompleted = false
    @State private var showingResetAlert = false

    var currentUser: User? {
        users.first
    }

    var body: some View {
        NavigationStack {
            Form {
                // Notifications Section
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.fill")
                    }

                    if notificationsEnabled {
                        NavigationLink(destination: Text("Notification Settings")) {
                            Label("Notification Preferences", systemImage: "bell.badge")
                        }
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get reminded about your tasks and habits")
                }

                // Data & Sync Section
                Section {
                    Toggle(isOn: $iCloudSyncEnabled) {
                        Label("iCloud Sync", systemImage: "icloud.fill")
                    }

                    NavigationLink(destination: Text("Data Management")) {
                        Label("Manage Data", systemImage: "externaldrive")
                    }
                } header: {
                    Text("Data & Sync")
                } footer: {
                    Text("Sync your tasks across all your devices")
                }

                // Display Preferences Section
                Section {
                    Toggle(isOn: $showCompletedTasks) {
                        Label("Show Completed Tasks", systemImage: "checkmark.circle")
                    }

                    Toggle(isOn: $autoDeleteCompleted) {
                        Label("Auto-delete Old Completed", systemImage: "trash")
                    }
                } header: {
                    Text("Display")
                } footer: {
                    if autoDeleteCompleted {
                        Text("Completed tasks older than 30 days will be automatically deleted")
                    }
                }

                // Language & Region Section
                Section("Language & Region") {
                    NavigationLink(destination: Text("Language Settings")) {
                        HStack {
                            Label("Language", systemImage: "globe")
                            Spacer()
                            Text("English")
                                .foregroundStyle(.secondary)
                        }
                    }

                    NavigationLink(destination: Text("Date Format")) {
                        HStack {
                            Label("Date Format", systemImage: "calendar")
                            Spacer()
                            Text("MM/DD/YYYY")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Advanced Section
                Section("Advanced") {
                    Button {
                        showingResetAlert = true
                    } label: {
                        Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                            .foregroundStyle(.primary)
                    }

                    Button(role: .destructive) {
                        // Clear cache
                    } label: {
                        Label("Clear Cache", systemImage: "trash.circle")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Reset Onboarding", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetOnboarding()
                }
            } message: {
                Text("This will close the app and show the welcome screens again when you reopen it.")
            }
        }
    }

    private func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        if let user = currentUser {
            user.hasCompletedOnboarding = false
        }
        // Force close the app - user will need to reopen to see onboarding
        exit(0)
    }
}

// MARK: - Profile Hero Banner

struct ProfileHeroBanner: View {
    let user: User
    let onEditTap: () -> Void

    var userInitials: String {
        let name = user.name
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if let first = components.first, first.count >= 2 {
            return String(first.prefix(2))
        } else if let first = components.first {
            return String(first.prefix(1))
        }
        return "U"
    }

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 140)

            // Content
            HStack(alignment: .center, spacing: 16) {
                // Avatar circle with initials
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)

                    Text(userInitials.uppercased())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

                // User info
                VStack(alignment: .leading, spacing: 6) {
                    Text(user.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    HStack(spacing: 12) {
                        if let age = user.age {
                            HStack(spacing: 4) {
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                Text("\(age) yrs")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.white.opacity(0.9))
                        }

                        HStack(spacing: 4) {
                            Image(systemName: user.hasPremiumAccess ? "crown.fill" : "sparkles")
                                .font(.caption)
                            Text(user.hasPremiumAccess ? "Premium" : "Free")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.white.opacity(0.9))
                    }
                }

                Spacer()

                // Edit button
                Button {
                    onEditTap()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Profile Reminder Card

struct ProfileReminderCard: View {
    let onCompleteTap: () -> Void

    var body: some View {
        Button {
            onCompleteTap()
        } label: {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.orange)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text("Complete Your Profile")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("Add your name and age")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Profile Editor Sheet

struct ProfileEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    let user: User?

    @State private var userName: String
    @State private var userAge: Int

    init(user: User?) {
        self.user = user
        _userName = State(initialValue: user?.name ?? "")
        _userAge = State(initialValue: user?.age ?? 25)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.blue)
                        TextField("Name", text: $userName)
                    }

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.orange)
                        Picker("Age", selection: $userAge) {
                            ForEach(13..<100, id: \.self) { age in
                                Text("\(age) years").tag(age)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                        dismiss()
                    }
                    .disabled(userName.isEmpty)
                }
            }
        }
    }

    private func saveProfile() {
        if let user = user {
            user.name = userName
            user.age = userAge
            user.hasCompletedOnboarding = true
        } else {
            let newUser = User(
                name: userName,
                age: userAge,
                hasCompletedOnboarding: true
            )
            modelContext.insert(newUser)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [User.self, Subtype.self, TodoItem.self])
}
