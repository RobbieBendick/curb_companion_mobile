part of 'favorite_state_notifier.dart';

class FavoriteState {
  final List<Object> favoriteVendorIds;

  FavoriteState(this.favoriteVendorIds);
}

class FavoriteInitialState extends FavoriteState {
  FavoriteInitialState(List<Object> favoriteVendorIds)
      : super(favoriteVendorIds);
}
