// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get appearance => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get general => 'عام';

  @override
  String get account => 'الحساب';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get chooseTheme => 'اختر المظهر';

  @override
  String get cancel => 'إلغاء';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get carStore => 'متجر السيارات';

  @override
  String get searchForCar => 'ابحث عن سيارة...';

  @override
  String get noCars => 'لا توجد سيارات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get noFavoriteCars => 'لا توجد سيارات في المفضلة';

  @override
  String get cart => 'السلة';

  @override
  String get emptyCart => 'السلة فارغة';

  @override
  String get egp => ' ج.م';

  @override
  String get total => 'الإجمالي:';

  @override
  String get confirmOrder => 'تأكيد الطلب';

  @override
  String get orderConfirmedTitle => 'تم تأكيد الطلب 🎉';

  @override
  String orderCreatedSuccessfully(Object price, Object egp) {
    return 'تم إنشاء طلبك بنجاح بقيمة $price $egp';
  }

  @override
  String get orderConfirmedSuccessfully => 'تم تأكيد الطلب بنجاح';

  @override
  String get home => 'الرئيسية';

  @override
  String get orders => 'طلباتي';

  @override
  String get details => 'التفاصيل';

  @override
  String get newItem => 'جديد';

  @override
  String get description => 'الوصف:';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get noOrders => 'لا توجد طلبات حتى الآن';

  @override
  String orderNumber(Object id) {
    return 'طلب #$id';
  }

  @override
  String get grandTotal => 'الإجمالي';

  @override
  String carsCount(Object count) {
    return '$count سيارة';
  }

  @override
  String get addCar => 'إضافة سيارة';

  @override
  String get editCar => 'تعديل سيارة';

  @override
  String get carName => 'اسم السيارة';

  @override
  String get enterCarName => 'ادخل اسم السيارة';

  @override
  String get price => 'السعر';

  @override
  String get enterPrice => 'ادخل السعر';

  @override
  String get invalidPrice => 'السعر غير صحيح';

  @override
  String get manufactureYear => 'سنة الصنع';

  @override
  String get enterManufactureYear => 'ادخل سنة الصنع';

  @override
  String get invalidYear => 'السنة غير صحيحة';

  @override
  String get brand => 'الماركة';

  @override
  String get enterBrand => 'ادخل الماركة';

  @override
  String get location => 'الموقع';

  @override
  String get enterLocation => 'ادخل الموقع';

  @override
  String get noImageSelected => 'لم يتم اختيار صورة';

  @override
  String get chooseImage => 'اختيار صورة';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get enterDescription => 'ادخل الوصف';

  @override
  String get chooseImageFirst => 'اختر صورة أولاً';

  @override
  String get carAddedSuccessfully => 'تمت إضافة السيارة بنجاح';

  @override
  String get changesSavedSuccessfully => 'تم حفظ التعديلات بنجاح';

  @override
  String get addCarButton => 'إضافة السيارة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get delete => 'حذف';

  @override
  String get deleteConfirmation => 'هل أنت متأكد من الحذف؟';

  @override
  String get exit => 'خروج';

  @override
  String get adminDashboard => 'لوحة تحكم المسؤول';

  @override
  String get totalCars => 'عدد السيارات';

  @override
  String get totalBrands => 'عدد الماركات';

  @override
  String get totalPrices => 'إجمالي الأسعار';

  @override
  String get manageCars => 'إدارة السيارات';

  @override
  String get open => 'فتح';

  @override
  String get deleteCar => 'حذف السيارة';

  @override
  String get deleteCarConfirmation => 'هل أنت متأكد من حذف السيارة؟';

  @override
  String get carDeletedSuccessfully => 'تم حذف السيارة بنجاح';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get invalidUsername => 'الرجاء إدخال اسم مستخدم صحيح';

  @override
  String get invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';

  @override
  String get register => 'تسجيل';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح';

  @override
  String get invalidCredentials => 'يرجى ملء جميع الحقول';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get profilePicture => 'صورة الملف الشخصي';

  @override
  String get deleteImage => 'حذف الصورة';

  @override
  String get myAccount => 'حسابي';

  @override
  String get user => 'المستخدم';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get failedToSaveChanges => 'فشل حفظ التعديلات';

  @override
  String get chat => 'الدردشة';

  @override
  String get bestSeller => 'الأكثر مبيعاً!';

  @override
  String get bannerHeadline => 'اكتشف رحلة التسوق المثالية!';

  @override
  String get shopNow => 'تسوق الآن!';

  @override
  String get categories => 'الأقسام';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get recommended => 'الموصى بها';

  @override
  String sold(Object count) {
    return 'تم بيع $count';
  }

  @override
  String get watches => 'ساعات';

  @override
  String get bags => 'حقائب';

  @override
  String get beauty => 'تجميل';

  @override
  String get clothing => 'ملابس';

  @override
  String get accessories => 'إكسسوارات';

  @override
  String get cars => 'سيارات';

  @override
  String get pleaseLoginFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get controlCenter => 'مركز التحكم';

  @override
  String get adminSubtitle => 'إدارة المخزون ومحادثات العملاء والطلبات';

  @override
  String get overviewStats => 'إحصائيات عامة';

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String get addCarSubtitle => 'إضافة منتج جديد لمخزون المتجر';

  @override
  String get manageCarsSubtitle => 'تعديل أو تحديث الأسعار أو حذف المنتجات';

  @override
  String get customerChats => 'محادثات واستفسارات العملاء';

  @override
  String get customerChatsSubtitle => 'مركز المحادثات والدعم الفني المباشر';

  @override
  String get storeLocation => 'موقع المتجر';

  @override
  String get storeLocationSubtitle => 'تثبيت وحفظ موقع المتجر على الخريطة';

  @override
  String get customerOrdersSubtitle => 'عرض ومتابعة طلبات العملاء الواردة';

  @override
  String get supportChats => 'محادثات الدعم';

  @override
  String get active => 'نشطة';

  @override
  String get chatDetails => 'تفاصيل المحادثة';

  @override
  String get noConversations => 'لا توجد محادثات حتى الآن';

  @override
  String get noMessagesInChat => 'لا توجد رسائل في هذه المحادثة';

  @override
  String get typeResponse => 'اكتب الرد للعميل...';

  @override
  String get customerMessagesAppearHere => 'ستظهر رسائل واستفسارات العملاء هنا';

  @override
  String get searchConversations => 'ابحث باسم العميل أو نص الرسالة...';

  @override
  String get allConversations => 'الكل';

  @override
  String get unreadConversations => 'غير المقروءة';

  @override
  String conversationCount(Object count) {
    return '$count محادثة';
  }

  @override
  String get noMatchingConversations => 'لا توجد محادثات مطابقة';

  @override
  String get noMessagesPreview => 'لا توجد رسائل بعد';

  @override
  String get customer => 'عميل';

  @override
  String get userProfile => 'الملف الشخصي للمستخدم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get userId => 'معرّف المستخدم';

  @override
  String get close => 'إغلاق';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات حالياً';

  @override
  String get notificationsSubtitle => 'ستتلقى التنبيهات والتحديثات الجديدة هنا';

  @override
  String get manageProducts => 'إدارة المنتجات';

  @override
  String get products => 'المنتجات';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get editProduct => 'تعديل منتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get enterProductName => 'ادخل اسم المنتج';

  @override
  String get totalProducts => 'إجمالي المنتجات';

  @override
  String get deleteProduct => 'حذف المنتج';

  @override
  String get deleteProductConfirmation => 'هل أنت متأكد من حذف هذا المنتج؟';

  @override
  String get productDeletedSuccessfully => 'تم حذف المنتج بنجاح';

  @override
  String get productAddedSuccessfully => 'تمت إضافة المنتج بنجاح';

  @override
  String get addProductButton => 'إضافة المنتج';

  @override
  String get addProductSubtitle => 'إضافة منتج جديد لمخزون المتجر';

  @override
  String get manageProductsSubtitle => 'تعديل أو تحديث الأسعار أو حذف المنتجات';

  @override
  String get noProductsAvailable => 'لا توجد منتجات متوفرة';

  @override
  String get deliveryLocation => 'عنوان التوصيل';

  @override
  String get searchDeliveryAddress => 'ابحث عن عنوانك...';

  @override
  String get search => 'بحث';

  @override
  String get selectDeliveryLocation => 'اختيار عنوان التوصيل';

  @override
  String get tapMapToSelectLocation => 'اضغط على الخريطة لتحديد عنوانك';

  @override
  String get useCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get confirmLocation => 'تأكيد عنوان التوصيل';

  @override
  String get selectedLocation => 'العنوان المحدد';

  @override
  String get locationSearchNotFound =>
      'لم يتم العثور على العنوان. جرّب بحثًا آخر.';

  @override
  String get locationSearchFailed => 'فشل البحث. تحقق من اتصال الإنترنت.';

  @override
  String get locationPermissionRequired =>
      'فعّل GPS واسمح للتطبيق بالوصول إلى موقعك.';

  @override
  String get openSettings => 'الإعدادات';

  @override
  String get locationError => 'تعذر تحديد موقعك الحالي.';

  @override
  String get zoomIn => 'تكبير الخريطة';

  @override
  String get zoomOut => 'تصغير الخريطة';

  @override
  String get recenterMap => 'إعادة توسيط الخريطة';

  @override
  String get deliveryDetails => 'بيانات التوصيل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get apartmentNumber => 'رقم الشقة';

  @override
  String get buildingNumber => 'رقم العمارة';

  @override
  String get floorNumber => 'رقم الدور';

  @override
  String get additionalDetails => 'تفاصيل إضافية';

  @override
  String get enterFirstName => 'اكتب الاسم الأول';

  @override
  String get enterLastName => 'اكتب اسم العائلة';

  @override
  String get enterPhoneNumber => 'اكتب رقم الهاتف';

  @override
  String get enterApartmentNumber => 'اكتب رقم الشقة';

  @override
  String get enterBuildingNumber => 'اكتب رقم العمارة';

  @override
  String get enterFloorNumber => 'اكتب رقم الدور';

  @override
  String get enterAdditionalDetails => 'اكتب أي تفاصيل إضافية';

  @override
  String get continueButton => 'متابعة';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidPhoneNumber => 'اكتب رقم هاتف صحيح';
}
