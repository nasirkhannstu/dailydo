# DailyDo Backend Server & Features
## Architecture & Implementation Reference

**Version:** 1.0
**Last Updated:** December 5, 2025
**Purpose:** Complete backend feature specification and implementation guide

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Authentication System](#authentication-system)
3. [AI Todo Generation](#ai-todo-generation)
4. [AI Credits Management](#ai-credits-management)
5. [Subscription Management](#subscription-management)
6. [Sharing System](#sharing-system)
7. [Referral/Affiliate Program](#referralaffiliate-program)
8. [Purchase Validation](#purchase-validation)
9. [Analytics & Tracking](#analytics--tracking)
10. [Admin Dashboard](#admin-dashboard)
11. [Database Schema](#database-schema)
12. [API Endpoints](#api-endpoints)
13. [Technology Stack](#technology-stack)
14. [Implementation Phases](#implementation-phases)
15. [Security Considerations](#security-considerations)
16. [Scaling Strategy](#scaling-strategy)

---

## Architecture Overview

### Current Setup
- **iOS App:** SwiftUI + SwiftData (local storage)
- **Sync:** CloudKit (Apple devices only)
- **Backend:** None (to be built)

### Target Architecture
- **iOS App:** Primary client
- **Backend Server:** Node.js/Express + PostgreSQL
- **Data Flow:**
  - Todos stored locally (SwiftData) + synced via CloudKit
  - Backend handles: AI, Credits, Subscriptions, Sharing, Referrals
  - No full todo sync to backend (CloudKit handles this)

### Key Design Decisions
- Backend is NOT the source of truth for todos
- Backend manages: AI, monetization, sharing, analytics
- Sharing creates a snapshot copy in backend database
- Users remain authenticated across sessions via JWT

---

## Authentication System

### Purpose
Identify and authenticate users for AI credits, purchases, and premium features.

### Features
- Apple Sign In integration
- JWT token-based authentication
- Refresh token mechanism
- Multi-device session management
- Optional email/password (future)

### Implementation Approach
1. iOS app initiates Apple Sign In
2. App sends Apple identity token to backend
3. Backend validates token with Apple servers
4. Backend creates/fetches user record
5. Backend returns JWT access token + refresh token
6. iOS stores tokens securely in Keychain
7. Include JWT in Authorization header for all API calls

### User Flow
- First launch: Anonymous user OR prompt for Apple Sign In
- Sign in: Quick Apple authentication
- Session: JWT valid for 7 days, refresh token for 90 days
- Multi-device: Each device has own session, shared user account

### Data Stored
- User ID (UUID)
- Apple ID (unique identifier)
- Email (from Apple, optional)
- Name (from Apple)
- Profile data
- Created date
- Last login date

---

## AI Todo Generation

### Purpose
Generate structured todos from user prompts using OpenAI API.

### Features
- Natural language prompt processing
- Structured todo generation
- Credit deduction per generation
- Rate limiting
- Cost tracking
- Prompt history

### Implementation Approach
1. User enters prompt in iOS app
2. iOS sends authenticated request to backend
3. Backend validates user and checks credit balance
4. Backend constructs optimized prompt for OpenAI
5. Backend calls OpenAI API (GPT-4 Turbo or GPT-3.5)
6. Backend parses response into structured todos
7. Backend deducts 1 credit from user balance
8. Backend returns todos array to iOS
9. iOS app creates todos locally in SwiftData

### Prompt Engineering Strategy
- System prompt defines todo structure
- User prompt incorporated with context
- Request JSON response format
- Include subtype context (habit/plan/list)
- Handle clarifying questions (future enhancement)

### Cost Management
- Use GPT-3.5 Turbo for MVP (cheaper)
- Upgrade to GPT-4 for better quality
- Set max tokens limit per request
- Track costs per user for analytics
- Implement usage caps for free users

### Rate Limiting
- Free users: 5 generations total (initial credits)
- Premium users: Unlimited OR 100/month depending on tier
- Rate limit: 10 requests per minute per user
- Abuse detection via backend monitoring

---

## AI Credits Management

### Purpose
Track and manage AI generation credits per user.

### Features
- Credit balance tracking
- Credit deduction on AI usage
- Credit purchase via in-app purchase
- Referral credit rewards
- Transaction history
- Balance synchronization across devices

### Credit Rules
- New users: 5 free credits
- AI generation: -1 credit per use
- Credit packs: 10, 25, 50, 100 credits
- Referral reward: +10 credits when referred user subscribes
- Premium users: Option for unlimited OR large monthly allotment

### Implementation Approach
1. Backend maintains credit balance in database
2. Every AI request checks balance first
3. Reject request if insufficient credits
4. Deduct credit after successful generation
5. Record transaction in credit_transactions table
6. Purchases validated and credits added
7. iOS app fetches balance periodically
8. Display balance in settings

### Transaction Types
- initial_grant: 5 free credits on signup
- purchase: Bought credit pack
- usage: Used for AI generation
- referral_reward: Earned from referral
- admin_adjustment: Manual credit change by admin
- bonus: Promotional credits

### Audit Trail
- Every credit change logged
- Track balance before and after
- Include reason and metadata
- Prevent negative balances (server-side validation)
- Support refunds and adjustments

---

## Subscription Management

### Purpose
Manage premium subscriptions and unlock features.

### Features
- Monthly and yearly subscription tiers
- StoreKit receipt validation
- Subscription status sync
- Auto-renewal tracking
- Grace period handling
- Restore purchases
- Cross-device sync

### Subscription Tiers
- **Free:** 5 AI credits, basic features
- **Premium Monthly:** $4.99/month, unlimited AI OR 100 credits/month
- **Premium Yearly:** $39.99/year (33% savings)

### Premium Features
- Unlimited AI generations (or large monthly allowance)
- Sharing and collaboration (future)
- Advanced analytics (future)
- Priority support
- Ad-free experience
- Export functionality

### Implementation Approach
1. User initiates purchase in iOS app via StoreKit
2. iOS completes purchase and receives receipt
3. iOS sends receipt to backend for validation
4. Backend validates receipt with Apple servers
5. Backend records subscription in database
6. Backend updates user premium status
7. Backend returns success + expiry date
8. iOS unlocks premium features

### Receipt Validation
- Server-to-server receipt validation with Apple
- Verify signature and authenticity
- Check subscription status (active, expired, cancelled)
- Handle auto-renewal notifications via webhook
- Grace period handling (payment failed but still active)

### Status Sync
- Premium status checked on app launch
- Backend webhook receives Apple notifications
- Update subscription status in real-time
- Handle cancellations, refunds, upgrades

### Edge Cases
- Refunds: Remove premium status
- Cancellation: Keep premium until expiry date
- Upgrade: Apply immediately, prorate difference
- Downgrade: Apply at end of current period
- Expired: Grace period, then downgrade

---

## Sharing System

### Purpose
Allow users to share subtypes (habits/plans/lists) via read-only links with time-based expiry.

### Features
- Generate shareable link for any subtype
- Read-only access (no editing)
- Time-based expiry (1 hour, 1 day, 1 week, 1 month)
- Automatic deletion after expiry
- View counter
- Public access (no login required to view)

### Implementation Approach
1. User selects subtype to share in iOS app
2. User chooses expiry duration
3. iOS sends subtype ID and duration to backend
4. Backend copies subtype + todos snapshot to database
5. Backend generates unique share token
6. Backend calculates expiry timestamp
7. Backend returns shareable URL
8. iOS displays link (copy/send via share sheet)
9. Recipient opens link in browser or app
10. Backend serves read-only view of data
11. Link expires and data auto-deleted after duration

### Sharing Durations
- 1 hour: Quick temporary share
- 1 day: Short-term sharing
- 1 week: Moderate duration
- 1 month: Long-term sharing
- Custom: Admin can set custom durations

### Data Snapshot
- Complete copy of subtype metadata
- All associated todos (with details)
- All subtasks
- No user personal info included
- Frozen at time of sharing (no live updates)

### Auto-Delete Mechanism
- Cron job runs every hour
- Deletes expired shares from database
- Frees up storage
- Share links return 404 after expiry

### Security
- Unique random token (UUID or similar)
- No guessable patterns
- Rate limiting on share creation
- Rate limiting on share viewing
- Track view count for analytics

### Display
- Show expiry countdown ("Expires in 2 hours")
- Show view count (optional)
- Clean read-only interface
- Branded footer with DailyDo logo
- "Get DailyDo" call-to-action

---

## Referral/Affiliate Program

### Purpose
Incentivize user acquisition through referral rewards.

### Features
- Unique referral code per user
- Track referrals and conversions
- Award credits on successful conversion
- Referral dashboard
- Social sharing integration

### Referral Rules
- Each user gets unique referral code
- Code format: DAILYDO-XXXXX or custom
- Reward: 10 AI credits when referred user subscribes to premium
- Referred user bonus: 5 extra AI credits on signup
- No limit on referrals

### Implementation Approach
1. User views referral section in settings
2. Backend generates/fetches unique code
3. User shares code via social media, message, email
4. New user enters code during signup OR uses referral link
5. Backend records referral relationship (pending)
6. When referred user subscribes to premium:
   - Backend marks referral as converted
   - Backend awards 10 credits to referrer
   - Backend awards 5 bonus credits to referred user
   - Backend sends notification to referrer

### Tracking
- Referral codes stored in database
- Referral relationships tracked
- Conversion events logged
- Attribution window: 90 days
- Prevent self-referral
- Prevent duplicate referrals

### Analytics
- Total referrals per user
- Conversion rate
- Credits earned
- Most successful referrers (leaderboard)
- Referral source tracking (if using links)

### Fraud Prevention
- One code per user
- Cannot refer self
- Cannot create multiple accounts to abuse
- Manual review of suspicious activity
- Admin can revoke credits

---

## Purchase Validation

### Purpose
Validate in-app purchases securely on server-side to prevent fraud.

### Features
- StoreKit receipt validation
- Credit pack purchase validation
- Subscription purchase validation
- Restore purchases
- Refund handling
- Transaction history

### Purchase Types
- AI credit packs: 10, 25, 50, 100 credits
- Subscriptions: Monthly, yearly
- Customization packs (future): Colors, textures, themes

### Implementation Approach
1. User initiates purchase in iOS app
2. StoreKit processes payment
3. iOS receives receipt and transaction ID
4. iOS sends receipt to backend
5. Backend validates receipt with Apple servers
6. Backend verifies transaction authenticity
7. Backend checks if transaction already processed (idempotency)
8. Backend adds credits OR activates subscription
9. Backend records transaction in database
10. Backend returns success + new balance
11. iOS updates UI

### Receipt Validation
- Use Apple's verifyReceipt API
- Production vs sandbox environment
- Verify signature and bundle ID
- Check transaction ID uniqueness
- Validate product ID matches

### Idempotency
- Store processed transaction IDs
- Prevent double-crediting
- Handle retries gracefully
- Return same result for duplicate requests

### Restore Purchases
- iOS requests restore
- Backend fetches user's transaction history from Apple
- Backend reapplies any missing purchases
- Backend returns updated status

### Refund Handling
- Apple sends webhook notification for refunds
- Backend revokes credits OR subscription
- Handle partial refunds
- Negative balance handling (don't allow, or flag account)

---

## Analytics & Tracking

### Purpose
Track user behavior, app usage, and business metrics.

### Features
- User event tracking
- Daily/monthly active users
- AI usage statistics
- Revenue tracking
- Feature adoption
- Retention metrics
- Funnel analysis

### Events to Track
- user_signup
- user_login
- ai_generation_requested
- ai_generation_success
- ai_generation_failed
- credit_purchase
- subscription_started
- subscription_cancelled
- referral_code_shared
- referral_conversion
- share_link_created
- share_link_viewed
- todo_created
- subtype_created
- premium_feature_used

### Metrics Dashboard
- Daily Active Users (DAU)
- Monthly Active Users (MAU)
- DAU/MAU ratio (stickiness)
- New signups per day
- AI generations per day
- AI costs per day
- Revenue per day
- Premium conversion rate
- Referral conversion rate
- Retention (Day 1, 7, 30)

### Implementation Approach
- iOS sends events to backend API
- Backend stores events in database
- Aggregate events into daily/monthly stats
- Admin dashboard displays charts
- Export data for external analysis
- Integrate with Firebase Analytics (optional)

### Privacy
- Collect only necessary data
- Anonymize user IDs in reports
- GDPR compliant
- Allow users to opt-out
- Data retention policy (delete old events after 2 years)

---

## Admin Dashboard

### Purpose
Internal tool for monitoring, managing users, and viewing analytics.

### Features
- User management
- Credit adjustments
- Ban/suspend users
- View analytics
- Monitor AI costs
- View referral stats
- Manage shared links
- Support tools

### Admin Actions
- Search users by email, ID, or name
- View user details and activity
- Manually add/remove credits
- Activate/deactivate premium
- Ban/suspend accounts
- View user's todos (support only)
- Delete shared links
- Refund purchases
- View transaction history
- Export data

### Analytics Views
- Real-time dashboard
- User growth chart
- Revenue chart
- AI usage and costs
- Top referrers
- Recent signups
- Active subscriptions
- Churn rate

### Security
- Separate admin accounts
- Role-based access control (RBAC)
- Admin actions logged
- Require 2FA for admin access
- IP whitelist (optional)

---

## Database Schema

### Tables Overview

**users**
- id (UUID, primary key)
- apple_id (unique)
- email
- name
- ai_credit_balance (integer, default 5)
- is_premium (boolean, default false)
- premium_expires_at (timestamp, nullable)
- referral_code (unique string)
- created_at
- updated_at
- last_login_at

**credit_transactions**
- id (UUID, primary key)
- user_id (foreign key → users)
- amount (integer, can be negative)
- transaction_type (enum: initial_grant, purchase, usage, referral_reward, admin_adjustment, bonus)
- description (text)
- balance_after (integer)
- metadata (JSON)
- created_at

**subscriptions**
- id (UUID, primary key)
- user_id (foreign key → users)
- tier (enum: monthly, yearly)
- status (enum: active, cancelled, expired, grace_period)
- original_transaction_id (string, unique)
- started_at
- expires_at
- auto_renew (boolean)
- cancelled_at (nullable)
- created_at
- updated_at

**purchases**
- id (UUID, primary key)
- user_id (foreign key → users)
- product_id (string)
- transaction_id (string, unique)
- receipt_data (text)
- purchase_date
- validated_at
- amount (decimal)
- currency (string)
- created_at

**shared_subtypes**
- id (UUID, primary key)
- user_id (foreign key → users, owner)
- share_token (string, unique, indexed)
- subtype_snapshot (JSON)
- duration (enum: 1_hour, 1_day, 1_week, 1_month)
- created_at
- expires_at (indexed)
- view_count (integer, default 0)
- deleted_at (nullable)

**referral_codes**
- id (UUID, primary key)
- user_id (foreign key → users, unique)
- code (string, unique, indexed)
- created_at

**referrals**
- id (UUID, primary key)
- referrer_id (foreign key → users)
- referred_user_id (foreign key → users)
- status (enum: pending, converted, rewarded)
- converted_at (nullable)
- credits_awarded (integer)
- created_at
- updated_at

**analytics_events**
- id (UUID, primary key)
- user_id (foreign key → users, nullable for anonymous events)
- event_type (string, indexed)
- event_data (JSON)
- timestamp (indexed)
- created_at

**device_sessions**
- id (UUID, primary key)
- user_id (foreign key → users)
- device_id (string)
- platform (enum: ios, web, android, macos)
- device_name (string)
- refresh_token (string, hashed)
- last_active_at
- created_at

**admin_logs**
- id (UUID, primary key)
- admin_user_id (foreign key → users)
- action (string)
- target_user_id (foreign key → users, nullable)
- details (JSON)
- ip_address (string)
- created_at

**ai_generation_logs**
- id (UUID, primary key)
- user_id (foreign key → users)
- prompt (text)
- response (JSON)
- tokens_used (integer)
- cost (decimal)
- model (string)
- success (boolean)
- error_message (text, nullable)
- created_at

### Indexes
- users: apple_id, email, referral_code
- credit_transactions: user_id, created_at, transaction_type
- subscriptions: user_id, status, expires_at
- shared_subtypes: share_token, expires_at, user_id
- referrals: referrer_id, referred_user_id, status
- analytics_events: user_id, event_type, timestamp
- device_sessions: user_id, device_id

### Relationships
- users ← credit_transactions (one to many)
- users ← subscriptions (one to many)
- users ← purchases (one to many)
- users ← shared_subtypes (one to many)
- users ← referrals (one to many, as referrer and referred)
- users ← device_sessions (one to many)

---

## API Endpoints

### Authentication
- POST /api/auth/apple-signin
- POST /api/auth/refresh-token
- POST /api/auth/logout
- POST /api/auth/logout-all
- GET /api/auth/me

### AI Generation
- POST /api/ai/generate-todos
- GET /api/ai/history

### Credits
- GET /api/credits/balance
- GET /api/credits/transactions
- POST /api/credits/purchase (validate receipt)

### Subscriptions
- POST /api/subscriptions/verify
- GET /api/subscriptions/status
- POST /api/subscriptions/restore
- POST /api/subscriptions/cancel
- POST /api/subscriptions/webhook (Apple server notification)

### Sharing
- POST /api/share/create
- GET /api/share/:token (public, no auth)
- DELETE /api/share/:shareId
- GET /api/share/my-shares

### Referrals
- GET /api/referrals/my-code
- POST /api/referrals/apply-code
- GET /api/referrals/stats
- GET /api/referrals/leaderboard

### Purchases
- POST /api/purchases/validate
- POST /api/purchases/restore
- GET /api/purchases/history

### Analytics
- POST /api/analytics/event
- GET /api/analytics/user-insights

### Admin
- GET /api/admin/stats
- GET /api/admin/users
- GET /api/admin/users/:id
- POST /api/admin/users/:id/credits
- POST /api/admin/users/:id/ban
- POST /api/admin/users/:id/premium
- GET /api/admin/ai-costs
- GET /api/admin/referrals
- GET /api/admin/shares

### Health
- GET /api/health
- GET /api/version

---

## Technology Stack

### Backend Framework
**Option 1: Node.js + Express**
- Runtime: Node.js 20+
- Framework: Express.js
- Language: TypeScript
- ORM: Prisma
- Validation: Zod
- Testing: Jest

**Option 2: Python + FastAPI**
- Runtime: Python 3.11+
- Framework: FastAPI
- ORM: SQLAlchemy
- Validation: Pydantic
- Testing: Pytest

**Option 3: Go**
- Runtime: Go 1.21+
- Framework: Gin or Fiber
- ORM: GORM
- Testing: Go testing package

### Database
- **Primary:** PostgreSQL 15+
- **Caching:** Redis (optional, for scaling)
- **File Storage:** None needed (only text data)

### Authentication
- JWT (JSON Web Tokens)
- Apple Sign In SDK
- bcrypt for password hashing (if adding email/password)

### AI Integration
- OpenAI API (GPT-3.5 Turbo or GPT-4)
- Alternative: Anthropic Claude API

### Hosting Options
**Option 1: Railway**
- One-click deploy
- PostgreSQL included
- Free tier available
- Auto-scaling
- Cost: $5-50/month

**Option 2: Render**
- Similar to Railway
- Good free tier
- PostgreSQL included
- Cost: $7-50/month

**Option 3: Supabase**
- PostgreSQL + Auth + Storage
- Generous free tier
- Realtime capabilities
- Cost: $0-25/month (MVP)

**Option 4: DigitalOcean**
- VPS or App Platform
- More control
- Managed PostgreSQL
- Cost: $15-100/month

### Monitoring & Logging
- Logging: Winston (Node.js) or Python logging
- Error tracking: Sentry
- Uptime monitoring: UptimeRobot or Pingdom
- Performance: New Relic or Datadog (optional)

### CI/CD
- GitHub Actions
- Automated testing
- Automated deployment

---

## Implementation Phases

### Phase 1: MVP Backend (Sprint 12-14, Weeks 12-14)
**Goal:** AI generation and basic auth

**Tasks:**
- Set up backend project structure
- Set up PostgreSQL database
- Implement authentication (Apple Sign In + JWT)
- Create user registration/login
- Implement AI credits system
- Integrate OpenAI API
- Build AI generation endpoint
- Deploy to hosting (Railway/Render)
- Test iOS integration

**Deliverables:**
- Backend API running on server
- iOS app can authenticate users
- iOS app can generate AI todos
- Credits tracked properly

**Timeline:** 2-3 weeks

---

### Phase 2: Monetization (Sprint 17-19, Weeks 17-19)
**Goal:** Enable purchases and subscriptions

**Tasks:**
- Implement StoreKit receipt validation
- Build purchase validation endpoint
- Build subscription verification endpoint
- Add subscription status tracking
- Implement restore purchases
- Set up Apple webhook for subscription updates
- Build credit pack purchase flow
- Test all purchase flows

**Deliverables:**
- Users can purchase AI credits
- Users can subscribe to premium
- Receipts validated server-side
- Subscriptions sync across devices

**Timeline:** 2 weeks

---

### Phase 3: Sharing & Referrals (Week 20)
**Goal:** Enable sharing and referral program

**Tasks:**
- Implement sharing system
- Build share link generation
- Build public share view
- Implement auto-expiry cron job
- Implement referral code system
- Build referral tracking
- Build reward distribution
- Test sharing and referrals

**Deliverables:**
- Users can share subtypes via links
- Links expire automatically
- Referral program functional
- Credits awarded on conversions

**Timeline:** 1 week

---

### Phase 4: Analytics & Admin (Weeks 21-23)
**Goal:** Monitoring and management tools

**Tasks:**
- Implement event tracking
- Build analytics aggregation
- Create admin dashboard
- Implement user management
- Build admin actions (credits, bans)
- Add monitoring and logging
- Set up error tracking

**Deliverables:**
- Analytics dashboard
- Admin panel
- User management tools
- Monitoring in place

**Timeline:** 2 weeks

---

### Phase 5: Testing & Launch (Weeks 24-27)
**Goal:** Testing and production deployment

**Tasks:**
- Comprehensive API testing
- Load testing
- Security audit
- Performance optimization
- Bug fixes
- Production deployment
- Monitoring setup
- Documentation

**Deliverables:**
- Production-ready backend
- All features tested
- Monitoring active
- Documentation complete

**Timeline:** 3 weeks

---

## Security Considerations

### API Security
- All endpoints require HTTPS
- Rate limiting on all endpoints
- JWT token expiry (7 days access, 90 days refresh)
- Validate all inputs
- Sanitize user data
- Prevent SQL injection (use ORM)
- Prevent XSS attacks
- CORS configuration

### Authentication
- Apple Sign In verification
- JWT secret rotation
- Secure token storage (iOS Keychain)
- Session invalidation on logout
- Multi-device session management

### Data Protection
- Encrypt sensitive data at rest
- Hash tokens (refresh tokens)
- Never log sensitive data
- GDPR compliance
- Data retention policies
- Right to be forgotten (user deletion)

### OpenAI API
- API key stored as environment variable
- Never exposed to client
- Rate limiting to prevent abuse
- Cost monitoring and caps
- Prompt injection protection

### Payment Security
- Server-side receipt validation only
- Validate with Apple servers
- Check transaction uniqueness
- Prevent replay attacks
- Secure webhook endpoint

### Admin Access
- Separate admin accounts
- Role-based access control
- 2FA required
- Admin actions logged
- IP whitelist (optional)

---

## Scaling Strategy

### When to Scale
- Don't worry until 10,000+ users
- Monitor database performance
- Monitor API response times
- Monitor OpenAI API costs

### Database Scaling
- Add database indexes (already planned)
- Implement connection pooling
- Add read replicas (100K+ users)
- Partition large tables (1M+ users)
- Archive old data (soft deletes)

### API Scaling
- Horizontal scaling (multiple server instances)
- Load balancer
- Add Redis caching layer
- CDN for static assets (share view)
- Rate limiting per endpoint

### Cost Optimization
- Monitor OpenAI API costs per user
- Optimize prompts to reduce tokens
- Use GPT-3.5 instead of GPT-4 where possible
- Implement smart caching
- Set usage caps

### Performance
- Database query optimization
- API response caching
- Async processing for heavy tasks
- Background jobs for analytics
- Efficient pagination

---

## Cost Estimates

### MVP Phase (0-5K users)
- Hosting: $0-15/month
- Database: $0-10/month
- OpenAI API: $10-50/month
- Monitoring: $0 (free tier)
- **Total: $10-75/month**

### Growth Phase (5K-50K users)
- Hosting: $25-50/month
- Database: $15-30/month
- OpenAI API: $100-500/month
- Monitoring: $10-25/month
- **Total: $150-605/month**

### Scale Phase (50K-500K users)
- Hosting: $100-300/month
- Database: $50-150/month
- OpenAI API: $1,000-5,000/month
- Monitoring: $50-100/month
- CDN: $20-50/month
- **Total: $1,220-5,600/month**

### Revenue Context
- At 50K users with 3% premium conversion = 1,500 premium users
- 1,500 × $4.99 = $7,485/month revenue
- Backend costs = $1,220/month = 16% of revenue
- **Healthy margin**

---

## Deployment Checklist

### Before Launch
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Indexes created
- [ ] SSL certificate installed
- [ ] CORS configured
- [ ] Rate limiting enabled
- [ ] Logging configured
- [ ] Error tracking active
- [ ] Health check endpoint working
- [ ] Backup strategy in place
- [ ] Apple Sign In configured
- [ ] OpenAI API key working
- [ ] Apple webhook endpoint configured
- [ ] Admin user created
- [ ] Documentation complete

### Monitoring
- [ ] Uptime monitoring active
- [ ] Error alerts configured
- [ ] Cost alerts set up
- [ ] Database monitoring active
- [ ] API performance tracking

### Post-Launch
- [ ] Monitor error rates
- [ ] Monitor API latency
- [ ] Monitor OpenAI costs
- [ ] Check database performance
- [ ] Review user feedback
- [ ] Fix critical bugs
- [ ] Optimize slow queries

---

## Future Enhancements (Post-MVP)

### V1.1 (Month 6)
- Full todo sync to backend (replace CloudKit)
- Web application for desktop access
- Advanced AI features (clarifying questions)
- Batch AI generation

### V1.2 (Month 9)
- Collaborative sharing (read-write)
- Real-time sync via WebSockets
- Comments on shared todos
- Activity feed

### V1.3 (Year 2)
- Android app support
- Windows/Mac desktop apps
- Team workspaces (enterprise)
- Advanced analytics
- Custom AI models
- API for third-party integrations

---

## Conclusion

This document serves as the complete reference for DailyDo's backend architecture and features. All implementation details should follow this specification to ensure consistency and completeness.

**Key Takeaways:**
- Backend handles: AI, Credits, Subscriptions, Sharing, Referrals, Analytics
- Backend does NOT store todos (CloudKit handles sync)
- Security-first approach
- Scalable architecture
- Cost-effective at all stages
- Simple to start, easy to scale

**Next Steps:**
1. Review and approve this specification
2. Choose tech stack (Node.js/Python/Go)
3. Begin Sprint 12: Backend MVP development
4. Set up hosting and database
5. Implement authentication
6. Build AI generation endpoint
7. Test with iOS app

---

**Document Version History:**

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-12-05 | Initial complete specification | DailyDo Team |

---

**End of Server & Features Document**
