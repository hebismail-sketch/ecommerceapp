import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerceapp/features/home/data/models/home_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<HomeModel> getHomeData(String userId) async {
    try {
      final userDoc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final username = userDoc.data()?['username'] as String? ?? '';

      return HomeModel(
        userId: userId,
        featuredProductIds: await getFeaturedProductIds(),
        userGreeting: 'Welcome, $username',
      );
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  @override
  Future<List<String>> getFeaturedProductIds() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.productsCollection)
          .limit(5)
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('Failed to get featured products: $e');
    }
  }
}