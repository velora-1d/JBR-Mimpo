import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbr_mimpo/core/cache/cache_manager.dart';

import 'package:go_router/go_router.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/login_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/otp_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/register_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/splash_screen.dart';
import 'package:jbr_mimpo/features/home/presentation/pages/dashboard_screen.dart';
import 'package:jbr_mimpo/features/info/presentation/pages/information_screen.dart';
import 'package:jbr_mimpo/features/info/presentation/pages/information_detail_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/report_issue_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/ticket_tracking_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/ticket_detail_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/chat_cs_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/faq_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/profile_screen.dart';
import 'package:jbr_mimpo/features/usage/presentation/pages/package_detail_screen.dart';
import 'package:jbr_mimpo/features/usage/presentation/pages/upgrade_package_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/notification_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/security_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/app_settings_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/edit_profile_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/change_password_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/network_status_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/promo_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/promo_detail_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/notification_settings_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/delete_account_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/info_pages.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/address_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/support_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Cache Manager (Hive)
  await CacheManager().init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Global Navigator Keys for Shell
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorInfoKey = GlobalKey<NavigatorState>(debugLabel: 'info');
final _shellNavigatorPromoKey = GlobalKey<NavigatorState>(debugLabel: 'promo');
final _shellNavigatorSupportKey = GlobalKey<NavigatorState>(debugLabel: 'support');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

// Global Router Configuration
final _router = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // 1. Auth & Initial Routes (Non-Shell)
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/otp',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // 2. Main Application Shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'package-detail',
                  builder: (context, state) => const PackageDetailScreen(),
                ),
                GoRoute(
                  path: 'upgrade-package',
                  builder: (context, state) => const UpgradePackageScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationScreen(),
                ),
              ],
            ),
          ],
        ),
        // Tab 2: Info (Information List)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorInfoKey,
          routes: [
            GoRoute(
              path: '/info',
              builder: (context, state) => const InformationScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final info = state.extra as Map<String, dynamic>? ?? {};
                    return InformationDetailScreen(info: info);
                  },
                ),
                GoRoute(
                  path: 'network-status',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NetworkStatusScreen(),
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Promo
        StatefulShellBranch(
          navigatorKey: _shellNavigatorPromoKey,
          routes: [
            GoRoute(
              path: '/promo',
              builder: (context, state) => const PromoScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final promoData = state.extra as Map<String, dynamic>? ?? {};
                    return PromoDetailScreen(promo: promoData);
                  },
                ),
              ],
            ),
          ],
        ),
        // Tab 4: Support (Support Hub)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSupportKey,
          routes: [
            GoRoute(
              path: '/support',
              builder: (context, state) => const SupportScreen(),
              routes: [
                GoRoute(
                  path: 'report-issue',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ReportIssueScreen(),
                ),
                GoRoute(
                  path: 'ticket-tracking',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TicketTrackingScreen(),
                ),
                GoRoute(
                  path: 'ticket-detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final ticket = state.extra as Map<String, dynamic>? ?? {};
                    return TicketDetailScreen(ticket: ticket);
                  },
                ),
                GoRoute(
                  path: 'chat-cs',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ChatCsScreen(),
                ),
                GoRoute(
                  path: 'faq',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const FaqScreen(),
                ),
              ],
            ),
          ],
        ),
        // Tab 5: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit-profile',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'security',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SecurityScreen(),
                ),
                GoRoute(
                  path: '2fa',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SecurityScreen(),
                ),
                GoRoute(
                  path: 'change-password',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
                GoRoute(
                  path: 'app-settings',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AppSettingsScreen(),
                ),
                GoRoute(
                  path: 'notifications-settings',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NotificationSettingsScreen(),
                ),
                GoRoute(
                  path: 'delete-account',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const DeleteAccountScreen(),
                ),
                GoRoute(
                  path: 'address',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AddressScreen(),
                ),
                GoRoute(
                  path: 'about',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InfoPage(title: 'Tentang JBR Minpo', type: 'about'),
                ),
                GoRoute(
                  path: 'tos',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InfoPage(title: 'Syarat & Ketentuan', type: 'tos'),
                ),
                GoRoute(
                  path: 'privacy',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InfoPage(title: 'Kebijakan Privasi', type: 'privacy'),
                ),
                GoRoute(
                  path: 'special-policy',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InfoPage(title: 'Kebijakan Khusus', type: 'special'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// Custom Scaffold with Bottom Navigation Bar
class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.sora(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded), label: 'Info'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_rounded), label: 'Promo'),
            BottomNavigationBarItem(icon: Icon(Icons.support_agent_rounded), label: 'Support'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'JBR Minpo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgLight,
        primaryColor: AppColors.primary,
        fontFamily: GoogleFonts.dmSans().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          titleTextStyle: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            textStyle: GoogleFonts.sora(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.dmSans(color: AppColors.textSecondary),
        ),
      ),
      routerConfig: _router,
    );
  }
}
