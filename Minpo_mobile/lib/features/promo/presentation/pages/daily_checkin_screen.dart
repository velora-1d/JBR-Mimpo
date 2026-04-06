import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'dart:ui';

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  final int totalDays = 30;
  int currentDayChecked = 5; // Placeholder
  bool hasCheckedInToday = false;
  bool _showConfetti = false;

  void _doCheckIn() {
    HapticFeedback.heavyImpact();
    setState(() {
      hasCheckedInToday = true;
      currentDayChecked++;
      _showConfetti = true;
    });

    // Reset confetti after animation
    Future.delayed(3.seconds, () {
      if (mounted) setState(() => _showConfetti = false);
    });

    AppFeedback.success(context, 'Check-in Berhasil! You got +10 Points.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.bgLight,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Daily Check-in',
                    style: GoogleFonts.sora(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  child: Column(
                    children: [
                      _buildHeroProgress(),
                      const SizedBox(height: 32),
                      _buildStreakCard(),
                      const SizedBox(height: 32),
                      _buildCalendarGrid(),
                      const SizedBox(height: 32),
                      _buildInfoReset(),
                      const SizedBox(height: 48),
                      _buildBottomAction(),
                      const SizedBox(height: 120), // Extra space for persistent NavigationBar
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Confetti Overlay
          if (_showConfetti)
            IgnorePointer(
              child: Center(
                child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 100)
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.easeOutBack)
                    .fadeOut(delay: 1.seconds)
                    .callback(callback: (_) {}),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=2070&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.1,
          colorFilter: ColorFilter.mode(AppColors.primary.withValues(alpha: 0.8), BlendMode.srcOver),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'APRIL 2024',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Icon(Icons.auto_awesome_rounded, color: Colors.white30),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Progres Klaim',
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$currentDayChecked',
                style: GoogleFonts.sora(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'DARI $totalDays HARI',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              AnimatedContainer(
                duration: 1.seconds,
                curve: Curves.easeOutExpo,
                height: 12,
                width: (MediaQuery.of(context).size.width - 112) * (currentDayChecked / totalDays),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6FFBBE), Color(0xFF00D1FF)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6FFBBE).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95), duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.amber.withValues(alpha: 0.05), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 28),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(0.8, 0.8), end: const Offset(1,1), duration: 1.seconds),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Berlanjut!',
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Kamu sudah check-in 5 hari berturut-turut.',
                  style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '🔥 5',
            style: GoogleFonts.jetBrainsMono(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.orange),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildCalendarGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kalender Aktivitas',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Riwayat', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: totalDays,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isCheckedIn = day <= currentDayChecked;
            final isToday = day == 6; // Placeholder for today

            return AnimatedContainer(
              duration: 400.ms,
              decoration: BoxDecoration(
                color: isCheckedIn 
                    ? AppColors.primary
                    : isToday 
                        ? Colors.white 
                        : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isToday ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isCheckedIn ? [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                ] : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isCheckedIn)
                    const Icon(Icons.check_rounded, color: Colors.white, size: 24).animate().scale(),
                  if (!isCheckedIn)
                    Text(
                      '$day',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isToday ? AppColors.primary : Colors.grey.shade400,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInfoReset() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_rounded, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Reset otomatis setiap tanggal 1 bulan baru. Pastikan tidak terlewat!',
              style: GoogleFonts.dmSans(color: Colors.blue.shade900, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: hasCheckedInToday ? null : _doCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade200,
                minimumSize: const Size(double.infinity, 72),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: Text(
                hasCheckedInToday ? 'ANDA SUDAH CHECK-IN' : 'AMBIL POIN HARI INI',
                style: GoogleFonts.sora(
                  fontSize: 16, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1,
                  color: hasCheckedInToday ? Colors.grey : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ).animate(target: hasCheckedInToday ? 0 : 1)
       .shimmer(duration: 2.seconds, delay: 1.seconds),
    );
  }
}

