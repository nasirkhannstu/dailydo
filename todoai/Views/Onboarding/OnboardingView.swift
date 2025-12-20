//
//  OnboardingView.swift
//  DailyDo
//
//  Created by Nasir Khan on 12/3/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    @State private var userName = ""
    @State private var userAge: Int = 25
    @State private var selectedPurposes: Set<String> = []
    @State private var showSkipButton = false
    @FocusState private var isNameFieldFocused: Bool

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "repeat.circle.fill",
            imageName: "HabitOnboarding",
            title: "Build Lasting Habits",
            benefits: [
                "Track daily routines with ease",
                "Set recurring tasks that repeat automatically",
                "Get timely reminders to stay consistent",
                "Visualize your progress over time",
                "Build streaks and maintain momentum"
            ],
            color: .green
        ),
        OnboardingPage(
            icon: "calendar.badge.checkmark",
            imageName: "PlanOnboarding",
            title: "Plan Future, Focus Today",
            benefits: [
                "Break down big goals into actionable tasks",
                "Set deadlines with smart recurring options",
                "Track progress with completion percentages",
                "Organize tasks by projects or themes",
                "Stay focused with calendar integration"
            ],
            color: .blue
        ),
        OnboardingPage(
            icon: "list.clipboard.fill",
            imageName: "ListOnboarding",
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
            imageName: "CalendarOnboarding",
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

    var totalPages: Int {
        pages.count + 3 // 4 info pages + name + age + purpose
    }

    var body: some View {
        ZStack {
            // Animated background gradient with parallax
            AnimatedBackgroundGradient(currentPage: currentPage, pages: pages, totalPages: totalPages)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 44)

                // Page content with custom gesture
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Group {
                                if index < pages.count {
                                    OnboardingPageView(page: pages[index], offset: parallaxOffset(for: index))
                                } else if index == pages.count {
                                    NameInputView(userName: $userName, isNameFieldFocused: $isNameFieldFocused)
                                } else if index == pages.count + 1 {
                                    AgeInputView(userAge: $userAge)
                                } else {
                                    PurposeSelectionView(
                                        selectedPurposes: $selectedPurposes,
                                        purposeOptions: purposeOptions
                                    )
                                }
                            }
                            .opacity(index == currentPage ? 1 : 0)
                            .offset(x: CGFloat(index - currentPage) * geometry.size.width + dragOffset)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    if value.translation.width < -threshold && currentPage < totalPages - 1 {
                                        currentPage += 1
                                    } else if value.translation.width > threshold && currentPage > 0 {
                                        currentPage -= 1
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                }

                // Bottom buttons (inline)
                HStack(spacing: 16) {
                    // Back button (only show if not on first page)
                    if currentPage > 0 {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.left")
                                Text("Back")
                                    .font(.headline)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(currentPageColor.opacity(0.6))
                            .cornerRadius(16)
                        }
                    }

                    // Next or Get Started button
                    if currentPage == totalPages - 1 {
                        // Get Started button on last page
                        Button {
                            completeOnboarding()
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.indigo, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.indigo.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                    } else {
                        // Next button
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                if currentPage == pages.count && userName.isEmpty {
                                    // Shake animation for empty name
                                    return
                                }
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
                            .background(currentPageColor)
                            .cornerRadius(16)
                            .shadow(color: currentPageColor.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            // Show skip button after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSkipButton = true
                }
            }
        }
    }

    private var currentPageColor: Color {
        if currentPage < pages.count {
            return pages[currentPage].color
        } else if currentPage == pages.count {
            return .blue
        } else if currentPage == pages.count + 1 {
            return .orange
        }
        return .indigo
    }

    private func parallaxOffset(for index: Int) -> CGFloat {
        let offset = CGFloat(currentPage - index) * 20
        return offset
    }

    private func skipOnboarding() {
        withAnimation {
            isOnboardingComplete = true
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }

    private func completeOnboarding() {
        // Save user data
        let user: User
        if let existingUser = users.first {
            user = existingUser
            user.name = userName.isEmpty ? "User" : userName
            user.age = userAge
            user.hasCompletedOnboarding = true
        } else {
            user = User(
                name: userName.isEmpty ? "User" : userName,
                age: userAge,
                hasCompletedOnboarding: true
            )
            modelContext.insert(user)
        }

        withAnimation {
            isOnboardingComplete = true
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }
}

// MARK: - Animated Background Gradient

struct AnimatedBackgroundGradient: View {
    let currentPage: Int
    let pages: [OnboardingPage]
    let totalPages: Int

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                backgroundColorForPage.opacity(0.3),
                backgroundColorForPage.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.easeInOut(duration: 0.5), value: currentPage)
    }

    private var backgroundColorForPage: Color {
        if currentPage < pages.count {
            return pages[currentPage].color
        } else if currentPage == pages.count {
            return .blue
        } else if currentPage == pages.count + 1 {
            return .orange
        }
        return .indigo
    }
}

// MARK: - Onboarding Page View with Parallax

struct OnboardingPageView: View {
    let page: OnboardingPage
    let offset: CGFloat

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Image with floating animation
            if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280)
                    .cornerRadius(40)
                    .shadow(color: page.color.opacity(0.3), radius: 20, x: 0, y: 10)
                    .offset(y: offset * 0.5)
            } else {
                // Fallback to icon if no image
                Image(systemName: page.icon)
                    .font(.system(size: 80))
                    .foregroundStyle(page.color)
                    .padding(.bottom, 10)
                    .offset(y: offset * 0.5)
                    .shadow(color: page.color.opacity(0.3), radius: 20, x: 0, y: 10)
            }

            // Title
            Text(page.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 10)
                .offset(y: offset * 0.3)

            // Benefits list
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(page.benefits.enumerated()), id: \.offset) { index, benefit in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(page.color)
                            .font(.system(size: 20))
                        Text(benefit)
                            .font(.system(size: 16))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .offset(y: offset * 0.1 * CGFloat(index))
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}

// MARK: - Name Input View

struct NameInputView: View {
    @Binding var userName: String
    @FocusState.Binding var isNameFieldFocused: Bool

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .padding(.bottom, 10)

            // Title
            Text("What's your name?")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Subtitle
            Text("We'll use this to personalize your experience")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Name input
            VStack(spacing: 8) {
                TextField("Enter your name", text: $userName)
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .focused($isNameFieldFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isNameFieldFocused = true
                        }
                    }
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)

            Spacer()
        }
    }
}

// MARK: - Age Input View

struct AgeInputView: View {
    @Binding var userAge: Int

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
                .padding(.bottom, 10)

            // Title
            Text("How old are you?")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Subtitle
            Text("This helps us personalize your experience")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Age picker
            VStack(alignment: .center, spacing: 8) {
                Picker("Age", selection: $userAge) {
                    ForEach(13..<100, id: \.self) { age in
                        Text("\(age) years").tag(age)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)

            Spacer()
        }
    }
}

// MARK: - Purpose Selection View

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

            // Subtitle
            Text("Select all that apply")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Purpose options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(purposeOptions, id: \.self) { option in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                togglePurpose(option)
                            }
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
                                    .fill(selectedPurposes.contains(option) ? Color.indigo.opacity(0.1) : Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedPurposes.contains(option) ? Color.indigo : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

// MARK: - Onboarding Page Model

struct OnboardingPage {
    let icon: String
    let imageName: String?
    let title: String
    let benefits: [String]
    let color: Color

    init(icon: String, imageName: String? = nil, title: String, benefits: [String], color: Color) {
        self.icon = icon
        self.imageName = imageName
        self.title = title
        self.benefits = benefits
        self.color = color
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
        .modelContainer(for: [User.self, Subtype.self, TodoItem.self])
}
