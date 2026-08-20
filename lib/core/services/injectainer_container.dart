import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/add_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/update_product.dart';
import '../../features/products/presentation/manager/product_cubit.dart';

class InjectionContainer {
  static late ProductCubit productCubit;

  static void init() {
    // 1. Data Source
    final ProductRemoteDataSource remoteDataSource = ProductRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );

    // 2. Repository
    final ProductRepository repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    // 3. Use Cases
    final getProducts = GetProducts(repository);
    final addProduct = AddProduct(repository);
    final updateProduct = UpdateProduct(repository);
    final deleteProduct = DeleteProduct(repository);

    // 4. Cubit
    productCubit = ProductCubit(
      getProductsUseCase: getProducts,
      addProductUseCase: addProduct,
      updateProductUseCase: updateProduct,
      deleteProductUseCase: deleteProduct,
    );
  }
}