import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/sign_in_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/welcome_landing_screen.dart';
import '../features/brand/analytics_dashboard_screen.dart';
import '../features/brand/brand_campaigns_screen.dart';
import '../features/brand/brand_dashboard_screen.dart';
import '../features/brand/brand_review_screen.dart';
import '../features/brand/brand_shell.dart';
import '../features/brand/create_offer/create_offer_details_screen.dart';
import '../features/brand/create_offer/create_offer_requirements_screen.dart';
import '../features/brand/create_offer/create_offer_rights_screen.dart';
import '../features/brand/deal_brief_screen.dart';
import '../features/brand/deal_pipeline_screen.dart';
import '../features/brand/drops_dashboard_screen.dart';
import '../features/brand/review_applications_screen.dart';
import '../features/brand/review_content_screen.dart';
import '../features/brand/review_proposal_screen.dart';
import '../features/creator/creator_home_feed_screen.dart';
import '../features/creator/creator_shell.dart';
import '../features/creator/creator_tab_placeholders.dart';
import '../features/creator/membership/earn_membership_screen.dart';
import '../features/creator/membership/pending_approval_screen.dart';
import '../features/creator/membership/submit_task_screen.dart';
import '../features/creator/onboarding/profile_completion_screen.dart';
import '../features/creator/onboarding/install_app_screen.dart';
import '../features/creator/onboarding/profile_setup_screen.dart';
import '../features/creator/onboarding/niche_selection_screen.dart';
import '../features/creator/onboarding/interests_selection_screen.dart';
import '../features/creator/onboarding/content_types_screen.dart';
import '../features/creator/onboarding/connect_socials_screen.dart';
import '../features/creator/profile/creator_profile_screen.dart';
import '../features/creator/profile/kpi_showcase_screen.dart';
import '../features/creator/offers/offer_detail_screen.dart';
import '../features/creator/offers/proposal_compose_screen.dart';
import '../features/creator/offers/proposal_sent_screen.dart';
import '../features/deal/deal_room_screen.dart';
import '../features/deal/review_content_screen.dart';
import '../features/deal/shipping_status_screen.dart';
import '../features/deal/request_revision_screen.dart';
import '../features/deal/rate_close_deal_screen.dart';
import '../features/deal/rate_colleague_screen.dart';
import '../features/deal/rating_confirmation_screen.dart';
import '../features/deal/shipping_address_entry_screen.dart';
import '../features/creator/counter_offer/counter_offer_screen.dart';
import '../features/brand/onboarding/brand_identity_screen.dart';
import '../features/brand/onboarding/offer_types_screen.dart';
import '../features/brand/onboarding/content_rights_screen.dart';
import '../features/notifications/notifications_center_screen.dart';
import '../features/notifications/notification_settings_screen.dart';
import '../features/brand/proposal_inbox_screen.dart';
import '../features/brand/drops/create_drops_campaign_screen.dart';
import '../features/brand/barter_value_engine_screen.dart';
import '../features/brand/creator_discovery_screen.dart';
import '../features/brand/brand_inbox_screen.dart';
import '../features/brand/profile/brand_profile_screen.dart';
import '../features/brand/profile/brand_manager_profile_screen.dart';
import '../features/creator/offers/offer_feed_screen.dart';
import '../features/help/help_center_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _creatorShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'creatorShell');
final GlobalKey<NavigatorState> _brandShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'brandShell');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeLandingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/brand',
        redirect: (context, state) => '/brand/dashboard',
      ),
      ShellRoute(
        navigatorKey: _brandShellNavigatorKey,
        builder: (context, state, child) {
          final path = state.uri.path;
          int selectedIndex = 0;
          if (path.startsWith('/brand/campaigns')) {
            selectedIndex = 1;
          } else if (path.startsWith('/brand/review')) {
            selectedIndex = 2;
          } else if (path.startsWith('/brand/pipeline')) {
            selectedIndex = 3;
          } else if (path.startsWith('/brand/analytics')) {
            selectedIndex = 4;
          } else if (path.startsWith('/brand/discover')) {
            selectedIndex = 5;
          } else if (path.startsWith('/brand/inbox')) {
            selectedIndex = 6;
          } else if (path.startsWith('/brand/profile')) {
            selectedIndex = 7;
          }
          return BrandShell(
            selectedIndex: selectedIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/brand/dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandDashboardScreen()),
          ),
          GoRoute(
            path: '/brand/campaigns',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandCampaignsScreen()),
          ),
          GoRoute(
            path: '/brand/review',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandReviewScreen()),
          ),
          GoRoute(
            path: '/brand/pipeline',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DealPipelineScreen()),
          ),
          GoRoute(
            path: '/brand/analytics',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AnalyticsDashboardScreen()),
          ),
          GoRoute(
            path: '/brand/drops',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DropsDashboardScreen()),
          ),
          GoRoute(
            path: '/brand/review/applications',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ReviewApplicationsScreen()),
          ),
          GoRoute(
            path: '/brand/review/proposal',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ReviewProposalScreen()),
          ),
          GoRoute(
            path: '/brand/review/content',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandReviewContentScreen()),
          ),
          GoRoute(
            path: '/brand/deal-brief',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DealBriefScreen()),
          ),
          GoRoute(
            path: '/brand/proposal-inbox',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProposalInboxScreen()),
          ),
          GoRoute(
            path: '/brand/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandProfileScreen()),
          ),
          GoRoute(
            path: '/brand/discover',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CreatorDiscoveryScreen()),
          ),
          GoRoute(
            path: '/brand/inbox',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BrandInboxScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/brand/discover/:creatorId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['creatorId']!;
          return CreatorDiscoveryScreen(key: ValueKey(id));
        },
      ),
      GoRoute(
        path: '/brand/manager/:managerId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['managerId']!;
          return BrandManagerProfileScreen(managerId: id);
        },
      ),
      GoRoute(
        path: '/brand/drops/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateDropsCampaignScreen(),
      ),
      GoRoute(
        path: '/brand/value-engine',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BarterValueEngineScreen(),
      ),
      GoRoute(
        path: '/brand/campaigns/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateOfferDetailsScreen(),
        routes: [
          GoRoute(
            path: 'requirements',
            builder: (context, state) => const CreateOfferRequirementsScreen(),
          ),
          GoRoute(
            path: 'rights',
            builder: (context, state) => const CreateOfferRightsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/brand/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        redirect: (context, state) {
          if (state.uri.path == '/brand/onboarding') return '/brand/onboarding/identity';
          return null;
        },
        routes: [
          GoRoute(
            path: 'identity',
            builder: (context, state) => const BrandIdentityScreen(),
          ),
          GoRoute(
            path: 'offer-types',
            builder: (context, state) => const OfferTypesScreen(),
          ),
          GoRoute(
            path: 'content-rights',
            builder: (context, state) => const ContentRightsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        redirect: (context, state) {
          if (state.uri.path == '/notifications') return '/notifications/center';
          return null;
        },
        routes: [
          GoRoute(
            path: 'center',
            builder: (context, state) => const NotificationsCenterScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/deal/rating-confirmation',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RatingConfirmationScreen(),
      ),
      GoRoute(
        path: '/deal/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => DealRoomScreen(
          dealId: state.pathParameters['id'],
        ),
        routes: [
          GoRoute(
            path: 'review',
            builder: (context, state) => const ReviewContentScreen(),
          ),
          GoRoute(
            path: 'shipping',
            builder: (context, state) => const ShippingStatusScreen(),
          ),
          GoRoute(
            path: 'revision',
            builder: (context, state) => const RequestRevisionScreen(),
          ),
          GoRoute(
            path: 'rate-close',
            builder: (context, state) => const RateCloseDealScreen(),
          ),
          GoRoute(
            path: 'rate-colleague',
            builder: (context, state) => RateColleagueScreen(
              dealId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: 'counter-offer',
            builder: (context, state) => const CounterOfferScreen(),
          ),
          GoRoute(
            path: 'rating-confirmation',
            builder: (context, state) => const RatingConfirmationScreen(),
          ),
          GoRoute(
            path: 'shipping-address',
            builder: (context, state) => ShippingAddressEntryScreen(
              dealId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/creator',
        redirect: (context, state) {
          if (state.uri.path == '/creator') return '/creator/feed';
          return null;
        },
        routes: [
          GoRoute(
            path: 'onboarding',
            redirect: (context, state) {
              if (state.uri.path == '/creator/onboarding') return '/creator/onboarding/profile';
              return null;
            },
            routes: [
              GoRoute(
                path: 'complete',
                builder: (context, state) => const ProfileCompletionScreen(),
              ),
              GoRoute(
                path: 'install-app',
                builder: (context, state) => const InstallAppScreen(),
              ),
              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileSetupScreen(),
              ),
              GoRoute(
                path: 'niche',
                builder: (context, state) => const NicheSelectionScreen(),
              ),
              GoRoute(
                path: 'interests',
                builder: (context, state) => const InterestsSelectionScreen(),
              ),
              GoRoute(
                path: 'content-types',
                builder: (context, state) => const ContentTypesScreen(),
              ),
              GoRoute(
                path: 'socials',
                builder: (context, state) => const ConnectSocialsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'offer/:id',
            redirect: (context, state) {
              final id = state.pathParameters['id'];
              return '/creator/offers/$id';
            },
          ),
          GoRoute(
            path: 'offers/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return OfferDetailScreen(offerId: id);
            },
          ),
          GoRoute(
            path: 'offers/:id/proposal',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProposalComposeScreen(offerId: id);
            },
          ),
          GoRoute(
            path: 'offers/:id/proposal/sent',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProposalSentScreen(offerId: id);
            },
          ),
          GoRoute(
            path: 'membership/earn',
            builder: (context, state) => const EarnMembershipScreen(),
          ),
          GoRoute(
            path: 'membership/pending',
            builder: (context, state) {
              final url = state.uri.queryParameters['url'];
              final taskTitle = state.uri.queryParameters['taskTitle'];
              return PendingApprovalScreen(
                submittedUrl: url,
                taskTitle: taskTitle,
              );
            },
          ),
          GoRoute(
            path: 'membership/submit/:taskId',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return SubmitTaskScreen(taskId: taskId);
            },
          ),
          ShellRoute(
            navigatorKey: _creatorShellNavigatorKey,
            builder: (context, state, child) {
              final path = state.uri.path;
              int selectedIndex = 0;
              if (path.startsWith('/creator/drops')) {
                selectedIndex = 1;
              } else if (path.startsWith('/creator/deals')) {
                selectedIndex = 2;
              } else if (path.startsWith('/creator/inbox')) {
                selectedIndex = 3;
              } else if (path.startsWith('/creator/profile')) {
                selectedIndex = 4;
              }
              return CreatorShell(
                selectedIndex: selectedIndex,
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: 'feed',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreatorHomeFeedScreen()),
              ),
              GoRoute(
                path: 'drops',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreatorDropsTabScreen()),
              ),
              GoRoute(
                path: 'deals',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreatorDealsTabScreen()),
              ),
              GoRoute(
                path: 'inbox',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreatorInboxTabScreen()),
              ),
              GoRoute(
                path: 'offer-feed',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: OfferFeedScreen()),
              ),
              GoRoute(
                path: 'profile',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreatorProfileScreen()),
              ),
              GoRoute(
                path: 'profile/kpi',
                builder: (context, state) => const KPIShowcaseScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpCenterScreen(),
      ),
    ],
  );
}
