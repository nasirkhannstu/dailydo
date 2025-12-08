//
//  OnboardingView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    @State private var selectedPurposes: Set<String> = []

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "repeat.circle.fill",
            title: "Build Lasting Habits",
            benefits: [
                "Track daily routines with ease",
                "Set recurring tasks that repeat automatically",
                "Get timely reminders to stay consistent",
                "Visualize your progress over time",
                "Build streaks and maintain momentum"
            ],
            color: .blue
        ),
        OnboardingPage(
            icon: "calendar.badge.checkmark",
            title: "Plan Future, Focus Today",
            benefits: [
                "Break down big goals into actionable tasks",
                "Set deadlines with smart recurring options",
                "Track progress with completion percentages",
                "Organize tasks by projects or themes",
                "Stay focused with calendar integration"
            ],
            color: .green
        ),
        OnboardingPage(
            icon: "list.clipboard.fill",
            title: "Stay Organized",
            benefits: [
                "Create custom lists for anything",
                "Quick capture for todos and ideas",
                "Add subtasks to break work down",
                "Flexible organization with drag-and-drop",
                "Never forget important tasks"
            ],
            color: .orange
        ),
        OnboardingPage(
            icon: "calendar",
            title: "See Your Day at a Glance",
            benefits: [
                "Visualize all tasks in one place",
                "See habits, plans, and lists together",
                "Quick add tasks from any date",
                "Track what's due and what's overdue",
                "Plan your week ahead"
            ],
            color: .purple
        )
    ]

    let purposeOptions = [
        "Build better daily habits",
        "Manage work/study projects",
        "Track fitness goals",
        "Learn new skills",
        "Improve productivity",
        "Personal goal setting",
        "Team/family task management",
        "Exam or test preparation",
        "Other"
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    currentPageColor.opacity(0.3),
                    currentPageColor.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    // Informative pages
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }

                    // Purpose selection page
                    PurposeSelectionView(
                        selectedPurposes: $selectedPurposes,
                        purposeOptions: purposeOptions
                    )
                    .tag(pages.count)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom button
                VStack(spacing: 20) {
                    if currentPage == pages.count {
                        // Get Started button on purpose selection page
                        Button {
                            completeOnboarding()
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        // Next button
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Next")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(pages[currentPage].color)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .animation(.easeInOut, value: currentPage)
    }

    private var currentPageColor: Color {
        if currentPage < pages.count {
            return pages[currentPage].color
        }
        return .indigo
    }

    private func completeOnboarding() {
        withAnimation {
            isOnboardingComplete = true
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(page.color)
                .padding(.bottom, 10)

            // Title
            Text(page.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 10)

            // Benefits list
            VStack(alignment: .leading, spacing: 12) {
                ForEach(page.benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(page.color)
                            .font(.system(size: 20))
                        Text(benefit)
                            .font(.system(size: 16))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}

struct PurposeSelectionView: View {
    @Binding var selectedPurposes: Set<String>
    let purposeOptions: [String]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundStyle(.indigo)
                .padding(.bottom, 10)

            // Title
            Text("What brings you to DailyDo?")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 10)

            // Purpose options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(purposeOptions, id: \.self) { option in
                        Button {
                            togglePurpose(option)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: selectedPurposes.contains(option) ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(selectedPurposes.contains(option) ? .indigo : .gray)
                                    .font(.system(size: 24))

                                Text(option)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedPurposes.contains(option) ? Color.indigo.opacity(0.1) : Color.gray.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedPurposes.contains(option) ? Color.indigo : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()
        }
    }

    private func togglePurpose(_ purpose: String) {
        if selectedPurposes.contains(purpose) {
            selectedPurposes.remove(purpose)
        } else {
            selectedPurposes.insert(purpose)
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let benefits: [String]
    let color: Color
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
