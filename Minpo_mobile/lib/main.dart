import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbr_mimpo/core/cache/cache_manager.dart';
import 'package:jbr_mimpo/core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/login_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/otp_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/register_screen.dart';
import 'package:jbr_mimpo/features/auth/presentation/pages/splash_screen.dart';
import 'package:jbr_mimpo/features/home/presentation/pages/dashboard_screen.dart';
import 'package:jbr_mimpo/features/info/presentation/pages/information_detail_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/report_issue_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/ticket_tracking_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/ticket_detail_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/chat_cs_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/faq_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/profile_screen.dart';
import 'package:jbr_mimpo/features/usage/presentation/pages/package_detail_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/notification_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/security_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/app_settings_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/edit_profile_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/change_password_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/network_status_screen.dart';
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

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Global Router Configuration
final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const OnboardingScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const RegisterScreen()),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const OtpScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DashboardScreen()),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ForgotPasswordScreen()),
    ),
    GoRoute(
      path: '/info-detail',
      pageBuilder: (context, state) {
        final info = state.extra as Map<String, dynamic>;
        return buildPageWithDefaultTransition(context: context, state: state, child: InformationDetailScreen(info: info));
      },
    ),
    GoRoute(
      path: '/report-issue',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ReportIssueScreen()),
    ),
    GoRoute(
      path: '/ticket-tracking',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const TicketTrackingScreen()),
    ),
    GoRoute(
      path: '/ticket-detail',
      pageBuilder: (context, state) {
        final ticket = state.extra as Map<String, dynamic>;
        return buildPageWithDefaultTransition(context: context, state: state, child: TicketDetailScreen(ticket: ticket));
      },
    ),
    GoRoute(
      path: '/chat-cs',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ChatCsScreen()),
    ),
    GoRoute(
      path: '/faq',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const FaqScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ProfileScreen()),
    ),
    GoRoute(
      path: '/package-detail',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const PackageDetailScreen()),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const NotificationScreen()),
    ),
    GoRoute(
      path: '/security',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const SecurityScreen()),
    ),
    GoRoute(
      path: '/app-settings',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const AppSettingsScreen()),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const EditProfileScreen()),
    ),
    GoRoute(
      path: '/change-password',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ChangePasswordScreen()),
    ),
    GoRoute(
      path: '/network-status',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const NetworkStatusScreen()),
    ),
  ],
);


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'JBR Minpo',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
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
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        primaryColor: AppColors.primary,
        fontFamily: GoogleFonts.dmSans().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          titleTextStyle: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgDark.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            side: const BorderSide(color: AppColors.deep, width: 1),
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
      ),
      routerConfig: _router,
    );
  }
}

