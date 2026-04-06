import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:jbr_mimpo/core/widgets/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/promo_provider.dart';
import '../../domain/models/promo_model.dart';

class PromoScreen extends ConsumerStatefulWidget {
  const PromoScreen({super.key});

  @override
  ConsumerState<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends ConsumerState<PromoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header with TabBar
            _buildHeaderWithTabs(),

            // 2. Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildWithRefresh(_buildPromoAktifTab()),
                  _buildWithRefresh(_buildRewardSayaTab()),
                  _buildWithRefresh(_buildUndianTab()),
                  _buildWithRefresh(_buildReferralTab()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithRefresh(Widget child) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ref.read(promoListProvider.notifier).refresh();
      },
      child: child,
    );
  }

  Widget _buildHeaderWithTabs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo & Reward',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Ultra Premium Search Bar (Modern Solid)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: TextField(
              style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari promo menarik...',
                hintStyle: GoogleFonts.dmSans(color: Colors.grey.withValues(alpha: 0.4), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 18),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.05), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            onTap: (index) {
              HapticFeedback.selectionClick();
            },
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.only(right: 24),
            tabs: const [
              Tab(text: 'Promo Aktif'),
              Tab(text: 'Reward Saya'),
              Tab(text: 'Undian'),
              Tab(text: 'Referral'),
            ],
          ),
        ],
      ),
    );
  }

  // --- Sub-Tab 1: Promo Aktif (Halaman 12) ---
  Widget _buildPromoAktifTab() {
    final promoAsync = ref.watch(promoListProvider);

    return promoAsync.when(
      data: (promos) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: promos.length + 1,
        itemBuilder: (context, index) {
          if (index == promos.length) return const SizedBox(height: 80);
          final promo = promos[index];
          return _buildPromoCard(promo: promo);
        },
      ),
      loading: () => ListView(
        padding: const EdgeInsets.all(20),
        children: List.generate(3, (index) => const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ShimmerLoader(width: double.infinity, height: 320, borderRadius: 24),
        )),
      ),
      error: (err, stack) => Center(child: Text('Gagal memuat promo: $err')),
    );
  }

  // --- Sub-Tab 2: Reward Saya (Halaman 13 Placeholder) ---
  Widget _buildRewardSayaTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSaldoPoinCard(),
        const SizedBox(height: 32),
        _buildLeaderboardSection(),
        const SizedBox(height: 32),
        _buildTukarPoinGrid(),
        const SizedBox(height: 32),
        _buildDailyCheckInCard(),
        const SizedBox(height: 80),
      ],
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildSaldoPoinCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF047857)], // Emerald 700
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.generating_tokens,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'TOTAL SALDO KAMU',
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '2,500',
                style: GoogleFonts.sora(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Poin',
                style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6FFBBE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  AppFeedback.info(context, 'Fitur riwayat segera hadir');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Riwayat',
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cara Dapat Poin', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                            title: const Text('Daily Check-in'),
                            subtitle: const Text('+10 Poin per hari'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.people, color: AppColors.primary),
                            title: const Text('Undang Teman'),
                            subtitle: const Text('+500 Poin per referal berhasil'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.pop(),
                            child: const Text('Tutup'),
                          )
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF6FFBBE,
                  ).withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Cara Dapat',
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Leaderboard Minggu Ini',
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'LIHAT SEMUA',
              style: GoogleFonts.sora(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rank 2
              _buildLeaderboardItem(
                name: 'Andra R.',
                points: '1,820 pts',
                rank: 2,
                image: 'https://i.pravatar.cc/150?img=11',
                isFirst: false,
              ),
              const SizedBox(width: 12),
              // Rank 1
              _buildLeaderboardItem(
                name: 'Siska W.',
                points: '2,150 pts',
                rank: 1,
                image: 'https://i.pravatar.cc/150?img=5',
                isFirst: true,
              ),
              const SizedBox(width: 12),
              // Rank 3
              _buildLeaderboardItem(
                name: 'Budi T.',
                points: '1,640 pts',
                rank: 3,
                image: 'https://i.pravatar.cc/150?img=15',
                isFirst: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required String name,
    required String points,
    required int rank,
    required String image,
    required bool isFirst,
  }) {
    return Expanded(
      child: Container(
        height: isFirst ? 160 : 130, // To make the middle one taller
        decoration: BoxDecoration(
          color: isFirst
              ? Theme.of(context).cardColor
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: isFirst
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                )
              : null,
          boxShadow: isFirst
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: isFirst ? -24 : -20,
              child: Container(
                width: isFirst ? 64 : 48,
                height: isFirst ? 64 : 48,
                padding: EdgeInsets.all(isFirst ? 3 : 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: isFirst
                      ? Border.all(color: const Color(0xFF6FFBBE), width: 3)
                      : Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                          width: 2,
                        ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerLoader(
                      width: 40,
                      height: 40,
                      borderRadius: 20,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            if (isFirst)
              Positioned(
                top: -32,
                right: 16,
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.amber.shade400,
                  size: 32,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: isFirst ? 48 : 36, bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.sora(
                      fontSize: isFirst ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    points,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: isFirst ? 12 : 10,
                      fontWeight: FontWeight.bold,
                      color: isFirst
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isFirst
                          ? AppColors.primary
                          : (rank == 3
                                ? Colors.orange.shade100
                                : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      isFirst ? 'JUARA 1' : 'RANK $rank',
                      style: GoogleFonts.sora(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isFirst
                            ? Colors.white
                            : (rank == 3
                                  ? Colors.orange.shade700
                                  : Colors.grey.shade600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTukarPoinGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tukar Poin',
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Gunakan poinmu untuk hadiah eksklusif',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Icon(Icons.filter_list_rounded, color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildRewardItemCard(
              title: 'Gratis Internet 1 Bln',
              points: '500 Pts',
              icon: Icons.wifi_tethering,
              color: Colors.teal,
              isHot: true,
            ),
            _buildRewardItemCard(
              title: 'Voucher Kopi',
              points: '150 Pts',
              icon: Icons.coffee_rounded,
              color: Colors.orange,
              isHot: false,
            ),
            _buildRewardItemCard(
              title: 'Merchandise JBR',
              points: '800 Pts',
              icon: Icons.shopping_bag_rounded,
              color: Colors.blue,
              isHot: false,
            ),
            _buildRewardItemCard(
              title: 'Voucher Bioskop',
              points: '300 Pts',
              icon: Icons.confirmation_number_rounded,
              color: Colors.purple,
              isHot: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardItemCard({
    required String title,
    required String points,
    required IconData icon,
    required MaterialColor color,
    required bool isHot,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: 48, color: color),
                  if (isHot)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HOT',
                          style: GoogleFonts.sora(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            points,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
               AppDialog.showConfirmation(
                 context: context,
                 title: 'Konfirmasi',
                 message: 'Tukar $points poin untuk $title?',
                 confirmText: 'Tukar',
                 icon: Icons.track_changes_rounded,
                 onConfirm: () {
                   AppFeedback.success(context, 'Berhasil ditukar!');
                 },
               );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Tukar',
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Check-in',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dapatkan +10 Poin gratis setiap hari kamu membuka aplikasi.',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.push('/promo/daily-checkin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Ambil Sekarang',
                    style: GoogleFonts.sora(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // --- Sub-Tab 3: Undian (Halaman 14 Placeholder) ---
  Widget _buildUndianTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildUndianHeroCard(),
        const SizedBox(height: 24),
        _buildUndianProgress(),
        const SizedBox(height: 32),
        _buildHadiahUtamaList(),
        const SizedBox(height: 32),
        _buildUndianCta(),
        const SizedBox(height: 80),
      ],
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildUndianHeroCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Simulated 3D golden ticket with an Icon since we don't have the image asset
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.confirmation_number_rounded,
              size: 100,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Undian Akhir Tahun JBR',
            style: GoogleFonts.sora(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.amber, // gold-like
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Raih kesempatan memenangkan hadiah eksklusif dengan menukarkan poin loyalitas Anda.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFF6FFBBE), // primary-fixed-dim
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUndianProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS ANDA',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '900 / 1.000 Poin',
                    style: GoogleFonts.sora(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '90% Komplit',
                  style: GoogleFonts.sora(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981), // primary-container
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Kumpulkan '),
                      TextSpan(
                        text: '100 Poin',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: ' lagi untuk 1 Kupon'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHadiahUtamaList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hadiah Utama',
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Lihat Semua',
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildHadiahItem(
          title: 'High-End Smartphone',
          sisa: '02',
          isTag: 'Gadget',
          color: Colors.blue,
          icon: Icons.smartphone_rounded,
        ),
        const SizedBox(height: 12),
        _buildHadiahItem(
          title: 'Premium Ultrabook',
          sisa: '01',
          isTag: 'Kerja',
          color: Colors.teal,
          icon: Icons.laptop_mac_rounded,
        ),
        const SizedBox(height: 12),
        _buildHadiahItem(
          title: 'Creative Pro Tablet',
          sisa: '03',
          isTag: 'Kreatif',
          color: Colors.teal,
          icon: Icons.tablet_mac_rounded,
        ),
      ],
    );
  }

  Widget _buildHadiahItem({
    required String title,
    required String sisa,
    required String isTag,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: color),
                const SizedBox(height: 16),
                Text(title, style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Sisa Unit: $sisa', style: GoogleFonts.dmSans(color: Colors.grey)),
                const SizedBox(height: 16),
                const Text('Dapatkan kesempatan menang dari undian akhir tahun JBR Minpo!'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      isTag.toUpperCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sisa Unit: $sisa',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildUndianCta() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
             AppDialog.showConfirmation(
               context: context,
               title: 'Tukar Kupon',
               message: 'Tukar 1.000 Poin untuk 1 Kupon Undian?',
               confirmText: 'Tukar',
               icon: Icons.confirmation_num_rounded,
               iconColor: Colors.amber,
               onConfirm: () {
                 AppFeedback.success(context, 'Berhasil menukar kupon!');
               },
             );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber, // metallic gold equivalent
            foregroundColor: const Color(0xFF064E3B), // emerald-900
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: Colors.amber.withValues(alpha: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_number_rounded),
              const SizedBox(width: 8),
              Text(
                'AMBIL KUPON UNDIAN',
                style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'S&K Berlaku. 1 Kupon = 1.000 Poin JBR.',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // --- Sub-Tab 4: Referral (Halaman 15 Placeholder) ---
  Widget _buildReferralTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildReferralHero(),
        const SizedBox(height: 24),
        _buildReferralCodeBox(),
        const SizedBox(height: 24),
        _buildReferralStats(),
        const SizedBox(height: 24),
        _buildReferralInstruction(),
        const SizedBox(height: 32),
        _buildReferralCta(),
        const SizedBox(height: 80),
      ],
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildReferralHero() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.handshake_rounded,
            size: 80,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Ajak Teman, Raih Bonus!',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Bagikan kode unik Anda dan dapatkan poin setiap kali teman Anda bergabung.',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReferralCodeBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
          style: BorderStyle.none,
        ),
      ),
      child: Column(
        children: [
          Text(
            'KODE REFERRAL ANDA',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                style: BorderStyle.solid,
              ), // Dashed normally requires custom painter, using solid for now
            ),
            child: Text(
              'JBR-BEKASI-2024',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'JBR-BEKASI-2024'));
              AppFeedback.copied(context, 'Kode Referral disalin!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6FFBBE), // primary-fixed
              foregroundColor: const Color(0xFF002113), // on-primary-fixed
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.copy_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Salin',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralStats() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF82F5C1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    color: Color(0xFF00714E),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'TEMAN BERGABUNG',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '12',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFF00367A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'TOTAL POIN',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '1.200',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF005AC2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pts',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF005AC2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferralInstruction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara Mendapatkan Poin',
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            '1',
            'Bagikan kode referral Anda ke teman-teman melalui WhatsApp atau media sosial.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            '2',
            'Pastikan teman Anda memasukkan kode saat melakukan pendaftaran layanan.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            '3',
            'Poin otomatis masuk ke akun Anda setelah verifikasi pemasangan berhasil.',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferralCta() {
    return ElevatedButton(
      onPressed: () async {
        final url = Uri.parse('https://wa.me/?text=Gunakan+kode+referral+saya+JBR-BEKASI-2024');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          // ignore: use_build_context_synchronously
          AppFeedback.error(context, 'Gagal membuka WhatsApp');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366), // WhatsApp color
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: const Color(0xFF25D366).withValues(alpha: 0.4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_rounded), // Simplified WhatsApp icon
          const SizedBox(width: 12),
          Text(
            'Bagikan ke WhatsApp',
            style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({required PromoModel promo}) {
    final title = promo.title;
    final desc = promo.description;
    final price = promo.price;
    final originalPrice = promo.originalPrice;
    final timer = promo.timer ?? '00:00:00';
    final isFlashSale = promo.isFlashSale;
    final color = promo.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Area
          Stack(
            children: [
              Hero(
                tag: title,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.6), color],
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: promo.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerLoader(width: double.infinity, height: 160),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        timer,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isFlashSale)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FLASH SALE',
                      style: GoogleFonts.sora(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content Area
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (originalPrice != null)
                          Text(
                            'Rp $originalPrice',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          price.startsWith('Potongan') ? price : 'Rp $price',
                          style: GoogleFonts.sora(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          '/promo/detail',
                          extra: {
                            'title': title,
                            'desc': desc,
                            'price': price,
                            'originalPrice': originalPrice,
                            'timer': timer,
                            'isFlashSale': isFlashSale,
                            'color': color,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Lihat Detail',
                        style: GoogleFonts.sora(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
