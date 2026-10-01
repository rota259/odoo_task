// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => '2S Home Wear';

  @override
  String get brandShort => '2S';

  @override
  String get brandRest => ' Home Wear';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول بحساب أودو الخاص بك';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get serverSettings => 'إعدادات الخادم';

  @override
  String get serverUrl => 'عنوان الخادم';

  @override
  String get database => 'قاعدة البيانات';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidUrl => 'أدخل عنوان http(s) صالحًا';

  @override
  String get errorWrongCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get errorUnreachable =>
      'تعذّر الوصول إلى الخادم. تحقّق من العنوان والاتصال.';

  @override
  String get errorWrongDatabase => 'قاعدة البيانات غير موجودة على هذا الخادم.';

  @override
  String get errorSessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorUnknown => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get errorOffline => 'أنت غير متصل.';

  @override
  String get customers => 'العملاء';

  @override
  String get salesOrders => 'أوامر البيع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get logoutConfirmBody =>
      'سيتم حذف البيانات المخزّنة والتعديلات غير المتزامنة من هذا الجهاز.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get save => 'حفظ';

  @override
  String get menu => 'القائمة';

  @override
  String get searchCustomers => 'ابحث عن العملاء بالاسم';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get noCustomers => 'لا يوجد عملاء';

  @override
  String get noCustomersHint => 'جرّب بحثًا مختلفًا أو اسحب للتحديث.';

  @override
  String get offlineBanner => 'غير متصل – يتم عرض البيانات المخزّنة';

  @override
  String get offlineTitle => 'أنت غير متصل';

  @override
  String get salesOfflineBody =>
      'تحتاج أوامر البيع إلى اتصال. ستظهر عند عودتك للاتصال.';

  @override
  String get pendingSync => 'بانتظار المزامنة';

  @override
  String get emptyValue => '—';

  @override
  String get customerDetails => 'تفاصيل العميل';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get address => 'العنوان';

  @override
  String get editPhone => 'تعديل الهاتف';

  @override
  String get invalidPhone =>
      'أدخل رقم هاتف صالحًا (أرقام ومسافات و + - ( ) فقط)';

  @override
  String get phoneSaved => 'تم حفظ رقم الهاتف';

  @override
  String get phoneSavedOffline =>
      'تم الحفظ دون اتصال – ستتم المزامنة عند عودة الاتصال';

  @override
  String get selectCustomer => 'اختر عميلًا لعرض التفاصيل';

  @override
  String get selectOrder => 'اختر أمرًا لعرض التفاصيل';

  @override
  String changesSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت مزامنة $count تغيير',
      many: 'تمت مزامنة $count تغييرًا',
      few: 'تمت مزامنة $count تغييرات',
      two: 'تمت مزامنة تغييرين',
      one: 'تمت مزامنة تغيير واحد',
      zero: 'لم تتم مزامنة أي تغيير',
    );
    return '$_temp0';
  }

  @override
  String get noOrders => 'لا توجد أوامر بيع بعد';

  @override
  String get orderLines => 'بنود الأمر';

  @override
  String get orderDate => 'تاريخ الأمر';

  @override
  String get customer => 'العميل';

  @override
  String get status => 'الحالة';

  @override
  String get untaxedAmount => 'المبلغ قبل الضريبة';

  @override
  String get taxes => 'الضرائب';

  @override
  String get total => 'الإجمالي';

  @override
  String get noLines => 'لا توجد بنود في هذا الأمر.';

  @override
  String lineQtyPrice(String qty, String price) {
    return '$qty × $price';
  }

  @override
  String get confirmOrder => 'تأكيد الأمر';

  @override
  String get confirmOrderTitle => 'تأكيد هذا الأمر؟';

  @override
  String confirmOrderBody(String order) {
    return 'سيصبح $order أمر بيع. لا يمكن التراجع عن ذلك من التطبيق.';
  }

  @override
  String get orderConfirmed => 'تم تأكيد الأمر';

  @override
  String get stateDraft => 'عرض سعر';

  @override
  String get stateSent => 'تم إرسال عرض السعر';

  @override
  String get stateSale => 'أمر بيع';

  @override
  String get stateDone => 'مقفل';

  @override
  String get stateCancel => 'ملغى';

  @override
  String get stateUnknown => 'غير معروف';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة الجهاز';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get account => 'الحساب';

  @override
  String signedInAs(String name) {
    return 'تم تسجيل الدخول باسم $name';
  }

  @override
  String accountLine(String login, String database) {
    return '$login · $database';
  }

  @override
  String get internalUser => 'مستخدم داخلي';

  @override
  String get portalUser => 'مستخدم بوابة';

  @override
  String get back => 'رجوع';
}
