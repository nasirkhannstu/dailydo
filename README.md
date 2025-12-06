# DailyDo: AI To Do and Lifestyle Planner

An AI-powered iOS productivity app for managing tasks, building habits, and organizing daily life.

---

## 🚀 Quick Info

**Platform:** iOS 17.0+
**Status:** Active Development (40% Complete)
**Language:** Swift 5.9+ with SwiftUI
**Size:** ~2-3 MB (estimated release)

---

## ✨ Features

### Currently Working ✅
- ✅ **Habits, Plans & Lists** - Three-way organization system
- ✅ **Smart Calendar** - Unified view across all categories
- ✅ **Recurring Todos** - Daily, weekly, monthly, yearly patterns
- ✅ **Subtasks** - Break down complex tasks
- ✅ **Focus Mode** - Distraction-free task completion
- ✅ **Reminders** - Local notifications for due tasks
- ✅ **Modern UI** - Card-based design with dark mode

### Coming Soon 🔄
- 🔄 **AI Generation** - Create todos with AI assistance
- 🔄 **Cloud Sync** - CloudKit synchronization
- 🔄 **Premium Features** - Subscriptions and themes
- 🔄 **Collaboration** - Share lists with others

---

## 📖 Documentation

- **[APP_FEATURES.md](./APP_FEATURES.md)** - Complete feature list, development plan, and progress
- **[SERVER_FEATURES.md](./SERVER_FEATURES.md)** - Backend/API documentation (if building server)
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and recent changes

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS 17.0+ |
| Language | Swift 5.9+ |
| UI | SwiftUI |
| Data | SwiftData (Core Data) |
| Storage | SQLite |
| Sync | CloudKit (planned) |
| Architecture | MVVM |

---

## 🎯 Getting Started

### Prerequisites
- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ device or simulator

### Quick Start

1. **Clone or open the project**
   ```bash
   cd /path/to/todoai
   open todoai.xcodeproj
   ```

2. **Build and run** (⌘R)
   - Select a simulator or device
   - Click Run or press ⌘R
   - App launches with sample data

3. **Start using**
   - Create Habits, Plans, or Lists
   - Add todos with due dates
   - View in Calendar
   - Try Focus Mode

---

## 📂 Project Structure

```
todoai/
├── README.md                    # This file
├── APP_FEATURES.md              # Full documentation
├── SERVER_FEATURES.md           # API/Backend docs
├── CHANGELOG.md                 # Version history
│
├── todoai.xcodeproj/            # Xcode project
│
└── todoai/                      # Source code
    ├── Models/                  # Data models
    ├── Views/                   # SwiftUI views
    │   ├── MainTabs/           # Main tab views
    │   ├── Todo/               # Todo-related views
    │   └── Focus/              # Focus mode
    ├── Services/               # Business logic
    └── todoaiApp.swift         # App entry point
```

---

## 🎨 App Overview

### Main Sections

**1. Habits** 🔄
- Track recurring activities
- Build consistent routines
- Examples: Exercise, Water intake, Reading

**2. Plans** 📋
- Goal-oriented activities
- Timeline-based tracking
- Examples: Study plan, Tour plan, Fitness plan

**3. Lists** ✅
- Collections and one-off tasks
- Quick checklists
- Examples: Shopping list, Watch list, Books to read

**4. Calendar** 📅
- Unified view of all todos
- Week navigation
- Filter by type and status
- Recurring todos on applicable dates

**5. Settings** ⚙️
- App preferences
- Account settings (coming soon)

---

## 💡 How It Works

### Recurring Todos (New!)
- Create a recurring todo (e.g., "Drink water" - daily)
- It appears on all matching dates
- Mark it complete on any date → creates a completion instance
- The recurring todo continues showing on future dates
- Completed dates are automatically filtered out

### Focus Mode
- Tap "Focus" on any todo (Plans/Lists only)
- Enter distraction-free full-screen mode
- Swipe to complete and move to next task
- Auto-advances through your day's tasks

---

## 📊 Development Status

**Current Sprint:** 10 of 27
**Completed:** Foundation, Core UI, Todo Management, Notifications
**Next Up:** AI Integration

See [APP_FEATURES.md](./APP_FEATURES.md) for detailed progress.

---

## 🏗 Business Model

**Freemium** - Free core features with premium upgrades

### Free (Forever)
- Unlimited todos, habits, plans, lists
- Calendar and reminders
- Focus Mode
- Basic themes

### Premium (Planned)
- Unlimited AI generations
- Cloud sync across devices
- Collaboration and sharing
- Advanced analytics
- Custom themes
- **$4.99/month or $39.99/year**

---

## 📝 Recent Updates

**v0.2 (Dec 6, 2025)**
- ✅ Fixed recurring todos functionality
- ✅ Improved completion instance tracking

**v0.1 (Dec 2-5, 2025)**
- ✅ Initial release
- ✅ Core features implemented
- ✅ Calendar with modern UI

See [CHANGELOG.md](./CHANGELOG.md) for full history.

---

## 🤝 Contributing

This is a proprietary project. For questions or feedback, contact the development team.

---

## 📄 License

Proprietary - All rights reserved

---

## 🔗 Links

- Documentation: [APP_FEATURES.md](./APP_FEATURES.md)
- Changelog: [CHANGELOG.md](./CHANGELOG.md)
- Server Docs: [SERVER_FEATURES.md](./SERVER_FEATURES.md)

---

**Built with ❤️ using Swift and SwiftUI**
