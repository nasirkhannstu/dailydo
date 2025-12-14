# DailyDo: App Features & Development

**Version:** 1.2
**Last Updated:** December 15, 2024
**Platform:** iOS 17.0+
**Status:** Active Development (45% Complete)

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
9. [Changelog](#9-changelog)

---

## 1. Project Overview

DailyDo is an AI-powered iOS productivity app that helps users organize tasks, build habits, and manage daily life with intelligent assistance.

### Key Differentiators
- ✅ **Three-tier organization:** Habits, Plans, and Lists
- ✅ **Template Gallery:** 20+ pre-made templates with smart time scheduling
- ✅ **4-Level Priority System:** High, Medium, Low, None with quick filtering
- ✅ **Unified calendar view** across all categories with priority colors
- ✅ **Focus Mode** for distraction-free task completion
- ✅ **Recurring todos** with smart completion tracking
- ✅ **Daily Notes** with 6 expressive emoji moods
- 🔄 **AI-powered todo generation** (planned)
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

**Development Phase:** Sprint 11 (Week 11 of 27)
**Overall Progress:** ~45% Complete
**App Size:** 5.2 MB (debug), ~2-3 MB (estimated release)
**Code:** 5,500+ lines of Swift

### What Works Now ✅

Users can:
1. ✅ Create and manage Habits, Plans, and Lists
2. ✅ Use 20+ pre-made templates with smart time scheduling
3. ✅ Add todos with title, description, due date/time
4. ✅ Set 4-level priorities (High, Medium, Low, None)
5. ✅ Filter tasks by priority with quick access buttons
6. ✅ Create and track subtasks
7. ✅ Mark todos complete/incomplete
8. ✅ Set recurring patterns (daily, weekly, monthly, yearly)
9. ✅ View todos on calendar with color-coded priorities
10. ✅ Filter by status, type, and priority
11. ✅ Set reminders and notifications
12. ✅ Use Focus Mode for task completion
13. ✅ Write daily notes with 6 emoji mood options
14. ✅ Navigate with modern card-based UI
15. ✅ Auto-navigate to newly created subtypes
16. ✅ Use in dark mode

### Recent Updates (Dec 2024)

**Dec 15:**
- ✅ Replaced star feature with 4-level priority system (High/Medium/Low/None)
- ✅ Added priority filtering with quick access buttons (All, High, Med, Low, None)
- ✅ Updated daily notes to 6 expressive emoji moods (😊😌😐😔😫😤)
- ✅ Smart template scheduling with realistic, staggered times
- ✅ Auto-navigation to newly created subtypes
- ✅ Empty state "Create First Todo" button in subtypes
- ✅ Updated ASO strategy document with latest features

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
- Due Date (optional) - Serves dual purpose: "Due Date" for regular tasks, "Starts" for recurring tasks
- Due Time (optional)
- Recurring Type (none, daily, weekly, monthly, yearly)
- Recurring End Date (optional) - When recurring should stop (nil = never ends)
- Subtasks (unlimited)
- Priority (High, Medium, Low, None) - 4-level system with color coding
- Reminder enabled
- Show in calendar toggle
- Completion status
- Parent recurring todo (for completion instances)

### 3.3 Calendar View

**Features:**
- Week view with swipe navigation
- Month/Year picker
- Task count indicators
- Color-coded by priority (Red/Orange/Green/Gray)
- Gradient background design
- Quick priority filters (All, High, Medium, Low, None)
- Filter by status and type
- Shows recurring todos on applicable dates
- Hides completed recurring instances

### 3.4 Template Gallery

**Purpose:** Quick-start with pre-configured subtypes

**Features:**
- 20+ ready-made templates (10 Habits, 5 Plans, 5 Lists)
- Pre-scheduled times (realistic, staggered throughout the day)
- One-tap creation
- Fully customizable after creation

**Template Categories:**
- **Habits:** Water Intake, Exercise, Medication, Healthy Breakfast, Skin Care, Dental Care, Feed Pets, Prayer Time, Daily Reading, Steps Goal
- **Plans:** Work Project, Study & Learning, Home Improvement, Event Planning, Career Development
- **Lists:** Grocery Shopping, Meal Planning, Reading List, Cleaning Schedule, Packing List

### 3.5 Daily Notes

**Purpose:** Mood tracking and daily journaling

**Features:**
- 6 expressive emoji moods (😊😌😐😔😫😤)
- Free-form text editor
- Gradient themes that match mood
- Auto-save functionality
- Historical review

**Moods:**
- Happy (😊) - Green gradient
- Calm (😌) - Light blue gradient
- Neutral (😐) - Gray gradient
- Sad (😔) - Soft blue gradient
- Stressed (😫) - Orange gradient
- Angry (😤) - Red gradient

### 3.6 Focus Mode

**Purpose:** Distraction-free task completion

**Features:**
- Full-screen immersive view
- Auto-advance to next task
- Swipe gesture controls
- Timer display
- Task metadata (due time, category)
- Only for Plans and Lists (not Habits)

### 3.7 Recurring Todos

**Architecture:**
Recurring todos use a **template + completion instances** pattern:
- **Template** - Defines the recurring pattern (daily, weekly, etc.), never marked complete
- **Completion Instance** - Created when user marks template complete for a specific date
- Linked via `parentRecurringTodoId` field

**Key Features:**
- ✅ **Infinite or Timed Recurring** - Set an optional end date or let it run forever
- ✅ **Dual-Purpose Date Field** - `dueDate` serves as "Due Date" for regular tasks, "Starts" for recurring tasks
- ✅ **Smart Calendar Filtering** - Recurring tasks only appear between start and end dates
- ✅ **Dynamic UI Labels** - Task detail shows "Starts" instead of "Due Date" for recurring templates

---

#### Recurring End Date

**Purpose:** Support timed plans like 30-day challenges or exam preparation.

**How It Works:**
1. **Create recurring todo** with pattern (daily/weekly/monthly/yearly)
2. **Toggle "End Date"** in task details to enable
3. **Set end date** using date picker (defaults to 30 days from start)
4. **Task auto-hides** from calendar AND lists after end date passes
5. **Completion history preserved** - View past completions in detail view even after task ends

**Use Cases:**
- 30-Day Fitness Challenge (daily workouts until day 30)
- 60-Day IELTS Preparation (daily study until exam date)
- Weekly team meetings (ends when project completes)
- Monthly medication (stops after treatment period)

**Examples:**

**Example 1: 30-Day Fitness Challenge**
```
Title: Morning cardio - 20 minutes
Starts: Dec 6, 2025 at 6:30 AM
Repeats: Daily
End Date: Jan 5, 2026 (30 days later)

Result:
- Shows on calendar: Dec 6 - Jan 5
- Auto-hides from calendar AND lists on Jan 6 (day after end date)
- Completion history preserved for future reference
```

**Example 2: IELTS Exam Preparation**
```
Title: Listening practice - 30 minutes
Starts: Dec 6, 2025 at 7:00 AM
Repeats: Daily
End Date: Feb 4, 2026 (60 days - exam day)

Result:
- Practice every day until exam (Feb 4)
- Auto-hides from calendar AND lists on Feb 5
- All 60 days of completion history preserved
```

**Example 3: Never-Ending Habit**
```
Title: Drink water (8 glasses)
Starts: Dec 6, 2025 at 8:00 AM
Repeats: Daily
End Date: (none - toggle off)

Result:
- Shows forever on calendar
- Never auto-hides
- Perfect for lifelong habits
```

---

#### How It Works

**Creating a Recurring Todo:**
1. User creates "Drink water" with recurring pattern = Daily
2. Template is created with `recurringType = .daily`, `parentRecurringTodoId = nil`
3. Template shows on all applicable dates in Calendar

**Completing from Different Views:**

**From Calendar View:**
- User selects Dec 6, sees "Drink water"
- Clicks completion circle
- Creates completion instance with `dueDate = Dec 6`, `parentRecurringTodoId = [template id]`
- Template disappears from Dec 6 calendar
- Template still shows on Dec 7, 8, 9...

**From List View (Habits/Plans/Lists):**
- User sees "Drink water" with 🔁 Daily icon
- Clicks completion circle → turns green ✅
- Creates completion instance for TODAY
- Tomorrow, circle resets to empty ⭕
- Template stays in list (never removed)

---

#### Visual Behavior

**In SubtypeDetailView (Lists):**
```
Active Tasks
  ⭕ Drink water (daily) 🔁 Daily    ← Not completed today
  ✅ Exercise (daily) 🔁 Daily       ← Completed today
  ⭕ Read book (one-time)            ← Regular task

Completed Tasks
  ✅ Buy groceries                   ← Non-recurring completed
```

**Notes:**
- Completion instances are HIDDEN from lists (only show templates)
- Smart circle shows green if completed TODAY
- Click to toggle (creates/deletes today's completion instance)

---

**In TodoDetailView (Details):**

**For Templates:**
```
Task Details
━━━━━━━━━━━━━━━━━━━
Title: Drink water
Starts: Every day at 9:00 AM        ← "Starts" for recurring
Recurring: Daily
End Date: [Toggle]                   ← NEW: Optional end date
  Ends On: Jan 5, 2026              ← Shows if toggle enabled
Reminder: Enabled

Completion History:
  ✓ Friday, Dec 6 at 2:30 PM
  ✓ Thursday, Dec 5 at 3:15 PM
  ✓ Wednesday, Dec 4 at 1:45 PM

Actions:
  ⭐ Star
  🗑️ Delete
```

**For Completion Instances:**
```
Completed Task
━━━━━━━━━━━━━━━━━━━
Title: Drink water (grayed out)
Due: Dec 5 at 9:00 AM (grayed out)

Subtasks: (grayed out)
  ✓ Morning glass
  ✓ Afternoon glass

(No actions, no buttons)
(Everything read-only)
```

**Completion Instance Rules:**
- ❌ Cannot edit any fields
- ❌ Cannot toggle completion status
- ❌ Cannot star/unstar
- ❌ Cannot add subtasks
- ❌ No action buttons visible
- ✅ Can only view (read-only)
- To delete: Use list view or calendar

---

**In CalendarView:**
- Templates show on ALL applicable dates
- When completed for a date, template hides for that date only
- Completion instances NOT shown in calendar list (filtered out)
- Templates auto-hide when completion instance exists for that date

---

#### Implementation Details

**Data Model:**
- `TodoItem.recurringType`: .none, .daily, .weekly, .monthly, .yearly
- `TodoItem.parentRecurringTodoId`: nil for templates, UUID for completion instances
- `TodoItem.recurringEndDate`: Date? (nil = never ends, Date = stops after this date)
- `TodoItem.dueDate`: Serves dual purpose (due date for regular, start date for recurring)

**Computed Properties:**
- `isRecurringTemplate`: `recurringType != .none && parentRecurringTodoId == nil`
- `isCompletionInstance`: `parentRecurringTodoId != nil`
- `dueDateLabel`: Returns "Starts" for recurring templates, "Due Date" for others

**Filtering Logic:**
- **Lists**: Show only templates, hide completion instances and ended recurring tasks
- **Calendar**: Show templates on applicable dates between start and end dates, hide if completion instance exists for that date
- **Detail View**: Full access for templates, read-only for completion instances
- **Auto-Hide**: Tasks with `recurringEndDate` past today are automatically filtered out from all views

**Calendar Date Range Logic:**
```swift
// Show recurring template only if:
1. selectedDate >= dueDate (start date)
2. selectedDate <= recurringEndDate (if set)
3. No completion instance exists for selectedDate
```

**Example Scenario:**

1. **Dec 1:** Create "Drink water" (daily recurring)
2. **Dec 5:** Complete from calendar
   - Creates: `TodoItem(dueDate=Dec 5, parentRecurringTodoId=[template id], completed=true)`
   - Calendar Dec 5: "Drink water" disappears
   - List view: Still shows template with empty circle
3. **Dec 6:** Template shows again in calendar (empty circle)
4. **Dec 6:** Complete from list view
   - Creates: `TodoItem(dueDate=Dec 6, parentRecurringTodoId=[template id], completed=true)`
   - List view: Circle turns green for today
   - Calendar Dec 6: "Drink water" disappears
5. **Dec 7:** List view circle resets to empty
6. **Open template details:** See completion history (Dec 5, Dec 6)

---

#### Benefits

✅ **Clean Lists** - One row per task, no clutter
✅ **Historical Records** - All completions tracked
✅ **Flexible Completion** - Complete from calendar or list
✅ **Visual Feedback** - Smart circle shows today's status
✅ **Data Integrity** - Templates never modified, only instances created

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

### ✅ Sprint 11: Priority System & Templates (100%)
- ✅ 4-level priority system (High, Medium, Low, None)
- ✅ Priority filtering with quick access buttons
- ✅ Template Gallery with 20+ templates
- ✅ Smart template time scheduling
- ✅ Daily Notes with 6 emoji moods
- ✅ Auto-navigation to new subtypes
- ✅ Empty state improvements ("Create First Todo" button)
- ✅ ASO strategy document update

---

## 7. In Progress

### 🔄 Icon Auto-Suggestion (Discussed)
- Keyword-based icon matching for subtypes
- Smart suggestions as user types
- Implementation planned

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

---

## 9. Changelog

### Version 1.0 (In Development)

#### Sprint 11 - December 15, 2024
**Priority System & Templates**
- ✅ Replaced star feature with 4-level priority system (High, Medium, Low, None)
- ✅ Added priority quick filter buttons in calendar (All, High, Med, Low, None, Filter icon)
- ✅ Updated daily notes from 8 moods to 6 expressive emojis
- ✅ Implemented smart template scheduling with realistic times
- ✅ Added auto-navigation to newly created subtypes
- ✅ Added "Create First Todo" button in empty subtype state
- ✅ Updated ASO strategy document with latest features

**Technical Changes:**
- Added `TodoPriority` enum with 4 levels
- Added `PriorityFilter` enum for calendar filtering
- Updated `NoteMood` enum to 6 cases with emoji property
- Added time parameters to `TodoTemplate` struct
- Updated all 20 templates with realistic scheduling

#### Sprint 10 - December 6, 2024
**Recurring Todos & UI Polish**
- ✅ Fixed recurring todos functionality
- ✅ Implemented completion instances for recurring tasks
- ✅ Added calendar visibility controls
- ✅ Improved UI/UX with card-based design
- ✅ Added notification system
- ✅ Implemented Focus Mode
- ✅ Added sample data seeding

#### Sprint 7-9 - December 2-5, 2024
**Core Todo Management**
- ✅ Full CRUD operations for todos
- ✅ Due dates and times
- ✅ Star/unstar functionality (later replaced with priorities)
- ✅ Swipe actions
- ✅ Calendar integration
- ✅ Redesigned calendar with gradient background
- ✅ Different visual styles for Habits vs Plans/Lists

#### Sprint 4-6 - November 2024
**Core UI Development**
- ✅ 5-tab navigation (Habits, Plans, Lists, Calendar, Settings)
- ✅ All main views created
- ✅ Empty states
- ✅ Create/edit forms
- ✅ Dark mode support

#### Sprint 1-3 - November 2024
**Foundation**
- ✅ Xcode project setup
- ✅ SwiftData models (Subtype, TodoItem, Subtask)
- ✅ MVVM architecture
- ✅ Enums and relationships

---

## Questions or Feedback?

This is a living document. For questions about features or development:
- Review this document for current status
- Check the Changelog section above for version history
- See README.md for setup instructions

---

**Last Updated:** December 15, 2024
**Next Review:** After AI Integration (Sprint 12-14)
