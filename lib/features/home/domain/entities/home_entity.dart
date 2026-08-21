import 'package:equatable/equatable.dart';

/// HomeEntity represents the home screen data at the domain layer
/// Contains featured products and user information
class HomeEntity extends Equatable {
  final String userId;
  final List<String> featuredProductIds;
  final String? userGreeting;

  const HomeEntity({
    required this.userId,
    required this.featuredProductIds,
    this.userGreeting,
  });

  @override
  List<Object?> get props => [userId, featuredProductIds, userGreeting];
}