import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ProductEntity>> getProducts() {
    return remoteDataSource.getProducts();
  }

  @override
  Future<void> addProduct(ProductEntity product) {
    final productModel = ProductModel(
      id: product.id,
      favoriteId: product.favoriteId,
      nameAr: product.nameAr,
      brandAr: product.brandAr,
      locationAr: product.locationAr,
      descriptionAr: product.descriptionAr,
      nameEn: product.nameEn,
      brandEn: product.brandEn,
      locationEn: product.locationEn,
      descriptionEn: product.descriptionEn,
      image: product.image,
      price: product.price,
      year: product.year,
    );
    return remoteDataSource.addProduct(productModel);
  }

  @override
  Future<void> updateProduct(String productId, ProductEntity product) {
    final productModel = ProductModel(
      id: product.id,
      favoriteId: product.favoriteId,
      nameAr: product.nameAr,
      brandAr: product.brandAr,
      locationAr: product.locationAr,
      descriptionAr: product.descriptionAr,
      nameEn: product.nameEn,
      brandEn: product.brandEn,
      locationEn: product.locationEn,
      descriptionEn: product.descriptionEn,
      image: product.image,
      price: product.price,
      year: product.year,
    );
    return remoteDataSource.updateProduct(productId, productModel);
  }

  @override
  Future<void> deleteProduct(String productId) {
    return remoteDataSource.deleteProduct(productId);
  }
}
