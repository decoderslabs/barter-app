# Refactoring Implementation Guide

## Overview
This guide outlines the steps to consolidate repetitive code patterns in the Flutter app into reusable widgets and utilities.

## Priority Order

### Phase 1: High Impact (AppBar & Chips)
**Estimated time:** 2-3 hours
**Impact:** 10+ screens, ~200 lines reduction

1. Create `BarterAppBar` widget
2. Refactor all screens to use `BarterAppBar`
3. Create unified `BarterChip` widget
4. Refactor all chip implementations to use `BarterChip`

### Phase 2: Medium Impact (Cards & Labels)
**Estimated time:** 1-2 hours
**Impact:** 8+ screens, ~150 lines reduction

5. Create `BarterCard` base widget
6. Create `BarterSectionLabel` widget
7. Add `ResponsiveX` extension on BuildContext

### Phase 3: Low Impact (Utilities)
**Estimated time:** 1 hour
**Impact:** ~100 lines reduction

8. Refactor provider toggle methods
9. Add shadow helper to `BarterColors`

---

## Phase 1: AppBar Consolidation

### Step 1.1: Create BarterAppBar Widget
**File:** `lib/widgets/barter_appbar.dart`

**Features:**
- Configurable title (default: "BARTER" with brand styling)
- Configurable leading widget (default: back button or profile avatar)
- Configurable actions list
- Optional center title
- Optional backgroundColor override
- Consistent styling across all screens

**Implementation:**
```dart
class BarterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showBrandTitle;
  
  // ... implementation
}
```

### Step 1.2: Refactor Screens
Replace AppBar in:
- `creator_home_feed_screen.dart` (lines 33-73)
- `offer_detail_screen.dart` (lines 23-48)
- `proposal_compose_screen.dart` (lines 33-61)
- `creator_onboarding_flow_screen.dart` (lines 57-90)
- `proposal_sent_screen.dart` (lines 17-44)
- `rate_close_deal_screen.dart` (lines 29-45)
- `earn_membership_screen.dart` (lines 27-40)
- `sign_in_screen.dart` (add AppBar)
- `welcome_landing_screen.dart` (lines 20-77)
- `deal_room_screen.dart` (lines 39-90)

---

## Phase 2: Chip/Pill Consolidation

### Step 2.1: Create Unified BarterChip
**File:** `lib/widgets/barter_chips.dart` (extend existing)

**Variants:**
- `sort` - for sort chips (horizontal list)
- `filter` - for filter pills with dropdown icon
- `niche` - for niche selection with optional close button
- `platform` - for platform selection with icon
- `status` - for status badges
- `mini` - for small pills with icon

**Implementation:**
```dart
enum BarterChipVariant { sort, filter, niche, platform, status, mini }

class BarterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final BarterChipVariant variant;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showClose;
  // ...
}
```

### Step 2.2: Refactor Chip Implementations
Replace in:
- `creator_home_feed_screen.dart` (_FilterChip)
- `proposal_compose_screen.dart` (_PlatformChip)
- `earn_membership_screen.dart` (_MiniPill)
- `deal_room_screen.dart` (_StatusChip)
- Consolidate existing: BarterSortChip, BarterFilterPill, BarterNicheChip

---

## Phase 3: Card Widget Consolidation

### Step 3.1: Create BarterCard Base
**File:** `lib/widgets/barter_card.dart`

**Features:**
- Common decoration (surfaceContainerLowest, borderRadius 24, shadow)
- Configurable padding
- Optional border
- Configurable child

**Implementation:**
```dart
class BarterCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final VoidCallback? onTap;
  // ...
}
```

### Step 3.2: Refactor Card Implementations
Replace in:
- `brand_dashboard_screen.dart` (_DashboardCard)
- `brand_campaigns_screen.dart` (_CampaignCard)
- `brand_review_screen.dart` (_ApplicantCard)
- `rate_close_deal_screen.dart` (_SummaryCard)
- `earn_membership_screen.dart` (_TaskCard)

---

## Phase 4: Section Label Widget

### Step 4.1: Create BarterSectionLabel
**File:** `lib/widgets/barter_text.dart`

**Implementation:**
```dart
class BarterSectionLabel extends StatelessWidget {
  final String label;
  final Color? color;
  // ...
}
```

### Step 4.2: Refactor Section Labels
Replace in:
- `proposal_compose_screen.dart` (_SectionLabel)
- `offer_detail_screen.dart` (multiple instances)
- `earn_membership_screen.dart` (multiple instances)
- `rate_close_deal_screen.dart` (multiple instances)

---

## Phase 5: Responsive Layout Extension

### Step 5.1: Add ResponsiveX Extension
**File:** `lib/theme/responsive_extension.dart` (new)

**Implementation:**
```dart
extension ResponsiveX on BuildContext {
  bool get isWide => MediaQuery.sizeOf(this).width >= 900;
  bool get isMedium => MediaQuery.sizeOf(this).width >= 600;
}
```

### Step 5.2: Refactor Responsive Checks
Replace in:
- `brand_dashboard_screen.dart`
- `brand_campaigns_screen.dart`
- `brand_review_screen.dart`
- `deal_pipeline_screen.dart`
- `welcome_landing_screen.dart`

---

## Phase 6: Provider Toggle Refactoring

### Step 6.1: Refactor SessionNotifier
**File:** `lib/providers/app_providers.dart`

**Implementation:**
```dart
Set<String> _toggleSet(Set<String> current, String value) {
  final next = {...current};
  if (next.contains(value)) {
    next.remove(value);
  } else {
    next.add(value);
  }
  return next;
}

void toggleNiche(String n) {
  state = state.copyWith(selectedNiches: _toggleSet(state.selectedNiches, n));
}

void toggleInterest(String n) {
  state = state.copyWith(selectedInterests: _toggleSet(state.selectedInterests, n));
}

void toggleContentType(String n) {
  state = state.copyWith(selectedContentTypes: _toggleSet(state.selectedContentTypes, n));
}
```

---

## Phase 7: Shadow Helper

### Step 7.1: Add Shadow Helper to BarterColors
**File:** `lib/theme/barter_colors.dart`

**Implementation:**
```dart
BoxShadow editorialShadow({
  double opacity = 0.06,
  double blur = 24,
  double offset = 8,
}) =>
    BoxShadow(
      color: onBackground.withValues(alpha: opacity),
      blurRadius: blur,
      offset: Offset(0, offset),
    );
```

---

## Testing Checklist

After each phase:
- [ ] Run `flutter run` to ensure no compilation errors
- [ ] Navigate to affected screens to verify visual consistency
- [ ] Test responsive behavior on different screen sizes
- [ ] Verify hot reload works correctly
- [ ] Check for any broken widget tree references

---

## Rollback Plan

If any refactoring breaks the app:
1. Use `git checkout` to revert individual files
2. Focus on one phase at a time for easier rollback
3. Keep original implementations as comments until verified working
