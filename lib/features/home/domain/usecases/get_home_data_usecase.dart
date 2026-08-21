import 'package:ecommerceapp/features/home/domain/entities/home_entity.dart';
import 'package:ecommerceapp/features/home/domain/repositories/home_repository.dart';


class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});


  Future<HomeEntity> call({required String userId}) async {
    return await repository.getHomeData(userId);
  }
}