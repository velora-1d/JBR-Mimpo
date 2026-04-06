import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/promo_model.dart';
import '../../data/repositories/promo_repository.dart';

final promoRepositoryProvider = Provider((ref) => PromoRepository());

final promoListProvider = AsyncNotifierProvider<PromoNotifier, List<PromoModel>>(
  () => PromoNotifier(),
);

class PromoNotifier extends AsyncNotifier<List<PromoModel>> {
  @override
  Future<List<PromoModel>> build() async {
    return ref.watch(promoRepositoryProvider).getPromos();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(promoRepositoryProvider).getPromos(),
    );
  }
}
