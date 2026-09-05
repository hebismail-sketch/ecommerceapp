import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @carStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get carStore;

  /// No description provided for @searchForCar.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchForCar;

  /// No description provided for @noCars.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noCars;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @noFavoriteCars.
  ///
  /// In en, this message translates to:
  /// **'No products in favorites'**
  String get noFavoriteCars;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **' EGP'**
  String get egp;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get total;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed 🎉'**
  String get orderConfirmedTitle;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your order was created successfully for {price} {egp}'**
  String orderCreatedSuccessfully(Object price, Object egp);

  /// No description provided for @orderConfirmedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed successfully'**
  String get orderConfirmedSuccessfully;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get orders;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newItem;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get description;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(Object id);

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get grandTotal;

  /// No description provided for @carsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String carsCount(Object count);

  /// No description provided for @addCar.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addCar;

  /// No description provided for @editCar.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editCar;

  /// No description provided for @carName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get carName;

  /// No description provided for @enterCarName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterCarName;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// No description provided for @manufactureYear.
  ///
  /// In en, this message translates to:
  /// **'Manufacture Year / Model'**
  String get manufactureYear;

  /// No description provided for @enterManufactureYear.
  ///
  /// In en, this message translates to:
  /// **'Enter year or model'**
  String get enterManufactureYear;

  /// No description provided for @invalidYear.
  ///
  /// In en, this message translates to:
  /// **'Invalid year'**
  String get invalidYear;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand / Category'**
  String get brand;

  /// No description provided for @enterBrand.
  ///
  /// In en, this message translates to:
  /// **'Enter brand or category'**
  String get enterBrand;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Product Image URL'**
  String get chooseImage;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// No description provided for @chooseImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter or choose an image first'**
  String get chooseImageFirst;

  /// No description provided for @carAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get carAddedSuccessfully;

  /// No description provided for @changesSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changesSavedSuccessfully;

  /// No description provided for @addCarButton.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addCarButton;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get deleteConfirmation;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @totalCars.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalCars;

  /// No description provided for @totalBrands.
  ///
  /// In en, this message translates to:
  /// **'Total Brands'**
  String get totalBrands;

  /// No description provided for @totalPrices.
  ///
  /// In en, this message translates to:
  /// **'Total Inventory Value'**
  String get totalPrices;

  /// No description provided for @manageCars.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get manageCars;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @deleteCar.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteCar;

  /// No description provided for @deleteCarConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get deleteCarConfirmation;

  /// No description provided for @carDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get carDeletedSuccessfully;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid username'**
  String get invalidUsername;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get invalidCredentials;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpectedError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @failedToSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get failedToSaveChanges;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @bestSeller.
  ///
  /// In en, this message translates to:
  /// **'Best Seller!'**
  String get bestSeller;

  /// No description provided for @bannerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Discover the perfect shopping journey!'**
  String get bannerHeadline;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now!'**
  String get shopNow;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'{count} Sold'**
  String sold(Object count);

  /// No description provided for @watches.
  ///
  /// In en, this message translates to:
  /// **'Watches'**
  String get watches;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'Bags'**
  String get bags;

  /// No description provided for @beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get beauty;

  /// No description provided for @clothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get clothing;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @cars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get pleaseLoginFirst;

  /// No description provided for @controlCenter.
  ///
  /// In en, this message translates to:
  /// **'Control Center'**
  String get controlCenter;

  /// No description provided for @adminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage inventory, customer chats & orders'**
  String get adminSubtitle;

  /// No description provided for @overviewStats.
  ///
  /// In en, this message translates to:
  /// **'Overview Statistics'**
  String get overviewStats;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Management Actions'**
  String get quickActions;

  /// No description provided for @addCarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new product to the store inventory'**
  String get addCarSubtitle;

  /// No description provided for @manageCarsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit, update prices, or remove products'**
  String get manageCarsSubtitle;

  /// No description provided for @customerChats.
  ///
  /// In en, this message translates to:
  /// **'Customer Inquiries & Support'**
  String get customerChats;

  /// No description provided for @customerChatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live chat and support conversation center'**
  String get customerChatsSubtitle;

  /// No description provided for @storeLocation.
  ///
  /// In en, this message translates to:
  /// **'Store Location'**
  String get storeLocation;

  /// No description provided for @storeLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pin and save your store location on the map'**
  String get storeLocationSubtitle;

  /// No description provided for @customerOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and track incoming customer orders'**
  String get customerOrdersSubtitle;

  /// No description provided for @supportChats.
  ///
  /// In en, this message translates to:
  /// **'Support Chats'**
  String get supportChats;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @chatDetails.
  ///
  /// In en, this message translates to:
  /// **'Chat Details'**
  String get chatDetails;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @noMessagesInChat.
  ///
  /// In en, this message translates to:
  /// **'No messages in this chat'**
  String get noMessagesInChat;

  /// No description provided for @typeResponse.
  ///
  /// In en, this message translates to:
  /// **'Type response to customer...'**
  String get typeResponse;

  /// No description provided for @customerMessagesAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Customer messages will appear here'**
  String get customerMessagesAppearHere;

  /// No description provided for @searchConversations.
  ///
  /// In en, this message translates to:
  /// **'Search by customer name or message...'**
  String get searchConversations;

  /// No description provided for @allConversations.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allConversations;

  /// No description provided for @unreadConversations.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadConversations;

  /// No description provided for @conversationCount.
  ///
  /// In en, this message translates to:
  /// **'{count} conversations'**
  String conversationCount(Object count);

  /// No description provided for @noMatchingConversations.
  ///
  /// In en, this message translates to:
  /// **'No matching conversations'**
  String get noMatchingConversations;

  /// No description provided for @noMessagesPreview.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesPreview;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications right now'**
  String get noNotifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will receive updates and alerts here'**
  String get notificationsSubtitle;

  /// No description provided for @manageProducts.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get manageProducts;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get deleteProductConfirmation;

  /// No description provided for @productDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccessfully;

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedSuccessfully;

  /// No description provided for @addProductButton.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProductButton;

  /// No description provided for @addProductSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new product to the store inventory'**
  String get addProductSubtitle;

  /// No description provided for @manageProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit, update prices, or remove products'**
  String get manageProductsSubtitle;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// No description provided for @deliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryLocation;

  /// No description provided for @searchDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for your address...'**
  String get searchDeliveryAddress;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @selectDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Address'**
  String get selectDeliveryLocation;

  /// No description provided for @tapMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to select your address'**
  String get tapMapToSelectLocation;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery Address'**
  String get confirmLocation;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Address'**
  String get selectedLocation;

  /// No description provided for @locationSearchNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found. Try another search.'**
  String get locationSearchNotFound;

  /// No description provided for @locationSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Check your internet connection.'**
  String get locationSearchFailed;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enable GPS and allow location access.'**
  String get locationPermissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettings;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Unable to get your current location.'**
  String get locationError;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @recenterMap.
  ///
  /// In en, this message translates to:
  /// **'Recenter map'**
  String get recenterMap;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @apartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Apartment Number'**
  String get apartmentNumber;

  /// No description provided for @buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building Number'**
  String get buildingNumber;

  /// No description provided for @floorNumber.
  ///
  /// In en, this message translates to:
  /// **'Floor Number'**
  String get floorNumber;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetails;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterApartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your apartment number'**
  String get enterApartmentNumber;

  /// No description provided for @enterBuildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your building number'**
  String get enterBuildingNumber;

  /// No description provided for @enterFloorNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your floor number'**
  String get enterFloorNumber;

  /// No description provided for @enterAdditionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter additional details'**
  String get enterAdditionalDetails;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhoneNumber;

  String get emptyCartMessage;
  String get cashOnDelivery;
  String get paymentMethod;
  String get orderCreationFailed;
  String get defaultUserName;
  String get startSupportConversation;
  String get typeMessageHint;
  String get supportChat;
  String get onlineSupport;
  String get deliveryLocationSelected;
  String get recipientDetails;
  String get addressDetails;
  String get streetAndArea;
  String get phoneHint;
  String get streetHint;
  String get notesHint;
  String get saveOrderDetails;
  String get aboutDescription;
  String appVersion(String version);
  String get aboutDetails;
  String get addressNotFound;
  String get locationSelectedSuccessfully;
  String get currentLocationError;
  String get storeLocationPickerTitle;
  String get back;
  String get searchStoreAddressHint;
  String get mapLocationInstructions;
  String selectedLocationWithCoordinates(String latitude, String longitude);
  String get confirmAndSaveStoreLocation;
  String get store;
  String get yourLocation;
  String coordinates(String latitude, String longitude);
  String get calculatingDistance;
  String distanceInKilometers(String distance);
  String get distanceUnavailable;
  String get focusOnStore;
  String get defaultStoreName;
  String get storeCoordinatesUnavailable;
  String get viewStoreLocationAndDistance;
  String get storeLocationNotSet;
  String get noDescription;
  String get favoritesEmptyMessage;
  String get customerOrders;
  String get ordersLoadFailed;
  String get checkConnectionAndRetry;
  String get ordersEmptyMessage;
  String get incomingCustomerOrders;
  String get orderHistory;
  String get orderConfirmedStatus;
  String get orderPendingStatus;
  String translationFailed(String error);
  String get productImageUrlHint;
  String get translating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
