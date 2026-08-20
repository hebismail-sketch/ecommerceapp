import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Stream<List<ProductEntity>> call() {
    return repository.getProducts();
  }
}
