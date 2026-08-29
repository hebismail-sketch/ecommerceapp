// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutApp => 'About App';

  @override
  String get logout => 'Logout';

  @override
  String get general => 'General';

  @override
  String get account => 'Account';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get carStore => 'Car Store';

  @override
  String get searchForCar => 'Search for a car...';

  @override
  String get noCars => 'No cars available';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavoriteCars => 'No cars in favorites';

  @override
  String get cart => 'Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get egp => ' EGP';

  @override
  String get total => 'Total:';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get orderConfirmedTitle => 'Order Confirmed 🎉';

  @override
  String orderCreatedSuccessfully(Object price, Object egp) {
    return 'Your order was created successfully for $price $egp';
  }

  @override
  String get orderConfirmedSuccessfully => 'Order confirmed successfully';

  @override
  String get home => 'Home';

  @override
  String get orders => 'My Orders';

  @override
  String get details => 'Details';

  @override
  String get newItem => 'New';

  @override
  String get description => 'Description:';

  @override
  String get showMore => 'Show More';

  @override
  String get showLess => 'Show Less';

  @override
  String get noOrders => 'No orders yet';

  @override
  String orderNumber(Object id) {
    return 'Order #$id';
  }

  @override
  String get grandTotal => 'Total';

  @override
  String carsCount(Object count) {
    return '$count cars';
  }

  @override
  String get addCar => 'Add Car';

  @override
  String get editCar => 'Edit Car';

  @override
  String get carName => 'Car Name';

  @override
  String get enterCarName => 'Enter car name';

  @override
  String get price => 'Price';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get manufactureYear => 'Manufacture Year';

  @override
  String get enterManufactureYear => 'Enter manufacture year';

  @override
  String get invalidYear => 'Invalid year';

  @override
  String get brand => 'Brand';

  @override
  String get enterBrand => 'Enter brand';

  @override
  String get location => 'Location';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get chooseImage => 'Choose Image';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get enterDescription => 'Enter description';

  @override
  String get chooseImageFirst => 'Please choose an image first';

  @override
  String get carAddedSuccessfully => 'Car added successfully';

  @override
  String get changesSavedSuccessfully => 'Changes saved successfully';

  @override
  String get addCarButton => 'Add Car';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete?';

  @override
  String get exit => 'Exit';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get totalCars => 'Total Cars';

  @override
  String get totalBrands => 'Total Brands';

  @override
  String get totalPrices => 'Total Prices';

  @override
  String get manageCars => 'Manage Cars';

  @override
  String get open => 'Open';

  @override
  String get deleteCar => 'Delete Car';

  @override
  String get deleteCarConfirmation =>
      'Are you sure you want to delete this car?';

  @override
  String get carDeletedSuccessfully => 'Car deleted successfully';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get signIn => 'Sign in';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get username => 'Username';

  @override
  String get invalidUsername => 'Please enter a valid username';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get register => 'Register';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get invalidCredentials => 'Please fill all fields';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String get profilePicture => 'Profile Picture';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get myAccount => 'My Account';

  @override
  String get user => 'User';

  @override
  String get saving => 'Saving...';

  @override
  String get failedToSaveChanges => 'Failed to save changes';

  @override
  String get chat => 'Chat';

  @override
  String get bestSeller => 'Best Seller!';

  @override
  String get bannerHeadline => 'Discover the perfect shopping journey!';

  @override
  String get shopNow => 'Shop Now!';

  @override
  String get categories => 'Categories';

  @override
  String get seeMore => 'See more';

  @override
  String get recommended => 'Recommended';

  @override
  String sold(Object count) {
    return '$count Sold';
  }

  @override
  String get watches => 'Watches';

  @override
  String get bags => 'Bags';

  @override
  String get beauty => 'Beauty';

  @override
  String get clothing => 'Clothing';

  @override
  String get accessories => 'Accessories';

  @override
  String get cars => 'Cars';

  @override
  String get pleaseLoginFirst => 'Please log in first';
}
