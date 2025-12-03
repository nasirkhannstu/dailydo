# DailyDo: AI To Do and Lifestyle Planner

An AI-powered iOS productivity app for managing tasks, building habits, and organizing daily life.

## Project Status

**Current Phase:** Planning & Documentation
**Version:** MVP Development
**Platform:** iOS 17.0+

## Documentation

### Core Documents
- **[PROJECT_SPECIFICATION.md](./PROJECT_SPECIFICATION.md)** - Complete project requirements and features
- **[MVP_PLAN.md](./MVP_PLAN.md)** - Phased development roadmap and sprint breakdown

### Folder Structure
```
todoai/
├── README.md                    # This file
├── PROJECT_SPECIFICATION.md     # Full project spec
├── MVP_PLAN.md                  # MVP development plan
├── docs/                        # Additional documentation
├── design/                      # UI/UX design files
└── research/                    # Research and analysis
```

## Project Overview

DailyDo is a freemium iOS app that combines traditional todo list functionality with AI-powered task generation. Users can organize their activities across three main categories:

### Core Features
1. **Habits** - Track recurring activities and build consistent routines
2. **Plans** - Organize goal-oriented activities with timelines
3. **Lists** - Manage collections and one-off tasks

### Key Differentiators
- AI-powered todo generation with contextual questions
- Unified calendar view across all categories
- Customizable visual themes (colors, textures, screens)
- Referral program with AI credit rewards
- Collaborative sharing (premium feature)

## Technology Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS 17.0+ |
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Data Persistence | SwiftData (SQLite) |
| Cloud Sync | CloudKit |
| Architecture | MVVM |
| AI API | OpenAI GPT-4 or Claude |
| Analytics | Firebase Analytics |
| Crash Reporting | Firebase Crashlytics |
| In-App Purchases | StoreKit 2 |

## Business Model

**Freemium:** Free core features with premium upgrades

### Free Features
- Unlimited todos, habits, plans, and lists
- Basic colors and themes
- Calendar view
- Reminders and notifications
- 5 free AI credits

### Premium Features
- Unlimited AI generations
- Sharing and collaboration
- Advanced analytics
- Export functionality
- Priority support
- Ad-free experience

### Monetization
- Premium subscription: $4.99/month or $39.99/year
- AI credit packs: $2.99 - $16.99
- Color/texture/theme packs: $0.99 - $12.99
- Referral rewards: 10 credits per referred premium user

## Development Timeline

**MVP Development:** 27 weeks (6-7 months)

### Key Milestones
- **Weeks 1-3:** Foundation (project setup, data models)
- **Weeks 4-6:** Core UI (navigation, main screens)
- **Weeks 7-11:** Todo management & calendar
- **Weeks 12-16:** AI integration & sync
- **Weeks 17-20:** Monetization & referrals
- **Weeks 21-24:** Onboarding, polish, testing
- **Weeks 25-26:** Beta testing
- **Week 27:** App Store launch

## Getting Started

### Prerequisites
- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ device or simulator
- Apple Developer Account (for deployment)

### Setup

**📖 See [docs/SETUP_GUIDE.md](./docs/SETUP_GUIDE.md) for detailed instructions**

**Quick Start:**
1. Open Xcode
2. Create new iOS App project with SwiftUI + SwiftData
3. Add all files from `todoai/` folder to the project
4. Build and run (⌘R)

### Current Status

✅ **Foundation Complete (Sprint 1-3)**
- SwiftData models created
- MVVM architecture implemented
- 5-tab navigation built
- Todo CRUD functionality working
- Calendar view functional

### What's Working

- ✅ Create habits, plans, and lists
- ✅ Add todos to any category
- ✅ Mark todos complete/incomplete
- ✅ Star important todos
- ✅ Set due dates and times
- ✅ View todos on calendar
- ✅ Delete todos and subtypes
- ✅ Swipe actions

## Team

(Team roles and contacts to be added)

## License

Proprietary - All rights reserved

## Support

For questions or issues:
- Email: support@dailydo.app (to be set up)
- Documentation: See docs/ folder

## Version History

| Version | Date | Status |
|---------|------|--------|
| 0.1 | 2025-12-02 | Planning phase |

---

**Next Steps:**
1. Review and approve project specification
2. Review and approve MVP plan
3. Assemble development team
4. Set up Xcode project
5. Begin Sprint 1

See [MVP_PLAN.md](./MVP_PLAN.md) for detailed development roadmap.
