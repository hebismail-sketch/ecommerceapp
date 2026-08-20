part of 'favorite_cubit.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<FavoriteEntity> favorites;

  const FavoriteSuccess(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoriteFailure extends FavoriteState {
  final String message;

  const FavoriteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
