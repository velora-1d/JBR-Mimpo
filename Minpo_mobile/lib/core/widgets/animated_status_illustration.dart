import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum StatusType { maintenance, error, success, review }

class AnimatedStatusIllustration extends StatelessWidget {
  final StatusType type;
  final double height;

  const AnimatedStatusIllustration({
    super.key,
    required this.type,
    this.height = 250,
  });

  String _getAssetPath() {
    switch (type) {
      case StatusType.maintenance:
        return 'assets/images/status/maintenance.svg';
      case StatusType.error:
        return 'assets/images/status/server_error.svg';
      case StatusType.success:
        return 'assets/images/status/success.svg';
      case StatusType.review:
        return 'assets/images/status/under_review.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _getAssetPath();

    Widget illustration = SvgPicture.asset(
      assetPath,
      height: height,
      fit: BoxFit.contain,
    );

    // Memberikan animasi berdasarkan tipe status sesuai "Master Plan"
    switch (type) {
      case StatusType.maintenance:
        return illustration
            .animate()
            .fadeIn(duration: 800.ms)
            .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white24)
            .then()
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shake(hz: 0.5, curve: Curves.easeInOut, rotation: 0.01);

      case StatusType.error:
        return illustration
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 1.seconds)
            .blur(begin: const Offset(0, 0), end: const Offset(2, 2))
            .then()
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .tint(color: Colors.red.withValues(alpha: 0.1), duration: 2.seconds);

      case StatusType.success:
        return illustration
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .then()
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1.5.seconds,
              curve: Curves.easeInOut,
            );

      case StatusType.review:
        return illustration
            .animate()
            .fadeIn(duration: 800.ms)
            .slideX(begin: -0.1, end: 0)
            .then()
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveX(begin: -5, end: 5, duration: 3.seconds, curve: Curves.easeInOut);
    }
  }
}
