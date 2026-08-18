class AppConstants {
  AppConstants._();

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String favoritesCollection = 'favorites';
  static const String cartsCollection = 'carts';
  // User Roles
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  // Routes
  static const String loginRoute = 'login';
  static const String registerRoute = 'register';
  static const String homeRoute = 'home';
  static const String adminHomeRoute = 'adminHome';
  static const String manageCarsRoute = 'manageCars';
  static const String addCarRoute = 'addCar';
}