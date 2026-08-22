import 'package:ecommerceapp/features/home/domain/entities/home_entity.dart';

class HomeModel {
  final String userId;
  final List<String> featuredProductIds;
  final String? userGreeting;

  const HomeModel({
    required this.userId,
    required this.featuredProductIds,
    this.userGreeting,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      userId: json['userId'] as String? ?? '',
      featuredProductIds: List<String>.from(json['featuredProductIds'] as List? ?? []),
      userGreeting: json['userGreeting'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'featuredProductIds': featuredProductIds,
      'userGreeting': userGreeting,
    };
  }

  HomeEntity toEntity() {
    return HomeEntity(
      userId: userId,
      featuredProductIds: featuredProductIds,
      userGreeting: userGreeting,
    );
  }
}