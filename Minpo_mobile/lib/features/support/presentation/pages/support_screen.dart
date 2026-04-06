import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {'q': 'Bagaimana cara bayar tagihan?', 'a': 'Anda dapat membayar tagihan melalui Menu Pembayaran di App, transfer bank, atau gerai retail terdekat.', 'isOpen': false},
    {'q': 'Koneksi internet lambat tiba-tiba?', 'a': 'Coba restart router Anda selama 30 detik. Jika masih kendala, gunakan menu Lapor Gangguan.', 'isOpen': false},
    {'q': 'Cara ganti password WiFi?', 'a': 'Buka menu Pengaturan Router di Aplikasi JBR Minpo, pilih WiFi Settings.', 'isOpen': false},
    {'q': 'Biaya upgrade paket internet?', 'a': 'Biaya bervariasi tergantung kecepatan yang pilih. Cek menu Paket Saya.', 'isOpen': false},
  ];

  // Mock Active Ticket data (could be fetched from a provider/repository)
  final Map<String, dynamic> _activeTicket = {
    'id': 'TKT-89123',
    'status': 'DIPROSES',
    'title': 'Koneksi Terputus Total',
    'progress': 0.65,
    'description': 'Sedang ditangani oleh teknisi Budi Santoso',
  };

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        AppFeedback.error(context, 'Tidak dapat membuka: $urlString');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            _buildSliverHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActiveTicketCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Menu Layanan', 'Pilih bantuan sesuai kebutuhan Anda'),
                    const SizedBox(height: 16),
                    _buildBentoGrid(),
                    const SizedBox(height: 32),
                    _buildQuickContact(),
                    const SizedBox(height: 32),
                    _buildFaqSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        title: Text('Pusat Bantuan', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
             Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF064e3b)], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight
                ),
              ),
            ),
            Positioned(
              right: -40,
              top: -30,
              child: Icon(Icons.support_agent_rounded, size: 280, color: Colors.white.withValues(alpha: 0.05)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo Ahmad,', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Ada yang bisa kami bantu hari ini?', style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildActiveTicketCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.orange.withValues(alpha: 0.08), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12), 
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle), 
                child: const Icon(Icons.confirmation_num_rounded, color: Colors.orange, size: 24)
              ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tiket Aktif: ${_activeTicket['title']}', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('ID ${_activeTicket['id']} • ${_activeTicket['description']}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress Perbaikan', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                        Text('${(_activeTicket['progress'] * 100).toInt()}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _activeTicket['progress'], 
                        backgroundColor: Colors.orange.withValues(alpha: 0.1), 
                        color: Colors.orange, 
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => context.push('/support/ticket-tracking'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), 
                  decoration: BoxDecoration(
                    color: Colors.orange, 
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ), 
                  child: Text('Track', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, curve: Curves.easeOutQuad);
  }

  Widget _buildBentoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildActionCard('Lapor Gangguan', 'Kendala teknis?', Icons.feedback_rounded, AppColors.primary, '/support/report-issue', 100),
        _buildActionCard('Cek Jaringan', 'Status koneksi', Icons.sensors_rounded, Colors.blue, '/info/network-status', 200),
        _buildActionCard('Live Chat CS', 'Tanya agen kami', Icons.chat_bubble_rounded, Colors.green, '/support/chat-cs', 300),
        _buildActionCard('Instalasi', 'Pasang baru', Icons.add_business_rounded, Colors.purple, '/support/installation', 400),
      ],
    );
  }

  Widget _buildActionCard(String title, String sub, IconData icon, Color color, String route, int delay) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(28), 
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8))]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(sub, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms).slideY(begin: 0.05, curve: Curves.easeOutQuad);
  }

  Widget _buildQuickContact() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 25, offset: const Offset(0, 10))],
        image: const DecorationImage(image: CachedNetworkImageProvider('https://www.transparenttextures.com/patterns/carbon-fibre.png'), opacity: 0.05),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bantuan Cepat?', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Hubungi Call Center atau WhatsApp untuk respon instan.', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.7), height: 1.5)),
                  ],
                ),
              ),
              const Icon(Icons.headset_mic_rounded, color: Colors.white24, size: 64),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  'Telepon CS',
                  Icons.phone_rounded,
                  Colors.white,
                  AppColors.primary,
                  onTap: () => _launchUrl('tel:1500123'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactButton(
                  'WhatsApp',
                  Icons.chat_rounded,
                  const Color(0xFF25D366),
                  Colors.white,
                  onTap: () => _launchUrl('https://wa.me/628123456789'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String label, IconData icon, Color bg, Color text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: bg != Colors.white ? [BoxShadow(color: bg.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: text, size: 20),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: text)),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('FAQ', 'Pertanyaan yang sering ditanyakan'),
        const SizedBox(height: 20),
        ...List.generate(_faqs.length, (idx) => _buildFaqItem(idx)),
      ],
    );
  }

  Widget _buildFaqItem(int index) {
    final faq = _faqs[index];
    bool isOpen = faq['isOpen'] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isOpen ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade100),
        boxShadow: isOpen ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 20)] : null,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(index),
          title: Text(faq['q'], style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: isOpen ? AppColors.primary : AppColors.textPrimary)),
          trailing: AnimatedRotation(
            turns: isOpen ? 0.5 : 0,
            duration: 300.ms,
            child: Icon(Icons.keyboard_arrow_down_rounded, color: isOpen ? AppColors.primary : Colors.grey),
          ),
          onExpansionChanged: (val) => setState(() => _faqs[index]['isOpen'] = val),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(faq['a'], style: GoogleFonts.dmSans(fontSize: 13, height: 1.6, color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
