import 'package:equatable/equatable.dart';


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