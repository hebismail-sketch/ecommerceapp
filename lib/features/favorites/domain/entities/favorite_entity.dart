import 'package:equatable/equatable.dart';

// Entity representing a favorite product item
class FavoriteEntity extends Equatable {
  final String id;
  final String productId;

  const FavoriteEntity({
    required this.id,
    required this.productId,
  });

  @override
  List<Object?> get props => [id, productId];
}
