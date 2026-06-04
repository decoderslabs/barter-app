# Barter App Implementation Plan

## Current Status (34 screens implemented)

### Completed Journeys

**Auth Journey**
- ✅ sign_in_screen.dart
- ✅ splash_screen.dart
- ✅ welcome_landing_screen.dart

**Brand Journey**
- ✅ analytics_dashboard_screen.dart
- ✅ brand_campaigns_screen.dart
- ✅ brand_dashboard_screen.dart
- ✅ brand_review_screen.dart
- ✅ deal_pipeline_screen.dart
- ✅ drops_dashboard_screen.dart
- ✅ review_applications_screen.dart
- ✅ review_content_screen.dart
- ✅ review_proposal_screen.dart
- ✅ deal_brief_screen.dart (added to router)

**Brand Onboarding Journey**
- ✅ brand_identity_screen.dart
- ✅ offer_types_screen.dart
- ✅ content_rights_screen.dart

**Brand Create Offer Journey**
- ✅ create_offer_details_screen.dart
- ✅ create_offer_requirements_screen.dart
- ✅ create_offer_rights_screen.dart

**Creator Journey**
- ✅ creator_home_feed_screen.dart
- ✅ earn_membership_screen.dart
- ✅ submit_task_screen.dart

**Creator Offers Journey**
- ✅ offer_detail_screen.dart
- ✅ proposal_compose_screen.dart
- ✅ proposal_sent_screen.dart
- ✅ creator_onboarding_flow_screen.dart (placeholder)

**Deal Journey**
- ✅ deal_room_screen.dart
- ✅ rate_close_deal_screen.dart
- ✅ rate_colleague_screen.dart
- ✅ request_revision_screen.dart
- ✅ review_content_screen.dart
- ✅ shipping_status_screen.dart

**Notifications Journey**
- ✅ notifications_center_screen.dart
- ✅ notification_settings_screen.dart

## Remaining Implementation (13+ screens)

### High Priority - Creator Onboarding Journey
- ⏳ creator_onboarding_niche_selection_screen.dart
- ⏳ creator_onboarding_interests_screen.dart
- ⏳ creator_onboarding_content_types_screen.dart
- ⏳ creator_onboarding_connect_socials_screen.dart
- ⏳ creator_onboarding_profile_setup_screen.dart

### High Priority - Creator Profile Journey
- ⏳ creator_profile_screen.dart
- ⏳ creator_profile_kpi_showcase_screen.dart

### High Priority - Creator Offer Discovery Journey
- ⏳ offer_feed_screen.dart
- ⏳ offer_details_match_score_screen.dart
- ⏳ proposal_inbox_screen.dart
- ⏳ draft_your_proposal_screen.dart

### High Priority - Counter Offer Flow
- ⏳ negotiate_counter_offer_screen.dart
- ⏳ counter_offer_flow_screen.dart

### Medium Priority - Brand Additional Screens
- ⏳ create_drops_campaign_1_screen.dart
- ⏳ create_drops_campaign_2_screen.dart
- ⏳ deal_pipeline_kanban_screen.dart

### Medium Priority - Barter Exchange Flow
- ⏳ barter_exchange_screen.dart
- ⏳ barter_value_engine_brand_view_screen.dart
- ⏳ barter_creator_exchange_flow_screen.dart
- ⏳ creator_brand_barter_onboarding_and_campaign_flow_screen.dart

### Low Priority - Additional Screens
- ⏳ rating_confirmation_screen.dart
- ⏳ shipping_address_entry_screen.dart
- ⏳ exclusive_entry_login_screen.dart
- ⏳ exclusive_entry_login_v2_screen.dart

## Mock JSON Data Requirements

### Existing Mock Data Location
`/Users/vaibhavnanda/Downloads/stitch_deal_room/barter_app/assets/mock/`

### Required Mock JSON Files

**Creator Onboarding**
- `creator_niches.json` - List of creator niches (Fashion, Beauty, Tech, etc.)
- `creator_interests.json` - List of interests/tags
- `creator_content_types.json` - Content type options (Instagram Reels, YouTube, TikTok, etc.)
- `creator_profile.json` - Profile setup data

**Creator Profile**
- `creator_profile_data.json` - Profile information, KPIs, stats
- `creator_kpi_metrics.json` - KPI showcase data

**Creator Offers**
- `offer_feed.json` - List of available offers
- `offer_detail.json` - Detailed offer information
- `proposal_inbox.json` - Received proposals
- `draft_proposals.json` - Draft proposals

**Counter Offer**
- `counter_offer_data.json` - Counter offer negotiation data

**Brand Additional**
- `drops_campaign_data.json` - Drops campaign information
- `deal_pipeline_data.json` - Kanban board data

**Barter Exchange**
- `barter_exchange_data.json` - Exchange flow data
- `value_engine_data.json` - Brand view data

## Implementation Order

### Phase 1: Mock JSON Setup
1. Create mock JSON files for all remaining screens
2. Ensure consistent data structure across files
3. Add proper TypeScript-like typing in comments

### Phase 2: Creator Onboarding (High Priority)
1. Implement niche selection screen
2. Implement interests selection screen
3. Implement content types selection screen
4. Implement social media connection screen
5. Implement profile setup screen
6. Wire routes in app_router.dart
7. Add mock JSON data integration

### Phase 3: Creator Profile (High Priority)
1. Implement profile screen
2. Implement KPI showcase screen
3. Wire routes
4. Add mock JSON data integration

### Phase 4: Creator Offer Discovery (High Priority)
1. Implement offer feed screen
2. Implement offer detail with match score
3. Implement proposal inbox
4. Implement draft proposal screen
5. Wire routes
6. Add mock JSON data integration

### Phase 5: Counter Offer Flow (High Priority)
1. Implement negotiate counter offer screen
2. Implement counter offer flow screen
3. Wire routes
4. Add mock JSON data integration

### Phase 6: Brand Additional Screens (Medium Priority)
1. Implement drops campaign screens
2. Implement deal pipeline kanban
3. Wire routes
4. Add mock JSON data integration

### Phase 7: Barter Exchange Flow (Medium Priority)
1. Implement exchange flow screens
2. Implement value engine brand view
3. Wire routes
4. Add mock JSON data integration

### Phase 8: Additional Screens (Low Priority)
1. Implement remaining screens
2. Wire routes
3. Add mock JSON data integration

### Phase 9: Final Validation
1. Run flutter analyze on entire codebase
2. Run flutter build web validation
3. Test all navigation flows
4. Verify mock JSON data integration

## Routing Structure

### Current Routes
- `/splash`
- `/welcome`
- `/sign-in`
- `/creator/onboarding`
- `/creator/feed`
- `/creator/offers/detail`
- `/creator/offers/compose`
- `/creator/offers/sent`
- `/creator/membership/earn`
- `/creator/membership/submit`
- `/brand/dashboard`
- `/brand/analytics`
- `/brand/campaigns`
- `/brand/deal-pipeline`
- `/brand/drops`
- `/brand/review/applications`
- `/brand/review/proposal`
- `/brand/review/content`
- `/brand/deal-brief`
- `/brand/onboarding` → redirects to `/brand/onboarding/identity`
- `/brand/onboarding/identity`
- `/brand/onboarding/offer-types`
- `/brand/onboarding/content-rights`
- `/brand/create` → redirects to `/brand/create/details`
- `/brand/create/details`
- `/brand/create/requirements`
- `/brand/create/rights`
- `/notifications` → redirects to `/notifications/center`
- `/notifications/center`
- `/notifications/settings`
- `/deal/:id`
- `/deal/:id/review`
- `/deal/:id/shipping`
- `/deal/:id/revision`
- `/deal/:id/rate-close`
- `/deal/:id/rate-colleague`

### Routes to Add
- `/creator/onboarding/niche`
- `/creator/onboarding/interests`
- `/creator/onboarding/content-types`
- `/creator/onboarding/socials`
- `/creator/onboarding/profile`
- `/creator/profile`
- `/creator/profile/kpi`
- `/creator/offers/feed`
- `/creator/offers/detail/:id`
- `/creator/offers/inbox`
- `/creator/offers/drafts`
- `/creator/counter-offer/:id`
- `/brand/drops/create`
- `/brand/drops/create/campaign`
- `/brand/exchange/:id`
- `/brand/value-engine`

## Implementation Guidelines

### Visual Fidelity
- Maintain 1:1 visual fidelity with Stitch HTML designs
- Use BarterColors theme extension for all colors
- Use Material Symbols icons
- Use Inter font via google_fonts

### Code Quality
- Follow existing code patterns
- Use shared widgets (BarterAppBar, BarterCard, BarterChip, etc.)
- Use Riverpod for state management
- Use GoRouter for navigation
- Add proper imports

### Data Integration
- Load mock JSON from assets/mock/ directory
- Use jsonDecode for parsing
- Handle null safety properly
- Provide fallback data

### Testing
- Run flutter analyze after each screen implementation
- Run flutter build web validation after completing journeys
- Test navigation flows manually
