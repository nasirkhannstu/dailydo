//
//  MenuView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/21/25.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var showingProfileEditor = false

    var currentUser: User? {
        users.first
    }

    var userInitials: String {
        guard let name = currentUser?.name else { return "U" }
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
        NavigationStack {
            List {
                // Profile Section - Hero Banner
                Section {
                    if let user = currentUser, user.hasCompletedOnboarding {
                        ProfileHeroBanner(user: user) {
                            showingProfileEditor = true
                        }
                    } else {
                        ProfileReminderCard {
                            showingProfileEditor = true
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // AI & Premium Section
                Section("AI & Premium") {
                    HStack {
                        Label("AI Credits", systemImage: "sparkles")
                        Spacer()
                        Text("\(currentUser?.aiCreditBalance ?? 5) credits")
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        // Purchase credits
                    } label: {
                        Label("Purchase Credits", systemImage: "cart")
                    }

                    NavigationLink(destination: Text("Premium Features")) {
                        HStack {
                            Label("Upgrade to Premium", systemImage: "crown.fill")
                                .foregroundStyle(.orange)
                            Spacer()
                            Text("$4.99/mo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Customization Section
                Section("Customization") {
                    NavigationLink(destination: Text("Background Images")) {
                        Label("Background Images", systemImage: "photo.on.rectangle.angled")
                    }

                    NavigationLink(destination: Text("Colors")) {
                        Label("My Colors", systemImage: "paintpalette")
                    }

                    NavigationLink(destination: Text("Themes")) {
                        Label("My Themes", systemImage: "wand.and.stars")
                    }

                    NavigationLink(destination: Text("Textures")) {
                        Label("My Textures", systemImage: "square.grid.3x3")
                    }
                }

                // App Features
                Section("Features") {
                    NavigationLink(destination: Text("Focus Mode Settings")) {
                        Label("Focus Mode", systemImage: "scope")
                    }

                    NavigationLink(destination: Text("Widget Configuration")) {
                        Label("Widgets", systemImage: "square.grid.2x2")
                    }

                    NavigationLink(destination: Text("Siri Shortcuts")) {
                        Label("Siri Shortcuts", systemImage: "mic.fill")
                    }

                    NavigationLink(destination: Text("Calendar Sync")) {
                        Label("Calendar Sync", systemImage: "calendar.badge.clock")
                    }
                }

                // Preferences
                Section("Preferences") {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                }

                // Data & Privacy
                Section("Data & Privacy") {
                    NavigationLink(destination: Text("Export Data")) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }

                    NavigationLink(destination: Text("Backup & Restore")) {
                        Label("Backup & Restore", systemImage: "externaldrive")
                    }

                    Button(role: .destructive) {
                        // Clear data action
                    } label: {
                        Label("Clear Completed Tasks", systemImage: "trash")
                    }
                }

                // Help & Support
                Section("Help & Support") {
                    NavigationLink(destination: FeatureGuideView()) {
                        Label("Features Guide", systemImage: "book.fill")
                    }

                    NavigationLink(destination: Text("Help & Tutorial")) {
                        Label("Help & Tutorial", systemImage: "questionmark.circle")
                    }

                    NavigationLink(destination: Text("Contact Support")) {
                        Label("Contact Support", systemImage: "envelope")
                    }

                    NavigationLink(destination: Text("Referral Program")) {
                        Label("Invite Friends", systemImage: "gift")
                    }
                }

                // About & Legal
                Section("About & Legal") {
                    NavigationLink(destination: Text("About DailyDo")) {
                        Label("About DailyDo", systemImage: "info.circle")
                    }

                    NavigationLink(destination: Text("Privacy Policy")) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    NavigationLink(destination: Text("Terms of Service")) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }

                    Button {
                        // Rate app action
                    } label: {
                        Label("Rate App", systemImage: "star")
                    }

                    Button {
                        // Share app action
                    } label: {
                        Label("Share DailyDo", systemImage: "square.and.arrow.up")
                    }

                    HStack {
                        Text("Version")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingProfileEditor) {
                ProfileEditorSheet(user: currentUser)
            }
        }
    }
}

#Preview {
    MenuView()
        .modelContainer(for: [User.self, TodoItem.self, Subtype.self])
}
