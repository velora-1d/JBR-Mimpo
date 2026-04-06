import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../providers/information_provider.dart';
import '../../domain/models/information_model.dart';

class InformationScreen extends ConsumerStatefulWidget {
  const InformationScreen({super.key});

  @override
  ConsumerState<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends ConsumerState<InformationScreen> {
  String _selectedCategory = 'Semua';



  @override
  Widget build(BuildContext context) {
    final infoAsync = ref.watch(informationListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Kabar Minpo'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: infoAsync.when(
              data: (infos) {
                final filteredList = infos.where((info) {
                  if (_selectedCategory == 'Semua') return true;
                  return info.category == _selectedCategory;
                }).toList();

                return RefreshIndicator(
                  onRefresh: () => ref.read(informationListProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final info = filteredList[index];
                      return _buildInfoCard(info);
                    },
                  ),
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                ),
              ),
              error: (err, stack) => Center(child: Text('Gagal: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
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
              style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari kabar terbaru...',
                hintStyle: GoogleFonts.dmSans(color: Colors.grey.withValues(alpha: 0.6), fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 18),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Semua', 'Gangguan', 'Maintenance', 'Info Umum'].map((cat) => _buildCategoryChip(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    bool isActive = _selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = title),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? AppColors.primary : Colors.grey.shade100),
        ),
        child: Text(
          title,
          style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildInfoCard(InformationModel info) {
    return GestureDetector(
      onTap: () => context.push('/info/detail', extra: info.toJson()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: info.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(info.icon, color: info.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.title, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(info.description, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey), maxLines: 2),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}
