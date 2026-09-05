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
  String get carStore => 'Store';

  @override
  String get searchForCar => 'Search for products...';

  @override
  String get noCars => 'No products available';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavoriteCars => 'No products in favorites';

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
    return '$count products';
  }

  @override
  String get addCar => 'Add Product';

  @override
  String get editCar => 'Edit Product';

  @override
  String get carName => 'Product Name';

  @override
  String get enterCarName => 'Enter product name';

  @override
  String get price => 'Price';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get manufactureYear => 'Manufacture Year / Model';

  @override
  String get enterManufactureYear => 'Enter year or model';

  @override
  String get invalidYear => 'Invalid year';

  @override
  String get brand => 'Brand / Category';

  @override
  String get enterBrand => 'Enter brand or category';

  @override
  String get location => 'Location';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get chooseImage => 'Product Image URL';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get enterDescription => 'Enter description';

  @override
  String get chooseImageFirst => 'Please enter or choose an image first';

  @override
  String get carAddedSuccessfully => 'Product added successfully';

  @override
  String get changesSavedSuccessfully => 'Changes saved successfully';

  @override
  String get addCarButton => 'Add Product';

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
  String get totalCars => 'Total Products';

  @override
  String get totalBrands => 'Total Brands';

  @override
  String get totalPrices => 'Total Inventory Value';

  @override
  String get manageCars => 'Manage Products';

  @override
  String get open => 'Open';

  @override
  String get deleteCar => 'Delete Product';

  @override
  String get deleteCarConfirmation => 'Are you sure you want to delete this product?';

  @override
  String get carDeletedSuccessfully => 'Product deleted successfully';

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
  String get retry => 'Retry';

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

  @override
  String get controlCenter => 'Control Center';

  @override
  String get adminSubtitle => 'Manage inventory, customer chats & orders';

  @override
  String get overviewStats => 'Overview Statistics';

  @override
  String get quickActions => 'Quick Management Actions';

  @override
  String get addCarSubtitle => 'Add a new product to the store inventory';

  @override
  String get manageCarsSubtitle => 'Edit, update prices, or remove products';

  @override
  String get customerChats => 'Customer Inquiries & Support';

  @override
  String get customerChatsSubtitle => 'Live chat and support conversation center';

  @override
  String get storeLocation => 'Store Location';

  @override
  String get storeLocationSubtitle => 'Pin and save your store location on the map';

  @override
  String get customerOrdersSubtitle => 'View and track incoming customer orders';

  @override
  String get supportChats => 'Support Chats';

  @override
  String get active => 'Active';

  @override
  String get chatDetails => 'Chat Details';

  @override
  String get noConversations => 'No conversations yet';

  @override
  String get noMessagesInChat => 'No messages in this chat';

  @override
  String get typeResponse => 'Type response to customer...';

  @override
  String get customerMessagesAppearHere => 'Customer messages will appear here';

  @override
  String get searchConversations => 'Search by customer name or message...';

  @override
  String get allConversations => 'All';

  @override
  String get unreadConversations => 'Unread';

  @override
  String conversationCount(Object count) {
    return '$count conversations';
  }

  @override
  String get noMatchingConversations => 'No matching conversations';

  @override
  String get noMessagesPreview => 'No messages yet';

  @override
  String get customer => 'Customer';

  @override
  String get userProfile => 'User Profile';

  @override
  String get email => 'Email';

  @override
  String get userId => 'User ID';

  @override
  String get close => 'Close';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notifications right now';

  @override
  String get notificationsSubtitle => 'You will receive updates and alerts here';

  @override
  String get manageProducts => 'Manage Products';

  @override
  String get products => 'Products';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productName => 'Product Name';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get totalProducts => 'Total Products';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteProductConfirmation => 'Are you sure you want to delete this product?';

  @override
  String get productDeletedSuccessfully => 'Product deleted successfully';

  @override
  String get productAddedSuccessfully => 'Product added successfully';

  @override
  String get addProductButton => 'Add Product';

  @override
  String get addProductSubtitle => 'Add a new product to the store inventory';

  @override
  String get manageProductsSubtitle => 'Edit, update prices, or remove products';

  @override
  String get noProductsAvailable => 'No products available';

  @override
  String get deliveryLocation => 'Delivery Address';

  @override
  String get searchDeliveryAddress => 'Search for your address...';

  @override
  String get search => 'Search';

  @override
  String get selectDeliveryLocation => 'Select Delivery Address';

  @override
  String get tapMapToSelectLocation => 'Tap the map to select your address';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get confirmLocation => 'Confirm Delivery Address';

  @override
  String get selectedLocation => 'Selected Address';

  @override
  String get locationSearchNotFound => 'Address not found. Try another search.';

  @override
  String get locationSearchFailed => 'Search failed. Check your internet connection.';

  @override
  String get locationPermissionRequired => 'Please enable GPS and allow location access.';

  @override
  String get openSettings => 'Settings';

  @override
  String get locationError => 'Unable to get your current location.';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get recenterMap => 'Recenter map';

  @override
  String get deliveryDetails => 'Delivery Details';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get apartmentNumber => 'Apartment Number';

  @override
  String get buildingNumber => 'Building Number';

  @override
  String get floorNumber => 'Floor Number';

  @override
  String get additionalDetails => 'Additional Details';

  @override
  String get enterFirstName => 'Enter your first name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get enterApartmentNumber => 'Enter your apartment number';

  @override
  String get enterBuildingNumber => 'Enter your building number';

  @override
  String get enterFloorNumber => 'Enter your floor number';

  @override
  String get enterAdditionalDetails => 'Enter additional details';

  @override
  String get continue => 'Continue';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidPhoneNumber => 'Enter a valid phone number';
}
