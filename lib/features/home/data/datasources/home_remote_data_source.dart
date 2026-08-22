import 'package:ecommerceapp/features/home/data/models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData(String userId);

  Future<List<String>> getFeaturedProductIds();
}