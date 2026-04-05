import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class HorizontalStepper extends StatelessWidget {
  final String currentStatus;

  const HorizontalStepper({
    super.key,
    required this.currentStatus,
  });

  int _getStatusIndex() {
    final status = currentStatus.toUpperCase();
    if (status.contains('MENUNGGU')) return 0;
    if (status.contains('DIPROSES')) return 1;
    if (status.contains('PERJALANAN')) return 2;
    if (status.contains('SELESAI')) return 3;
    if (status.contains('DITUTUP')) return 4;
    return 0; // Default
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _getStatusIndex();
    final List<String> steps = ['Menunggu', 'Diproses', 'Perjalanan', 'Selesai', 'Ditutup'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            bool isDot = index % 2 == 0;
            int stepIndex = index ~/ 2;

            if (isDot) {
              bool isActive = stepIndex <= currentIndex;
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              );
            } else {
              bool isLineActive = stepIndex < currentIndex;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isLineActive ? AppColors.primary : Colors.grey.shade300,
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            bool isActive = index <= currentIndex;
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 7,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primary : Colors.grey.shade500,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
