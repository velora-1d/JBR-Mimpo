import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbr_mimpo/core/cache/cache_manager.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
import 'package:jbr_mimpo/features/promo/presentation/pages/reward_detail_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/promo_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/promo_detail_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/notification_settings_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/delete_account_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/info_pages.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/address_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/support_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/installation_request_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/daily_checkin_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/membership/platinum_benefits_screen.dart';
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
                  builder: (context, state) {
                    final info = state.extra as Map<String, dynamic>? ?? {};
                    return InformationDetailScreen(info: info);
                  },
                ),
                GoRoute(
                  path: 'network-status',
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
                  builder: (context, state) {
                    final promoData = state.extra as Map<String, dynamic>? ?? {};
                    return PromoDetailScreen(promo: promoData);
                  },
                ),
                GoRoute(
                  path: 'daily-checkin',
                  builder: (context, state) => const DailyCheckinScreen(),
                ),
                GoRoute(
                  path: 'reward-detail',
                  builder: (context, state) {
                    final item = state.extra as Map<String, dynamic>? ?? {};
                    return RewardDetailScreen(item: item);
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
                  builder: (context, state) => const ReportIssueScreen(),
                ),
                GoRoute(
                  path: 'ticket-tracking',
                  builder: (context, state) => const TicketTrackingScreen(),
                ),
                GoRoute(
                  path: 'ticket-detail',
                  builder: (context, state) {
                    final ticket = state.extra as Map<String, dynamic>? ?? {};
                    return TicketDetailScreen(ticket: ticket);
                  },
                ),
                GoRoute(
                  path: 'chat-cs',
                  builder: (context, state) => const ChatCsScreen(),
                ),
                GoRoute(
                  path: 'faq',
                  builder: (context, state) => const FaqScreen(),
                ),
                GoRoute(
                  path: 'installation',
                  builder: (context, state) => const InstallationRequestScreen(),
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
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'security',
                  builder: (context, state) => const SecurityScreen(),
                ),
                GoRoute(
                  path: '2fa',
                  builder: (context, state) => const SecurityScreen(),
                ),
                GoRoute(
                  path: 'platinum-benefits',
                  builder: (context, state) => const PlatinumBenefitsScreen(),
                ),
                GoRoute(
                  path: 'change-password',
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
                GoRoute(
                  path: 'app-settings',
                  builder: (context, state) => const AppSettingsScreen(),
                ),
                GoRoute(
                  path: 'notifications-settings',
                  builder: (context, state) => const NotificationSettingsScreen(),
                ),
                GoRoute(
                  path: 'delete-account',
                  builder: (context, state) => const DeleteAccountScreen(),
                ),
                GoRoute(
                  path: 'address',
                  builder: (context, state) => const AddressScreen(),
                ),
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const InfoPage(title: 'Tentang JBR Minpo', type: 'about'),
                ),
                GoRoute(
                  path: 'tos',
                  builder: (context, state) => const InfoPage(title: 'Syarat & Ketentuan', type: 'tos'),
                ),
                GoRoute(
                  path: 'privacy',
                  builder: (context, state) => const InfoPage(title: 'Kebijakan Privasi', type: 'privacy'),
                ),
                GoRoute(
                  path: 'special-policy',
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
    HapticFeedback.lightImpact();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to flow under the navbar
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, 'Home', Icons.home_rounded, Icons.home_outlined),
                    _buildNavItem(1, 'Info', Icons.info_rounded, Icons.info_outline_rounded),
                    _buildNavItem(2, 'Promo', Icons.confirmation_num_rounded, Icons.confirmation_num_outlined),
                    _buildNavItem(3, 'Support', Icons.support_agent_rounded, Icons.support_agent_outlined),
                    _buildNavItem(4, 'Profil', Icons.person_rounded, Icons.person_outline_rounded),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = index == navigationShell.currentIndex;
    
    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0D9488)], // Sophisticated Emerald/Teal
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? Colors.white : Colors.grey.shade400,
              size: 24,
            ).animate(target: isSelected ? 1 : 0)
             .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms)
             .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.sora(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2, end: 0),
            ]
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
