//
//  SettingsView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/2/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                // User Profile Section
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading) {
                            Text("Nasir Khan")
                                .font(.headline)
                            Text("Free Plan")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // AI Credits Section
                Section("AI Credits") {
                    HStack {
                        Label("Current Balance", systemImage: "sparkles")
                        Spacer()
                        Text("5 credits")
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
        }
    }

    private func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        // Force close the app - user will need to reopen to see onboarding
        exit(0)
    }
}

#Preview {
    SettingsView()
}
