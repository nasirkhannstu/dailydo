# DailyDo - Quick Reference Guide

Quick lookup for key project information.

## App Identity

**Name:** DailyDo: AI To Do and Lifestyle Planner
**Tagline:** Smart Tasks, Lists & Habits with AI
**Category:** Productivity, Lifestyle
**Platform:** iOS 17.0+

## Core Value Proposition

AI-powered todo management with three-tier organization (Habits, Plans, Lists) and beautiful customization.

## Target Users

- Busy professionals
- Students and learners
- Habit builders
- Project managers
- Lifestyle optimizers

## Key Features (MVP)

### Essential
1. Three categories: Habits, Plans, Lists
2. AI todo generation (OpenAI/Claude)
3. Calendar view (unified)
4. Reminders and notifications
5. AI credit system (5 free, then purchase)
6. Premium subscription
7. Referral program
8. CloudKit sync

### Premium Features
- Unlimited AI generations
- Sharing and collaboration
- Advanced analytics
- Export functionality

## Bottom Navigation (5 Tabs)

1. **Habits** - Recurring activities
2. **Plans** - Goal-oriented tasks
3. **Calendar** - Unified view
4. **Lists** - Collections
5. **Settings** - App preferences

## Data Model (Simplified)

```
User
  ├── Subtypes (Habits, Plans, Lists)
  │   └── TodoItems
  │       └── Subtasks
  ├── AI Credits
  └── Purchased Products
```

## Todo Item Fields

**Required:**
- title

**Optional:**
- description
- due_date, due_time
- completed (boolean)
- starred (boolean)
- reminder_enabled (boolean)
- recurring_type (none, daily, weekly, monthly, yearly)
- subtasks (array)
- ai_generated (boolean)

## AI Generation Flow

1. User enters prompt
2. AI asks clarifying questions (if needed)
3. User answers
4. AI generates todos
5. User reviews and confirms
6. 1 AI credit deducted

## Monetization

### Pricing
- **Monthly:** $4.99
- **Yearly:** $39.99 (save 33%)
- **AI Credits:** $2.99 (10) to $16.99 (100)
- **Colors/Textures:** $0.99 - $12.99

### Revenue Streams
1. Premium subscriptions (primary)
2. AI credit purchases
3. Customization purchases
4. One-time product purchases

## Pre-Created Subtypes

### Habits
- Water Intake (8 daily glasses)
- Walking (morning, lunch, evening)
- Reading (morning, lunch, night)
- Exercise (workout, stretching, yoga)
- Meditation (morning, midday, evening)

### Plans
- Study Plan (IELTS preparation)
- Weight Loss Plan (30 days)
- Travel Plan (Europe trip)

### Lists
- Shopping List
- Watch List (sci-fi movies)
- Book List (classics)
- Food to Try List

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI |
| Data | SwiftData (SQLite) |
| Sync | CloudKit |
| AI | OpenAI/Claude API |
| Payments | StoreKit 2 |
| Analytics | Firebase |
| Architecture | MVVM |

## Project Structure

```
DailyDo/
├── App/                 # App initialization
├── Models/              # SwiftData models
├── ViewModels/          # Business logic
├── Views/               # SwiftUI views
│   ├── Onboarding/
│   ├── MainTabs/
│   ├── Habits/
│   ├── Plans/
│   ├── Lists/
│   ├── Calendar/
│   ├── Todo/
│   ├── AI/
│   ├── Store/
│   └── Components/
├── Services/            # API, notifications, etc.
├── Utilities/           # Helpers, extensions
└── Resources/           # Assets, fonts
```

## Development Phases

1. **Foundation** (Weeks 1-3) - Setup, models
2. **Core UI** (Weeks 4-6) - Navigation, screens
3. **Todo Management** (Weeks 7-9) - CRUD
4. **Calendar & Reminders** (Weeks 10-11) - Calendar, notifications
5. **AI Integration** (Weeks 12-14) - AI API
6. **Auth & Sync** (Weeks 15-16) - CloudKit
7. **Monetization** (Weeks 17-19) - IAP
8. **Referral** (Week 20) - Referral system
9. **Onboarding** (Weeks 21-22) - Polish
10. **Testing** (Weeks 23-24) - QA
11. **Beta** (Weeks 25-26) - TestFlight
12. **Launch** (Week 27) - App Store

## Success Metrics (Month 1)

- 1,000 downloads
- 200 DAU
- 500 AI generations
- 30 premium conversions (3%)
- 4.0+ star rating
- 95%+ crash-free rate

## Key Risks

### Technical
- AI API downtime
- CloudKit sync conflicts
- Performance with large datasets

### Business
- Low user acquisition
- Poor premium conversion
- High AI API costs
- Competition

### Mitigation
- Fallback AI providers
- Robust conflict resolution
- Strong ASO and marketing
- Focus on AI differentiation

## App Store Optimization

**Keywords:**
- todo list, task manager, planner
- habit tracker, daily planner, AI
- productivity, organizer, reminders

**Screenshots Focus:**
- AI generation demo
- Calendar view
- Beautiful customization
- Collaboration features

## Referral Program

- Each user gets unique code
- Share with friends
- Referred user subscribes → Referrer gets 10 AI credits
- Referred user gets bonus (5 AI credits)

## Support Channels

- In-app help center
- Email support
- FAQ section
- Tutorial videos

## Legal

- Privacy Policy (required)
- Terms of Service (required)
- EULA (required)
- GDPR/CCPA compliant

## Cost Estimates

### One-Time
- Apple Developer: $99/year
- Design assets: $500-$1,000
- Legal docs: $1,000-$2,000
- **Total:** ~$1,700-$3,400

### Monthly (Post-Launch)
- AI API: $500-$2,000
- Firebase: $25-$100
- Support tools: $50-$100
- Marketing: $500-$2,000
- **Total:** ~$1,075-$4,200

## Revenue Projections (Conservative)

- **Month 1:** ~$270
- **Month 3:** ~$1,347
- **Month 6:** ~$3,494 (after Apple's 30% cut: ~$2,446)
- **Break-even:** Month 4-6

## Contact & Resources

**Documentation:**
- [Full Spec](../PROJECT_SPECIFICATION.md)
- [MVP Plan](../MVP_PLAN.md)

**External:**
- [Apple Developer](https://developer.apple.com)
- [SwiftUI Docs](https://developer.apple.com/xcode/swiftui/)
- [StoreKit Docs](https://developer.apple.com/documentation/storekit)

## Quick Commands

(To be added when Xcode project is created)

```bash
# Build
# Test
# Run on simulator
# Archive for distribution
```

---

**Last Updated:** 2025-12-02
**Version:** 1.0
