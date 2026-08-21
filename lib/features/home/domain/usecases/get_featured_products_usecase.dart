import 'package:ecommerceapp/features/home/domain/repositories/home_repository.dart';


class GetFeaturedProductsUseCase {
  final HomeRepository repository;

  GetFeaturedProductsUseCase({required this.repository});


  Future<List<String>> call() async {
    return await repository.getFeaturedProducts();
  }
}