import 'package:ecommerceapp/features/cars/models/item.dart';

abstract class FavoriteState {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteUpdated extends FavoriteState {
  final List<Item> favorites;

  const FavoriteUpdated(this.favorites);
}

class FavoriteFailure extends FavoriteState {
  final String message;

  const FavoriteFailure(this.message);
}