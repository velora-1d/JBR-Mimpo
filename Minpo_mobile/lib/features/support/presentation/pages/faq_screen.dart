import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Tagihan', 'Teknis', 'Akun', 'Promo'];

  final List<Map<String, dynamic>> _faqData = [
    {
      'question': 'Bagaimana cara membayar tagihan lewat m-banking?',
      'answer': 'Anda dapat membayar melalui menu Virtual Account di aplikasi bank pilihan Anda. Gunakan kode perusahaan 88902 diikuti dengan nomor pelanggan JBR Anda.',
      'refId': 'FAQ-PAY-001',
      'category': 'Tagihan',
    },
    {
      'question': 'Internet lambat di jam tertentu, apa solusinya?',
      'answer': 'Pastikan posisi router tidak terhalang benda logam. Anda juga bisa mencoba melakukan restart router melalui aplikasi JBR Minpo atau mencabut kabel power selama 30 detik.',
      'refId': 'FAQ-TEC-012',
      'category': 'Teknis',
    },
    {
      'question': 'Cara ganti password WiFi JBR Minpo?',
      'answer': 'Buka menu Pengaturan Router di aplikasi ini, pilih tab Keamanan, lalu masukkan password baru Anda. Router akan melakukan restart otomatis.',
      'refId': 'FAQ-ACC-005',
      'category': 'Akun',
    },
    {
      'question': 'Promo upgrade speed tersedia bulan ini?',
      'answer': 'Tentu! Bulan ini tersedia promo "Kilat Ramadhan" dengan diskon 50% untuk upgrade ke paket 100Mbps bagi pelanggan setia.',
      'refId': 'FAQ-PRM-088',
      'category': 'Promo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Custom Header with Search
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.bgLight,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Pusat Bantuan',
                      style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Temukan jawaban cepat untuk kendala internet Anda.',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Ultra Premium Search Bar (Modern Solid)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
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
                  hintText: 'Cari solusi...',
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
          ),
        ),

          // 3. Categories
          SliverToBoxAdapter(
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))]
                          : null,
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: GoogleFonts.sora(
                            fontSize: 13, 
                            fontWeight: FontWeight.bold, 
                            color: isSelected ? Colors.white : AppColors.textSecondary
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          // 4. FAQ List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final faq = _faqData[index];
                  if (_selectedCategory != 'Semua' && faq['category'] != _selectedCategory) {
                    return const SizedBox.shrink();
                  }
                  return _buildFaqItem(faq);
                },
                childCount: _faqData.length,
              ),
            ),
          ),

          // 5. Help Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              child: _buildHelpBanner(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: AppColors.primary,
          collapsedIconColor: Colors.grey,
          title: Text(
            faq['question'],
            style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.withValues(alpha: 0.05),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  Text(
                    faq['answer'],
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Ref ID: ${faq['refId']}',
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildHelpBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuAmGboHZSNN_N5N0nj-JvOqBSMYPDmdB-peHJ5FAMFuW9lhYjhG0aWQGUVgWQZTGMJk3tOYisqP9qZhs6RUyH8ZXnz7voyBrHVlQJUA8MyIAr-w6zKK0AkXLpN_THCEiBu4L3JZBtdu7vX3yH7O_2PV1FcxGlCJMl14zPxidwLu_6znS4jIBRYnJqpGuhfW6K8mTCxYD5mJKlmskC4FG2UVrlnnCBint5tz9JICz84eCNmTZbPwEUdDlv5R1LR0oOPqisSoztdoEyFF'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.9), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masih butuh bantuan?',
                  style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 180,
                  child: Text(
                    'Hubungi teknisi kami langsung melalui chat interaktif 24/7.',
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push('/chat-cs'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Mulai Chat',
                      style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}
