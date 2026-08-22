import 'package:ecommerceapp/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerceapp/features/home/domain/entities/home_entity.dart';
import 'package:ecommerceapp/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeEntity> getHomeData(String userId) async {
    final homeModel = await remoteDataSource.getHomeData(userId);
    return homeModel.toEntity();
  }

  @override
  Future<List<String>> getFeaturedProducts() async {
    return await remoteDataSource.getFeaturedProductIds();
  }
}