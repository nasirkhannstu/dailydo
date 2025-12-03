# DailyDo - Setup Guide

This guide will help you set up and run the DailyDo iOS app project.

## What's Been Created

We've built the foundation of the DailyDo app with:

### ✅ Complete SwiftData Models
- `User.swift` - User account and profile
- `Subtype.swift` - Habits, Plans, and Lists containers
- `TodoItem.swift` - Individual tasks with full features
- `Subtask.swift` - Sub-items within todos
- `PurchasedProduct.swift` - In-app purchases tracking

### ✅ Enums
- `SubtypeType.swift` - Habit, Plan, List types
- `RecurringType.swift` - Recurring task patterns
- `ProductType.swift` - Product categories

### ✅ ViewModels (MVVM Architecture)
- `HabitsViewModel.swift`
- `PlansViewModel.swift`
- `ListsViewModel.swift`
- `TodoViewModel.swift`

### ✅ Views (Complete UI)
- `MainTabView.swift` - 5-tab navigation
- `HabitsView.swift` - Habits management
- `PlansView.swift` - Plans management
- `ListsView.swift` - Lists management
- `CalendarView.swift` - Unified calendar view
- `SettingsView.swift` - App settings
- `SubtypeDetailView.swift` - Todo list for each subtype

### ✅ App Entry Point
- `DailyDoApp.swift` - Main app with SwiftData container

## Project Structure

```
todoai/
├── Models/
│   ├── Enums/
│   │   ├── SubtypeType.swift
│   │   ├── RecurringType.swift
│   │   └── ProductType.swift
│   ├── User.swift
│   ├── Subtype.swift
│   ├── TodoItem.swift
│   ├── Subtask.swift
│   └── PurchasedProduct.swift
│
├── ViewModels/
│   ├── HabitsViewModel.swift
│   ├── PlansViewModel.swift
│   ├── ListsViewModel.swift
│   └── TodoViewModel.swift
│
├── Views/
│   ├── MainTabs/
│   │   ├── MainTabView.swift
│   │   ├── HabitsView.swift
│   │   ├── PlansView.swift
│   │   ├── ListsView.swift
│   │   ├── CalendarView.swift
│   │   └── SettingsView.swift
│   └── Todo/
│       └── SubtypeDetailView.swift
│
├── Services/           (empty - for future)
├── Utilities/          (empty - for future)
├── Assets.xcassets/    (existing)
└── DailyDoApp.swift    (main entry point)
```

## Setup Instructions

### Option 1: Add Files to Existing Xcode Project (Recommended)

If you already have a `todoai.xcodeproj`:

1. **Open your existing project in Xcode**
   ```bash
   open todoai.xcodeproj
   ```

2. **Add the new files to your project**
   - In Xcode, right-click on the project navigator
   - Select "Add Files to 'todoai'..."
   - Navigate to the `todoai/` folder
   - Select all the new Swift files and folders
   - Make sure "Copy items if needed" is checked
   - Click "Add"

3. **Update the app target**
   - Make sure all new files are included in the target
   - Check Target Membership in File Inspector

4. **Build and Run**
   - Press `Cmd + B` to build
   - Press `Cmd + R` to run on simulator

### Option 2: Create New Xcode Project

If you don't have an Xcode project yet:

1. **Open Xcode**

2. **Create a new iOS App project**
   - File → New → Project
   - Select "iOS" → "App"
   - Click "Next"

3. **Configure the project**
   - Product Name: `DailyDo`
   - Team: Your team
   - Organization Identifier: com.yourcompany
   - Interface: **SwiftUI**
   - Storage: **SwiftData**
   - Language: Swift
   - Click "Next"

4. **Save in the todoai folder**
   - Navigate to `/Users/nasirkhan/Desktop/IOS/todoai`
   - Click "Create"

5. **Replace generated files**
   - Delete the default `ContentView.swift`
   - Delete the default app file
   - Use our `DailyDoApp.swift` instead

6. **Add all our files**
   - Drag and drop all folders (Models, ViewModels, Views) into the project
   - Ensure "Copy items if needed" is checked
   - Ensure the target is selected

7. **Build and Run**
   - Press `Cmd + B` to build
   - Press `Cmd + R` to run

## Verifying the Setup

After building, you should be able to:

### ✅ Test Habits Tab
1. Open the Habits tab
2. Tap "+" to create a new habit
3. Enter a name like "Morning Walk"
4. Tap "Add"
5. Tap on the habit to view details
6. Add todos to the habit

### ✅ Test Plans Tab
1. Open the Plans tab
2. Create a plan like "Study Plan"
3. Add todos to the plan

### ✅ Test Lists Tab
1. Open the Lists tab
2. Create a list like "Shopping List"
3. Add items to the list

### ✅ Test Calendar Tab
1. Open the Calendar tab
2. Select a date
3. Add todos with due dates to see them appear

### ✅ Test Todo Features
- Create a todo
- Mark it complete
- Star a todo
- Add a due date
- Add a description
- Delete a todo
- Swipe actions (star/delete)

## Common Issues & Solutions

### Issue: Build Errors

**Solution:**
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`
- Make sure iOS deployment target is set to iOS 17.0+

### Issue: SwiftData Errors

**Solution:**
- Ensure you selected "SwiftData" when creating the project
- Check that all models are imported correctly
- Verify the `modelContainer` is set up in `DailyDoApp.swift`

### Issue: Missing Files

**Solution:**
- Re-add files to the project
- Check Target Membership in File Inspector
- Ensure files are in the correct group/folder

### Issue: Preview Not Working

**Solution:**
- Click "Resume" in the preview pane
- Try `Cmd + Option + P` to refresh preview
- Make sure the preview device is set to iPhone

## Next Steps

After the project is running, you can:

1. **Add Pre-Populated Data**
   - Create a `DataSeederService` to add sample habits, plans, and lists
   - Refer to `PROJECT_SPECIFICATION.md` for pre-created subtype examples

2. **Implement AI Integration**
   - Set up OpenAI or Claude API
   - Create `AIService.swift`
   - Build AI generation views

3. **Add Notifications**
   - Implement `NotificationService.swift`
   - Request permissions
   - Schedule local notifications

4. **Implement In-App Purchases**
   - Set up StoreKit 2
   - Configure products in App Store Connect
   - Create `StoreKitService.swift`

5. **Add CloudKit Sync**
   - Enable CloudKit capability
   - Implement `CloudSyncService.swift`

6. **Polish UI**
   - Add animations
   - Create custom components
   - Implement empty states
   - Add loading indicators

## Project Status

**Current Sprint:** Foundation Complete ✅

**Completed:**
- ✅ Project structure
- ✅ SwiftData models
- ✅ ViewModels
- ✅ Main UI (5 tabs)
- ✅ Todo CRUD operations
- ✅ Calendar view
- ✅ Settings placeholder

**Next Sprint:** Todo Management Enhancements
- [ ] Add subtask management
- [ ] Implement recurring todos
- [ ] Add search and filter
- [ ] Implement todo detail view
- [ ] Add color/flag customization

## Resources

- **Full Spec:** [PROJECT_SPECIFICATION.md](../PROJECT_SPECIFICATION.md)
- **MVP Plan:** [MVP_PLAN.md](../MVP_PLAN.md)
- **Quick Reference:** [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
- **Apple Docs:** [SwiftData](https://developer.apple.com/documentation/swiftdata) | [SwiftUI](https://developer.apple.com/xcode/swiftui/)

## Support

If you encounter any issues:
1. Check the error message in Xcode
2. Review the setup steps above
3. Consult the documentation files
4. Check Apple's official documentation

---

**Happy Coding!** 🚀

The foundation is solid. Now it's time to build amazing features!
