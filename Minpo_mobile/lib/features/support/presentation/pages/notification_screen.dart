import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Notification States
  bool isPushEnabled = true;
  bool isWhatsAppEnabled = true;
  bool isEmailEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. App Bar
            _buildAppBar(context),
            
            // 2. Page Title Header
            _buildPageHeader(),
            
            const SizedBox(height: 16),
            
            // 3. Tab Switcher
            _buildTabSwitcher(),
            
            // 4. Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildHistoryTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
            
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Notifikasi',
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            tooltip: 'Tandai semua sudah dibaca',
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pusat',
                    style: GoogleFonts.sora(
                      fontSize: 32, 
                      fontWeight: FontWeight.w800, 
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'Notifikasi',
                    style: GoogleFonts.sora(
                      fontSize: 32, 
                      fontWeight: FontWeight.w800, 
                      color: AppColors.primary,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: -20,
            top: -10,
            child: Icon(
              Icons.notifications_active_rounded,
              size: 110,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .moveY(begin: 0, end: 10, duration: 2.seconds, curve: Curves.easeInOut),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05);
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        tabs: const [
          Tab(text: 'Riwayat'),
          Tab(text: 'Pengaturan'),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(20),
        children: [
          _buildNotificationCard(
            icon: Icons.payments_rounded,
            title: 'Pembayaran Berhasil',
            time: '09:41',
            category: 'BILLING',
            categoryColor: AppColors.primary,
            content: 'Tagihan bulan Oktober sebesar Rp450.000 telah terverifikasi.',
          ),
          _buildNotificationCard(
            icon: Icons.card_giftcard_rounded,
            title: 'Promo Akhir Pekan',
            time: 'Yesterday',
            category: 'PROMO',
            categoryColor: Colors.orange,
            content: 'Dapatkan diskon 20% untuk upgrade speed ke 100Mbps khusus hari ini!',
          ),
          _buildNotificationCard(
            icon: Icons.build_circle_rounded,
            title: 'Pemeliharaan Jaringan',
            time: '2d ago',
            category: 'MAINTENANCE',
            categoryColor: const Color(0xFF005ac2),
            content: 'Informasi pemeliharaan rutin di wilayah Jakarta Selatan pada pukul 01:00 WIB.',
            isMaintenance: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String time,
    required String category,
    required Color categoryColor,
    required String content,
    bool isMaintenance = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isMaintenance ? categoryColor.withValues(alpha: 0.3) : Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/home/notifications/detail', extra: {
              'icon': icon,
              'title': title,
              'time': time,
              'category': category,
              'categoryColor': categoryColor,
              'content': content,
              'isMaintenance': isMaintenance,
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: categoryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.sora(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            time,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        content,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Kontrol Notifikasi',
          style: GoogleFonts.sora(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 50, 
          height: 4, 
          alignment: Alignment.centerLeft,
          child: Container(
            width: 40,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.notification_important_rounded,
                title: 'Push Notification',
                subtitle: 'Alert real-time di HP kamu',
                color: AppColors.primary,
                value: isPushEnabled,
                onChanged: (v) => setState(() => isPushEnabled = v),
              ),
              _buildSettingItem(
                icon: Icons.chat_bubble_rounded,
                title: 'WhatsApp Alert',
                subtitle: 'Pesan langsung ke nomor terdaftar',
                color: Colors.green,
                value: isWhatsAppEnabled,
                onChanged: (v) => setState(() => isWhatsAppEnabled = v),
              ),
              _buildSettingItem(
                icon: Icons.mail_rounded,
                title: 'Email Alert',
                subtitle: 'Laporan bulanan & tagihan',
                color: const Color(0xFF005ac2),
                value: isEmailEnabled,
                onChanged: (v) => setState(() => isEmailEnabled = v),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5), 
        borderRadius: BorderRadius.circular(24)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: GoogleFonts.sora(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                ),
                Text(
                  subtitle, 
                  style: GoogleFonts.dmSans(
                    fontSize: 10, 
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                  )
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
