import 'package:ecommerceapp/features/home/domain/entities/home_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> getHomeData(String userId);
  Future<List<String>> getFeaturedProducts();
}