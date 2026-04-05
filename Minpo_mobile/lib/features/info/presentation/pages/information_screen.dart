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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari info...',
                hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
          color: isActive ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive 
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
        ),
        child: Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textSecondary,
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
        color: isPinned ? color.withValues(alpha: 0.08) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isPinned ? color.withValues(alpha: 0.2) : Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info['desc'],
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (info['category'] == 'Maintenance')
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          info['date'],
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        info['time'],
                        style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                else if (info['category'] == 'Gangguan')
                   Text(
                    '${info['status']} • Diperbarui ${info['updateTime']}',
                    style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        info['time'],
                        style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
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
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
