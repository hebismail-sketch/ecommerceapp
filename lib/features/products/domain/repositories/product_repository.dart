import '../entities/product_entity.dart';

abstract class ProductRepository {
  Stream<List<ProductEntity>> getProducts();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(String productId, ProductEntity product);
  Future<void> deleteProduct(String productId);
}
