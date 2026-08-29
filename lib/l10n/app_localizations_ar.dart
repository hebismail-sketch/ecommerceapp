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
  String get chooseImageFirst => 'اختاري صورة أولاً';

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
}
