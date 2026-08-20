import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Stream<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel productModel);
  Future<void> updateProduct(String productId, ProductModel productModel);
  Future<void> deleteProduct(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<ProductModel>> getProducts() {
    return firestore
        .collection('products')
        .orderBy('year', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.id, doc.data()))
            .toList());
  }

  @override
  Future<void> addProduct(ProductModel productModel) {
    return firestore.collection('products').add(productModel.toJson());
  }

  @override
  Future<void> updateProduct(String productId, ProductModel productModel) {
    return firestore.collection('products').doc(productId).update(productModel.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) {
    return firestore.collection('products').doc(productId).delete();
  }
}
