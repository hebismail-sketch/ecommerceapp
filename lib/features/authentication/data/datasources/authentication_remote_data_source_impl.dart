import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/core/notifications/notification_service.dart';
import 'package:ecommerceapp/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ecommerceapp/features/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Implementation of [AuthenticationRemoteDataSource]
/// Handles Firebase Authentication and Firestore operations
class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthenticationRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Save notification token
      await NotificationService.saveToken(uid);

      // Fetch user data from Firestore
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw Exception('User document not found');
      }

      final data = doc.data()!;

      return UserModel(
        uid: uid,
        email: email,
        username: data['username'] as String? ?? '',
        role: data['role'] as String? ?? AppConstants.userRole,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Create user document in Firestore
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set({
        'uid': uid,
        'email': email,
        'username': username,
        'role': AppConstants.userRole,
      });

      // Save notification token
      await NotificationService.saveToken(uid);

      return UserModel(
        uid: uid,
        email: email,
        username: username,
        role: AppConstants.userRole,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }

      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;

      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: data['username'] as String? ?? '',
        role: data['role'] as String? ?? AppConstants.userRole,
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<void> saveDeviceToken(String userId) async {
    try {
      await NotificationService.saveToken(userId);
    } catch (e) {
      throw Exception('Failed to save device token: $e');
    }
  }
}

