#!/bin/bash

# DailyDo File Verification Script
# This script checks if all necessary files are present

echo "🔍 DailyDo File Verification"
echo "=============================="
echo ""

TODOAI_DIR="todoai"
MISSING_FILES=0
TOTAL_FILES=0

# Function to check file
check_file() {
    TOTAL_FILES=$((TOTAL_FILES + 1))
    if [ -f "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ MISSING: $1"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
}

echo "📦 Checking Models..."
check_file "$TODOAI_DIR/Models/User.swift"
check_file "$TODOAI_DIR/Models/Subtype.swift"
check_file "$TODOAI_DIR/Models/TodoItem.swift"
check_file "$TODOAI_DIR/Models/Subtask.swift"
check_file "$TODOAI_DIR/Models/PurchasedProduct.swift"

echo ""
echo "🔢 Checking Enums..."
check_file "$TODOAI_DIR/Models/Enums/SubtypeType.swift"
check_file "$TODOAI_DIR/Models/Enums/RecurringType.swift"
check_file "$TODOAI_DIR/Models/Enums/ProductType.swift"

echo ""
echo "🎨 Checking ViewModels..."
check_file "$TODOAI_DIR/ViewModels/HabitsViewModel.swift"
check_file "$TODOAI_DIR/ViewModels/PlansViewModel.swift"
check_file "$TODOAI_DIR/ViewModels/ListsViewModel.swift"
check_file "$TODOAI_DIR/ViewModels/TodoViewModel.swift"

echo ""
echo "📱 Checking Views..."
check_file "$TODOAI_DIR/todoaiApp.swift"
check_file "$TODOAI_DIR/Views/MainTabs/MainTabView.swift"
check_file "$TODOAI_DIR/Views/MainTabs/HabitsView.swift"
check_file "$TODOAI_DIR/Views/MainTabs/PlansView.swift"
check_file "$TODOAI_DIR/Views/MainTabs/ListsView.swift"
check_file "$TODOAI_DIR/Views/MainTabs/CalendarView.swift"
check_file "$TODOAI_DIR/Views/MainTabs/SettingsView.swift"
check_file "$TODOAI_DIR/Views/Todo/SubtypeDetailView.swift"

echo ""
echo "=============================="
echo "📊 Summary:"
echo "   Total files expected: $TOTAL_FILES"
echo "   Files found: $((TOTAL_FILES - MISSING_FILES))"
echo "   Missing files: $MISSING_FILES"
echo ""

if [ $MISSING_FILES -eq 0 ]; then
    echo "✅ All files present! You're ready to create the Xcode project."
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode"
    echo "2. Create new iOS App project (SwiftUI + SwiftData)"
    echo "3. Add these files to your project"
    echo "4. Build and run!"
    echo ""
    echo "📖 See docs/FIX_BUILD_ERROR.md for detailed instructions"
else
    echo "⚠️  Some files are missing. This might cause build errors."
    echo ""
    echo "Please ensure all files are created before setting up Xcode project."
fi

echo ""
echo "🔧 Xcode Project Status:"
if [ -d "*.xcodeproj" ] 2>/dev/null; then
    echo "   ✅ Xcode project found"
    ls -d *.xcodeproj
else
    echo "   ⚠️  No Xcode project found (.xcodeproj)"
    echo "   You need to create one in Xcode first"
fi

echo ""
