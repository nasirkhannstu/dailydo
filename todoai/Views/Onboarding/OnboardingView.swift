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

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "calendar.badge.checkmark",
            title: "Plan Future, Focus Today",
            description: "Organize your life with powerful planning tools while staying focused on what matters today.",
            color: .blue
        ),
        OnboardingPage(
            icon: "repeat.circle.fill",
            title: "Build Better Habits",
            description: "Create daily routines with recurring tasks and track your progress over time.",
            color: .green
        ),
        OnboardingPage(
            icon: "list.clipboard.fill",
            title: "Smart Task Management",
            description: "Break down big goals into actionable steps with subtasks and detailed planning.",
            color: .orange
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Never Miss a Beat",
            description: "Set reminders and get notified for important tasks. Stay on track with smart notifications.",
            color: .purple
        ),
        OnboardingPage(
            icon: "calendar",
            title: "Calendar View",
            description: "Visualize your schedule and see all your tasks in a beautiful calendar interface.",
            color: .red
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            title: "Track Your Progress",
            description: "Complete tasks, build streaks, and celebrate your achievements as you grow.",
            color: .indigo
        )
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    pages[currentPage].color.opacity(0.3),
                    pages[currentPage].color.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Bottom button
                VStack(spacing: 20) {
                    if currentPage == pages.count - 1 {
                        // Get Started button on last page
                        Button {
                            completeOnboarding()
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(pages[currentPage].color)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        // Next and Skip buttons
                        HStack {
                            Button {
                                completeOnboarding()
                            } label: {
                                Text("Skip")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

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
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(pages[currentPage].color)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .animation(.easeInOut, value: currentPage)
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
                .font(.system(size: 100))
                .foregroundStyle(page.color)
                .padding(.bottom, 20)

            // Title
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Description
            Text(page.description)
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
