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
    @State private var showingResetAlert = false
    @State private var showingProfileEditorSheet = false

    var currentUser: User? {
        users.first
    }

    var body: some View {
        NavigationStack {
            List {
                // Hero Banner Profile Section
                Section {
                    if let user = currentUser, user.hasCompletedOnboarding {
                        ProfileHeroBanner(user: user) {
                            showingProfileEditorSheet = true
                        }
                    } else {
                        ProfileReminderCard {
                            showingProfileEditorSheet = true
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // AI Credits Section
                Section("AI Credits") {
                    HStack {
                        Label("Current Balance", systemImage: "sparkles")
                        Spacer()
                        Text("\(currentUser?.aiCreditBalance ?? 5) credits")
                            .foregroundStyle(.secondary)
                    }
                    Button {
                        // Purchase credits
                    } label: {
                        Label("Purchase More Credits", systemImage: "cart")
                    }
                }

                // Premium Section
                Section("Premium") {
                    Button {
                        // Upgrade to premium
                    } label: {
                        HStack {
                            Label("Upgrade to Premium", systemImage: "crown.fill")
                            Spacer()
                            Text("$4.99/month")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Customization Section
                Section("Customization") {
                    NavigationLink(destination: Text("Colors")) {
                        Label("My Colors", systemImage: "paintpalette")
                    }
                    NavigationLink(destination: Text("Textures")) {
                        Label("My Textures", systemImage: "square.grid.3x3")
                    }
                    NavigationLink(destination: Text("Themes")) {
                        Label("My Themes", systemImage: "rectangle.fill")
                    }
                }

                // App Settings Section
                Section("App Settings") {
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink(destination: Text("Sync")) {
                        Label("iCloud Sync", systemImage: "icloud")
                    }

                    Button {
                        showingResetAlert = true
                    } label: {
                        Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                    }
                }

                // Referral Section
                Section("Referral Program") {
                    NavigationLink(destination: Text("Referral")) {
                        Label("Invite Friends", systemImage: "gift")
                    }
                }

                // About Section
                Section("About") {
                    NavigationLink(destination: Text("About")) {
                        Label("About DailyDo", systemImage: "info.circle")
                    }
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    NavigationLink(destination: Text("Terms")) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Onboarding", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetOnboarding()
                }
            } message: {
                Text("This will close the app and show the welcome screens again when you reopen it.")
            }
            .sheet(isPresented: $showingProfileEditorSheet) {
                ProfileEditorSheet(user: currentUser)
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
        ZStack(alignment: .bottom) {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue,
                    Color.purple
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)

            // Content
            HStack(alignment: .center, spacing: 16) {
                // Avatar circle with initials
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

                    Text(userInitials.uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

                // User info
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    if let age = user.age {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.caption)
                            Text("\(age) years old")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.white.opacity(0.9))
                    }

                    Text(user.hasPremiumAccess ? "Premium Member" : "Free Plan")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                }

                Spacer()

                // Edit button
                Button {
                    onEditTap()
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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
