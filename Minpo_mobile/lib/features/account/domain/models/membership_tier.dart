import 'package:flutter/material.dart';

enum MembershipTier {
  silver,
  gold,
  platinum;

  String get label {
    switch (this) {
      case MembershipTier.silver:
        return 'SILVER MEMBER';
      case MembershipTier.gold:
        return 'GOLD MEMBER';
      case MembershipTier.platinum:
        return 'PLATINUM MEMBER';
    }
  }

  Color get color {
    switch (this) {
      case MembershipTier.silver:
        return Colors.blueGrey.shade400;
      case MembershipTier.gold:
        return const Color(0xFFD4AF37); // Gold color
      case MembershipTier.platinum:
        return Colors.amber;
    }
  }

  Color get bgColor {
    switch (this) {
      case MembershipTier.silver:
        return Colors.blueGrey.withValues(alpha: 0.1);
      case MembershipTier.gold:
        return const Color(0xFFD4AF37).withValues(alpha: 0.1);
      case MembershipTier.platinum:
        return Colors.amber.withValues(alpha: 0.1);
    }
  }

  String get benefitTitle {
    switch (this) {
      case MembershipTier.silver:
        return 'KEUNTUNGAN SILVER';
      case MembershipTier.gold:
        return 'KEUNTUNGAN GOLD';
      case MembershipTier.platinum:
        return 'KEUNTUNGAN PLATINUM';
    }
  }

  String get benefitDescription {
    switch (this) {
      case MembershipTier.silver:
        return 'Dapatkan cashback 1% untuk setiap pembayaran.';
      case MembershipTier.gold:
        return 'Dapatkan cashback 3% untuk setiap pembayaran.';
      case MembershipTier.platinum:
        return 'Dapatkan cashback 5% untuk setiap pembayaran.';
    }
  }

  double get cashback {
    switch (this) {
      case MembershipTier.silver:
        return 1.0;
      case MembershipTier.gold:
        return 3.0;
      case MembershipTier.platinum:
        return 5.0;
    }
  }

  List<String> get fullBenefits {
    switch (this) {
      case MembershipTier.silver:
        return ['Cashback 1%', 'Akses ke promo dasar', 'Layanan CS standar'];
      case MembershipTier.gold:
        return ['Cashback 3%', 'Prioritas Antrian Tiket', 'Akses ke promo eksklusif'];
      case MembershipTier.platinum:
        return ['Cashback 5%', 'Prioritas Layanan CS 24/7', 'Akses Semua Promo & Event', 'Batas 4 Perangkat'];
    }
  }
}
