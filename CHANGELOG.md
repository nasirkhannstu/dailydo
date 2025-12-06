# Changelog

All notable changes to DailyDo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Planned
- AI-powered todo generation with OpenAI/Claude
- Apple Sign In authentication
- CloudKit data synchronization
- Premium subscription features
- Referral program
- Custom themes and colors

---

## [0.2.0] - 2025-12-06

### Fixed
- **Recurring Todos Bug** - Fixed critical bug where recurring todos weren't properly filtering when completed
  - Changed completion instances to use actual completion date instead of template's original date
  - Added `completionDate` parameter to `TodoCalendarRow`
  - Added `completionContextDate` parameter to `TodoDetailView`
  - SubtypeDetailView now uses today's date for list-view completions
  - Recurring todos now correctly disappear from calendar when completed
  - Templates continue showing on future applicable dates

### Changed
- Improved recurring todo implementation with completion instance tracking
- Updated `TodoItem` model with better computed properties (`isRecurringTemplate`, `isCompletionInstance`)

### Documentation
- Reorganized project documentation into 4 files (README, APP_FEATURES, SERVER_FEATURES, CHANGELOG)
- Consolidated PROJECT_SPECIFICATION.md and MVP_PLAN.md into APP_FEATURES.md
- Removed outdated docs folder
- Updated README.md with current status (40% complete)
- Created comprehensive CHANGELOG.md

---

## [0.1.1] - 2025-12-05

### Added
- **Calendar Visibility Controls** - Toggle to show/hide subtypes in calendar view
- Bulk update functionality for all todos in a subtype

### Changed
- Enhanced UI/UX with card-based design improvements
- Refined visual hierarchy across main views

### Commits
- e1348a2 - Improve UI/UX with card-based design and navigation enhancements

---

## [0.1.0] - 2025-12-02 to 2025-12-03

### Added
- **Initial App Release**
- Three-tier organization system (Habits, Plans, Lists)
- Full todo CRUD operations
- Calendar view with week navigation
- Subtask management
- Recurring todo patterns (daily, weekly, monthly, yearly)
- Focus Mode for distraction-free task completion
- Local notifications and reminders
- Card-based modern UI design
- Dark mode support
- Data seeding with sample content

### Features Implemented

**Foundation:**
- SwiftData models (Subtype, TodoItem, Subtask)
- MVVM architecture
- 5-tab navigation structure
- Data persistence with SwiftData/SQLite

**UI Components:**
- HabitsView, PlansView, ListsView
- CalendarView with gradient background
- SubtypeDetailView for todo lists
- TodoDetailView for editing
- FocusView for focused task completion
- SettingsView (basic structure)

**Todo Features:**
- Create/Read/Update/Delete todos
- Title, description, due date/time
- Mark complete/incomplete
- Star important todos
- Subtask creation and tracking
- Recurring patterns
- Show/hide in calendar toggle
- Swipe actions

**Calendar Features:**
- Week view with swipe navigation
- Month/year picker
- Task count indicators
- Filter by status (all/active/completed)
- Filter by type (habits/plans/lists)
- Different visual styles for habits vs plans/lists
- Gradient purple background
- Blue accent colors

**Focus Mode:**
- Full-screen immersive view
- Auto-advance to next task
- Swipe gesture controls
- Timer and metadata display
- Available for Plans and Lists only

**Notifications:**
- NotificationService implementation
- Permission handling
- Schedule/cancel notifications
- Reminder toggle per todo

**Visual Design:**
- Habits: Unified design with continuous left line
- Plans/Lists: Card-based with time area and metadata
- Modern color scheme (purple, blue, green accents)
- Smooth animations and transitions
- Empty states with helpful messages

### Technical

**Models:**
- Subtype (name, type, icon, sortOrder, showInCalendar)
- TodoItem (title, description, dates, recurring, starred, reminders, parentRecurringTodoId)
- Subtask (title, completed, sortOrder)

**Enums:**
- SubtypeType: habit, plan, list
- RecurringType: none, daily, weekly, monthly, yearly

**Services:**
- NotificationService - Local notification management
- DataSeederService - Sample data generation

**Architecture:**
- SwiftUI for all views
- SwiftData for persistence
- MVVM pattern
- Environment-based dependency injection

### Commits
- 1b1fd7d - Initial commit: DailyDo iOS app with Focus Mode feature

---

## Project Milestones

### Sprint 1-3: Foundation (Weeks 1-3) ✅
- December 2, 2025
- Project setup, data models, architecture

### Sprint 4-6: Core UI (Weeks 4-6) ✅
- December 2, 2025
- Navigation, main screens, basic CRUD

### Sprint 7-9: Todo Management (Weeks 7-9) ✅
- December 2-3, 2025
- Full todo functionality, calendar, subtasks

### Sprint 10: Enhancements (Week 10) ✅
- December 3-6, 2025
- Notifications, recurring todos, UI polish

### Sprint 12-14: AI Integration (Weeks 12-14) 🔄
- Planned
- OpenAI/Claude integration, AI todo generation

---

## Version History Summary

| Version | Date | Status | Key Features |
|---------|------|--------|--------------|
| 0.2.0 | Dec 6, 2025 | Released | Recurring todos fix, docs reorganization |
| 0.1.1 | Dec 5, 2025 | Released | Calendar visibility controls, UI improvements |
| 0.1.0 | Dec 2-3, 2025 | Released | Initial release with core features |

---

## Statistics

**Current Version:** 0.2.0
**Lines of Code:** 5,138 (Swift)
**App Size:** ~5.0 MB (debug), ~2-3 MB (estimated release)
**Progress:** 40% of MVP complete
**Sprint:** 10 of 27

---

## Notes

- Versions before 1.0.0 are pre-release/development builds
- Breaking changes may occur between minor versions (0.x.0)
- Full semantic versioning will begin at 1.0.0 (App Store launch)

---

**Legend:**
- ✅ Complete
- 🔄 In Progress
- ⏭️ Planned
- ❌ Cancelled

---

For detailed feature documentation, see [APP_FEATURES.md](./APP_FEATURES.md)
