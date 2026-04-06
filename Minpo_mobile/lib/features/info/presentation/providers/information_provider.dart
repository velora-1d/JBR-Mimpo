import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/information_model.dart';
import '../../data/repositories/information_repository.dart';

final informationRepositoryProvider = Provider((ref) => InformationRepository());

final informationListProvider = AsyncNotifierProvider<InformationNotifier, List<InformationModel>>(
  () => InformationNotifier(),
);

class InformationNotifier extends AsyncNotifier<List<InformationModel>> {
  @override
  Future<List<InformationModel>> build() async {
    return ref.watch(informationRepositoryProvider).getInformations();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(informationRepositoryProvider).getInformations(),
    );
  }
}
