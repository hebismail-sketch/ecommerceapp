import 'package:cloud_firestore/cloud_firestore.dart';

// Product Feature Imports
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/add_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/update_product.dart';
import '../../features/products/presentation/manager/product_cubit.dart';

// Cart Feature Imports
import '../../features/carts/data/datasources/cart_remote_data_source.dart';
import '../../features/carts/data/repositories/cart_repository_impl.dart';
import '../../features/carts/domain/repositories/cart_repository.dart';
import '../../features/carts/domain/usecases/add_to_cart.dart';
import '../../features/carts/domain/usecases/delete_cart_item.dart';
import '../../features/carts/domain/usecases/get_cart_items.dart';
import '../../features/carts/domain/usecases/update_cart_item.dart';
import '../../features/carts/presentation/manager/cart_cubit.dart';

// Favorite Feature Imports
import '../../features/favorites/data/datasources/favorite_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorite_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/delete_favorite.dart';
import '../../features/favorites/presentation/manager/favorite_cubit.dart';

class InjectionContainer {
  static late ProductCubit productCubit;
  static late CartCubit cartCubit;
  static late FavoriteCubit favoriteCubit;

  static void init() {
    final firestore = FirebaseFirestore.instance;

    // ==========================================
    // 1. PRODUCTS FEATURE INITIALIZATION
    // ==========================================
    final ProductRemoteDataSource productRemoteDataSource =
        ProductRemoteDataSourceImpl(firestore: firestore);
    final ProductRepository productRepository =
        ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
    productCubit = ProductCubit(
      getProductsUseCase: GetProducts(productRepository),
      addProductUseCase: AddProduct(productRepository),
      updateProductUseCase: UpdateProduct(productRepository),
      deleteProductUseCase: DeleteProduct(productRepository),
    );

    // ==========================================
    // 2. CARTS FEATURE INITIALIZATION
    // ==========================================
    final CartRemoteDataSource cartRemoteDataSource =
        CartRemoteDataSourceImpl(firestore: firestore);
    final CartRepository cartRepository =
        CartRepositoryImpl(remoteDataSource: cartRemoteDataSource);
    cartCubit = CartCubit(
      getCartItemsUseCase: GetCartItems(cartRepository),
      addToCartUseCase: AddToCart(cartRepository),
      updateCartItemUseCase: UpdateCartItem(cartRepository),
      deleteCartItemUseCase: DeleteCartItem(cartRepository),
    );

    // ==========================================
    // 3. FAVORITES FEATURE INITIALIZATION
    // ==========================================
    final FavoriteRemoteDataSource favoriteRemoteDataSource =
        FavoriteRemoteDataSourceImpl(firestore: firestore);
    final FavoriteRepository favoriteRepository =
        FavoriteRepositoryImpl(remoteDataSource: favoriteRemoteDataSource);
    favoriteCubit = FavoriteCubit(
      getFavoritesUseCase: GetFavorites(favoriteRepository),
      addFavoriteUseCase: AddFavorite(favoriteRepository),
      deleteFavoriteUseCase: DeleteFavorite(favoriteRepository),
    );
  }
}
