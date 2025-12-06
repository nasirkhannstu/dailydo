# DailyDo: App Features & Development

**Version:** 1.1
**Last Updated:** December 6, 2025
**Platform:** iOS 17.0+
**Status:** Active Development (40% Complete)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Current Status](#2-current-status)
3. [Core Features](#3-core-features)
4. [Technical Architecture](#4-technical-architecture)
5. [Development Plan](#5-development-plan)
6. [Completed Features](#6-completed-features)
7. [In Progress](#7-in-progress)
8. [Roadmap](#8-roadmap)

---

## 1. Project Overview

DailyDo is an AI-powered iOS productivity app that helps users organize tasks, build habits, and manage daily life with intelligent assistance.

### Key Differentiators
- ✅ **Three-tier organization:** Habits, Plans, and Lists
- ✅ **Unified calendar view** across all categories
- ✅ **Focus Mode** for distraction-free task completion
- ✅ **Recurring todos** with smart completion tracking
- 🔄 **AI-powered todo generation** (planned)
- 🔄 **Customizable themes** (planned)
- 🔄 **CloudKit sync** (planned)

### Business Model
**Freemium** - Free core features with premium upgrades

**Free Features:**
- Unlimited todos, habits, plans, and lists
- Calendar view with filtering
- Reminders and notifications
- Focus Mode
- Basic themes

**Premium Features (Planned):**
- Unlimited AI generations
- Sharing and collaboration
- Advanced analytics
- Export functionality
- Custom themes

---

## 2. Current Status

**Development Phase:** Sprint 10 (Week 10 of 27)
**Overall Progress:** ~40% Complete
**App Size:** 5.0 MB (debug), ~2-3 MB (estimated release)
**Code:** 5,138 lines of Swift

### What Works Now ✅

Users can:
1. ✅ Create and manage Habits, Plans, and Lists
2. ✅ Add todos with title, description, due date/time
3. ✅ Create and track subtasks
4. ✅ Mark todos complete/incomplete
5. ✅ Set recurring patterns (daily, weekly, monthly, yearly)
6. ✅ Star important todos
7. ✅ View todos on calendar by date
8. ✅ Filter by status and type
9. ✅ Set reminders and notifications
10. ✅ Use Focus Mode for task completion
11. ✅ Navigate with modern card-based UI
12. ✅ Use in dark mode

### Recent Updates (Dec 2-6, 2025)

**Dec 6:**
- ✅ Fixed recurring todos functionality
- ✅ Implemented completion instances for recurring tasks
- ✅ Recurring todos now properly filter when completed

**Dec 5:**
- ✅ Added calendar visibility controls
- ✅ Improved UI/UX with card-based design

**Dec 3:**
- ✅ Redesigned calendar with gradient background
- ✅ Different visual styles for Habits vs Plans/Lists
- ✅ Removed Focus button from Habits

**Dec 2:**
- ✅ Initial app creation and foundation

---

## 3. Core Features

### 3.1 Three Main Categories

#### A. Habits
**Purpose:** Track recurring activities and build consistent routines

**Examples:**
- Water Intake (8 glasses daily)
- Exercise (Morning walk 30 min)
- Reading (Daily 1 hour)
- Meditation (Morning/Evening)

**Features:**
- Recurring patterns
- Streak tracking (planned)
- Progress visualization (planned)
- Simplified UI (no Focus button)

#### B. Plans
**Purpose:** Organize goal-oriented activities with timelines

**Examples:**
- Study Plan (IELTS Preparation)
- Tour Plan (Itinerary, Bookings)
- Fitness Plan (30-day workout)
- Project Plan (Work/Personal)

**Features:**
- Goal-oriented tasks
- Timeline tracking
- Milestone support
- Focus Mode integration

#### C. Lists
**Purpose:** Organize collections and one-off tasks

**Examples:**
- Watch List (Movies, TV shows)
- Shopping List (Groceries)
- Travel Checklist
- Book List

**Features:**
- Collection-based organization
- Easy checklist format
- Quick task entry
- Focus Mode integration

### 3.2 Todo Structure

**Fields:**
- Title (required)
- Description (optional)
- Due Date (optional)
- Due Time (optional)
- Recurring Type (none, daily, weekly, monthly, yearly)
- Subtasks (unlimited)
- Starred flag
- Reminder enabled
- Show in calendar toggle
- Completion status
- Parent recurring todo (for completion instances)

### 3.3 Calendar View

**Features:**
- Week view with swipe navigation
- Month/Year picker
- Task count indicators
- Gradient background design
- Filter by status and type
- Shows recurring todos on applicable dates
- Hides completed recurring instances

### 3.4 Focus Mode

**Purpose:** Distraction-free task completion

**Features:**
- Full-screen immersive view
- Auto-advance to next task
- Swipe gesture controls
- Timer display
- Task metadata (due time, category)
- Only for Plans and Lists (not Habits)

### 3.5 Recurring Todos (New Implementation)

**How It Works:**
- Recurring **templates** define the pattern and never get marked complete
- When user marks a recurring todo complete, a **completion instance** is created
- Completion instances are linked to their parent template
- Templates continue showing on future dates
- Completed dates are filtered out automatically

**Example:**
- Create "Drink water" habit (daily recurring, starts Dec 1)
- On Dec 5, mark it complete → creates completion instance for Dec 5
- "Drink water" disappears from Dec 5 calendar
- "Drink water" still shows on Dec 6, 7, 8, etc.

---

## 4. Technical Architecture

### 4.1 Technology Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS 17.0+ |
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Data | SwiftData (Core Data wrapper) |
| Storage | SQLite (via SwiftData) |
| Sync | CloudKit (planned) |
| Architecture | MVVM |
| Notifications | UserNotifications framework |

### 4.2 Data Models

**Core Models:**
1. **Subtype** - Represents Habits, Plans, or Lists
   - name, type, icon, sortOrder
   - showInCalendar flag
   - Relationship: has many TodoItems

2. **TodoItem** - Individual task
   - title, description, dates, flags
   - recurringType, parentRecurringTodoId
   - Relationship: belongs to Subtype, has many Subtasks

3. **Subtask** - Sub-item of a todo
   - title, completed, sortOrder
   - Relationship: belongs to TodoItem

**Enums:**
- SubtypeType: habit, plan, list
- RecurringType: none, daily, weekly, monthly, yearly

### 4.3 Key Services

- **NotificationService** - Manages local notifications
- **DataSeederService** - Creates sample data on first launch
- More services planned (AI, Auth, Sync)

---

## 5. Development Plan

### MVP Timeline: 27 Weeks (6-7 months)

**Phase 1: Foundation (Weeks 1-3)** ✅ COMPLETE
- Project setup, data models, architecture

**Phase 2: Core UI (Weeks 4-6)** ✅ COMPLETE
- Navigation, main screens, basic CRUD

**Phase 3: Todo Management (Weeks 7-9)** ✅ COMPLETE
- Full todo functionality, calendar, subtasks

**Phase 4: Notifications (Week 10-11)** ✅ COMPLETE (Early)
- Reminder system, notification settings

**Phase 5: AI Integration (Weeks 12-14)** 🔄 NEXT
- OpenAI/Claude integration, AI todo generation

**Phase 6: Auth & Sync (Weeks 15-16)** ⏭️ Planned
- Apple Sign In, CloudKit synchronization

**Phase 7: Monetization (Weeks 17-19)** ⏭️ Planned
- StoreKit 2, subscriptions, IAPs

**Phase 8: Polish & Launch (Weeks 20-27)** ⏭️ Planned
- Referrals, onboarding, testing, App Store

---

## 6. Completed Features

### ✅ Sprint 1-3: Foundation (100%)
- ✅ Xcode project setup
- ✅ SwiftData models (Subtype, TodoItem, Subtask)
- ✅ MVVM architecture
- ✅ Enums and relationships

### ✅ Sprint 4-6: Core UI (100%)
- ✅ 5-tab navigation (Habits, Plans, Lists, Calendar, Settings)
- ✅ All main views created
- ✅ Empty states
- ✅ Create/edit forms
- ✅ Dark mode support

### ✅ Sprint 7-9: Todo Management (100%)
- ✅ Full CRUD operations
- ✅ Due dates and times
- ✅ Star/unstar functionality
- ✅ Swipe actions
- ✅ Calendar integration
- ✅ Data persistence

### ✅ Sprint 10: Additional Features (100%)
- ✅ Subtask management UI
- ✅ Focus Mode implementation
- ✅ Recurring todos (fully functional)
- ✅ Notification system
- ✅ Calendar visibility controls
- ✅ Modern card-based UI design
- ✅ Sample data seeding

---

## 7. In Progress

### 🔄 Documentation
- Consolidating project docs
- Creating changelog
- Updating README

---

## 8. Roadmap

### Next Up (Sprint 12-14: Weeks 12-14)
**AI Integration** - The main differentiator

Tasks:
- [ ] Choose AI provider (OpenAI GPT-4 or Claude)
- [ ] Create AIService
- [ ] Design AI prompt flow
- [ ] Build AI generation UI
- [ ] Implement credit system
- [ ] Add "Generate with AI" buttons

**Estimated:** 3-5 days

### Future Sprints

**Sprint 15-16: Authentication & Sync**
- [ ] Apple Sign In
- [ ] User accounts
- [ ] CloudKit setup
- [ ] Data synchronization
- [ ] Conflict resolution

**Sprint 17-19: Monetization**
- [ ] StoreKit 2 integration
- [ ] Subscription tiers
- [ ] AI credit packs
- [ ] Theme packs
- [ ] Store UI

**Sprint 20: Referral System**
- [ ] Referral code generation
- [ ] Tracking system
- [ ] Credit rewards
- [ ] Share functionality

**Sprint 21-24: Polish & Testing**
- [ ] Onboarding flow
- [ ] Animations and transitions
- [ ] Performance optimization
- [ ] Unit tests
- [ ] UI tests
- [ ] Beta testing

**Sprint 25-27: Launch**
- [ ] App Store assets
- [ ] Marketing materials
- [ ] Privacy policy
- [ ] Terms of service
- [ ] App Store submission

---

## Feature Priority Matrix

### Must Have (MVP Blockers)
- ✅ Basic todo management
- ✅ Calendar view
- ✅ Recurring todos
- ✅ Notifications
- 🔄 AI generation (next)
- ⏭️ User accounts
- ⏭️ Data sync

### Should Have (High Value)
- ⏭️ Advanced filtering
- ⏭️ Search functionality
- ⏭️ Analytics/insights
- ⏭️ Export data
- ⏭️ Themes/customization

### Nice to Have (Future)
- ⏭️ Collaboration/sharing
- ⏭️ Widget support
- ⏭️ Apple Watch app
- ⏭️ Siri shortcuts
- ⏭️ iPad optimization

---

## Questions or Feedback?

This is a living document. For questions about features or development:
- Review this document
- Check CHANGELOG.md for recent changes
- See README.md for setup instructions

---

**Last Updated:** December 6, 2025
**Next Review:** After AI Integration (Sprint 12-14)
