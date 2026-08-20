import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<CartEntity>> getCartItems(String userId) {
    // Forward the call to the data source
    return remoteDataSource.getCartItems(userId);
  }

  @override
  Future<void> addToCart(String userId, CartEntity cartItem) {
    // Convert Entity to Model before adding to data source
    final cartModel = CartModel(
      id: cartItem.id,
      productId: cartItem.productId,
      quantity: cartItem.quantity,
      price: cartItem.price,
    );
    return remoteDataSource.addToCart(userId, cartModel);
  }

  @override
  Future<void> updateCartItem(CartEntity cartItem) {
    // Convert Entity to Model before updating
    final cartModel = CartModel(
      id: cartItem.id,
      productId: cartItem.productId,
      quantity: cartItem.quantity,
      price: cartItem.price,
    );
    return remoteDataSource.updateCartItem(cartModel);
  }

  @override
  Future<void> deleteCartItem(String cartId) {
    // Directly delete using ID
    return remoteDataSource.deleteCartItem(cartId);
  }
}