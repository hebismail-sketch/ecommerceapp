import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Authentication Feature Imports
import '../../features/authentication/data/datasources/authentication_remote_data_source.dart';
import '../../features/authentication/data/datasources/authentication_remote_data_source_impl.dart';
import '../../features/authentication/data/repositories/authentication_repository_impl.dart';
import '../../features/authentication/domain/repositories/authentication_repository.dart';
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/domain/usecases/save_device_token_usecase.dart';
import '../../features/authentication/presentation/manager/authentication_bloc.dart';

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
// Home Feature Imports
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/home/presentation/manager/home_cubit.dart';
class InjectionContainer {
  static late ProductCubit productCubit;
  static late CartCubit cartCubit;
  static late FavoriteCubit favoriteCubit;
  static late HomeCubit homeCubit;
  static late AuthenticationBloc authenticationBloc;

  static void init() {
    final firestore = FirebaseFirestore.instance;
    final firebaseAuth = FirebaseAuth.instance;

    // ==========================================
    // 0. AUTHENTICATION FEATURE INITIALIZATION
    // ==========================================
    final AuthenticationRemoteDataSource authRemoteDataSource =
        AuthenticationRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    );
    final AuthenticationRepository authRepository =
        AuthenticationRepositoryImpl(remoteDataSource: authRemoteDataSource);
    authenticationBloc = AuthenticationBloc(
      loginUseCase: LoginUseCase(repository: authRepository),
      registerUseCase: RegisterUseCase(repository: authRepository),
      logoutUseCase: LogoutUseCase(repository: authRepository),
      getCurrentUserUseCase: GetCurrentUserUseCase(repository: authRepository),
      saveDeviceTokenUseCase: SaveDeviceTokenUseCase(repository: authRepository),
    );
        // ==========================================
    // 1. HOME FEATURE INITIALIZATION
    // ==========================================
    final HomeRemoteDataSource homeRemoteDataSource =
        HomeRemoteDataSourceImpl(firestore: firestore);
    final HomeRepository homeRepository =
        HomeRepositoryImpl(remoteDataSource: homeRemoteDataSource);
    homeCubit = HomeCubit(
      getHomeDataUseCase: GetHomeDataUseCase(repository: homeRepository),
    );

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
