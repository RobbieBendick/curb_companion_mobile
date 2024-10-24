import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'favorite_state.dart';

final favoriteStateProvider =
    StateNotifierProvider<FavoriteStateNotifier, FavoriteState>(
        (ref) => FavoriteStateNotifier(ref));

class FavoriteStateNotifier extends StateNotifier<FavoriteState> {
  final Ref ref;

  FavoriteStateNotifier(this.ref)
      : super(FavoriteInitialState(
            ref.watch(userStateProvider.notifier).user != null
                ? ref.watch(userStateProvider.notifier).user!.favorites != null
                    ? ref.watch(userStateProvider.notifier).user!.favorites!
                    : []
                : []));
}
