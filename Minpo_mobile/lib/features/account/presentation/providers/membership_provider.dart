import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbr_mimpo/features/account/domain/models/membership_tier.dart';

final membershipProvider = StateProvider<MembershipTier>((ref) {
  // Default to Platinum for demonstration as requested initially
  return MembershipTier.platinum;
});
