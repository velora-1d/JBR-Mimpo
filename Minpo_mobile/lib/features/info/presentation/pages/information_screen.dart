import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';
import 'package:go_router/go_router.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  String _selectedCategory = 'Semua';

  final List<Map<String, dynamic>> _infoList = [
    {
      'title': 'Promo Upgrade Kecepatan',
      'desc': 'Dapatkan upgrade kecepatan hingga 100Mbps dengan harga spesial untuk seluruh pelanggan setia JBR Minpo.',
      'category': 'Info Umum',
      'time': 'SELAMANYA',
      'isPinned': true,
      'icon': Icons.card_giftcard_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Pemeliharaan Jaringan Area Jakarta Selatan',
      'desc': 'Peningkatan kapasitas backbone untuk stabilitas koneksi.',
      'category': 'Maintenance',
      'date': 'Kamis, 24 Okt',
      'time': '00:00 - 04:00 WIB',
      'isPinned': false,
      'icon': Icons.build_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Laporan Gangguan Massal Bekasi',
      'desc': 'Tim teknis sedang melakukan pengecekan kabel backbone yang terdampak pekerjaan jalan di area Harapan Indah.',
      'category': 'Gangguan',
      'status': 'Sedang Ditangani',
      'updateTime': '5 menit yang lalu',
      'isPinned': false,
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Search & Filter Section
        _buildSearchAndFilter(),

        // 2. Info List Content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Simulate network request
              await Future.delayed(const Duration(seconds: 2));
              setState(() {});
            },
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: _infoList.length + 1, // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index == _infoList.length) {
                  return _buildLoadingIndicator();
                }
                
                final info = _infoList[index];
                return _buildInfoCard(info);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          // Ultra Premium Search Bar (Modern Solid)
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              style: GoogleFonts.dmSans(
                color: Theme.of(context).colorScheme.onSurface, 
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Cari informasi terbaru...',
                hintStyle: GoogleFonts.dmSans(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                prefixIcon: UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .shimmer(duration: 3.seconds, color: Colors.white24),
                ),
                suffixIcon: UnconstrainedBox(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF6366f1)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, curve: Curves.easeOutBack),
          
          const SizedBox(height: 20),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildCategoryChip('Semua'),
                const SizedBox(width: 8),
                _buildCategoryChip('Gangguan'),
                const SizedBox(width: 8),
                _buildCategoryChip('Maintenance'),
                const SizedBox(width: 8),
                _buildCategoryChip('Info Umum'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    bool isActive = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedCategory = title);
      },
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Theme.of(context).cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: isActive 
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))]
            : [],
        ),
        child: Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> info) {
    bool isPinned = info['isPinned'] ?? false;
    Color color = info['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isPinned ? color.withValues(alpha: 0.05) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isPinned ? color.withValues(alpha: 0.3) : Theme.of(context).dividerColor.withValues(alpha: 0.08),
          width: isPinned ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/info-detail', extra: info);
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        info['category'].toString().toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    if (isPinned)
                      const Icon(Icons.push_pin_rounded, color: AppColors.primary, size: 18),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isPinned ? Colors.white : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Icon(info['icon'], color: color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info['title'],
                            style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            info['desc'],
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (info['category'] == 'Maintenance')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_rounded, size: 14, color: color),
                        const SizedBox(width: 8),
                        Text(
                          info['date'],
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                        ),
                        const SizedBox(width: 12),
                        Container(width: 1, height: 12, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        const SizedBox(width: 12),
                        Icon(Icons.schedule_rounded, size: 14, color: color),
                        const SizedBox(width: 8),
                        Text(
                          info['time'],
                          style: GoogleFonts.dmSans(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                else if (info['category'] == 'Gangguan')
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync_rounded, size: 14, color: color),
                        const SizedBox(width: 8),
                        Text(
                          '${info['status']} • ${info['updateTime']}',
                          style: GoogleFonts.dmSans(fontSize: 11, color: color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        info['time'],
                        style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => 
               Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 500.ms,
                delay: (i * 150).ms,
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.2, 1.2),
              )
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'MEMUAT INFORMASI LAINNYA',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
