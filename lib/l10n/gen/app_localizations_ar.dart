// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Mazen Store';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get welcomeBackTitle => 'مرحبًا بعودتك';

  @override
  String get welcomeBackSubtitle => 'سجّل الدخول لإدارة المبيعات والمخزون.';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get createAccountSubtitle => 'أنشئ ملفك الشخصي لتبدأ البيع.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get signInFailed => 'فشل تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get enterEmailPassword => 'يرجى إدخال البريد الإلكتروني وكلمة المرور.';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get termsNotice => 'بإنشاء حساب، فإنك توافق على الشروط.';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get sellProduct => 'بيع منتج';

  @override
  String get addWorkHours => 'إضافة ساعات عمل';

  @override
  String get salesToday => 'مبيعات اليوم';

  @override
  String get ordersToday => 'طلبات اليوم';

  @override
  String get itemsSold => 'العناصر المباعة';

  @override
  String get products => 'المنتجات';

  @override
  String get workHours => 'ساعات العمل';

  @override
  String get total => 'الإجمالي';

  @override
  String get orders => 'طلبات';

  @override
  String get items => 'عناصر';

  @override
  String get inInventory => 'في المخزون';

  @override
  String get today => 'اليوم';

  @override
  String get todaysSales => 'مبيعات اليوم';

  @override
  String get refresh => 'تحديث';

  @override
  String get noSalesToday => 'لا توجد مبيعات اليوم.';

  @override
  String get unableToLoadSales => 'تعذّر تحميل المبيعات.';

  @override
  String get unableToLoadReceipt => 'تعذّر تحميل الفاتورة.';

  @override
  String get home => 'الرئيسية';

  @override
  String get inventory => 'المخزون';

  @override
  String get sales => 'المبيعات';

  @override
  String get reports => 'التقارير';

  @override
  String get scanProductCode => 'مسح كود المنتج';

  @override
  String get noCodeScanned => 'لم يتم مسح أي كود بعد';

  @override
  String get scanHint => 'امسح رمز QR أو الباركود لربطه بالمنتج.';

  @override
  String get scanQrBarcode => 'مسح QR / باركود';

  @override
  String get selectProducts => 'اختر المنتجات';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get itemsLabel => 'العناصر';

  @override
  String get submitSale => 'إتمام البيع';

  @override
  String get saleCreated => 'تم إنشاء البيع بنجاح.';

  @override
  String get saleCreatedTitle => 'تم إنشاء البيع';

  @override
  String get enterValidUnitPrice => 'أدخل سعرًا صحيحًا للوحدة.';

  @override
  String get unitPriceOverrideHint => 'تعديل سعر الوحدة (اختياري)';

  @override
  String get enterProductCode => 'أدخل كود المنتج';

  @override
  String get enterProductCodeToast => 'يرجى إدخال كود المنتج.';

  @override
  String get createSaleByCodeTitle => 'إنشاء بيع بالكود';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get unitLabel => 'سعر الوحدة';

  @override
  String get removeItem => 'حذف العنصر';

  @override
  String get scanModeTitle => 'مسح كود المنتج';

  @override
  String get sell => 'بيع';

  @override
  String get selectProductFirst => 'يرجى اختيار منتج أولًا.';

  @override
  String get productNotFound => 'المنتج غير موجود';

  @override
  String get save => 'حفظ';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get productSaved => 'تم حفظ المنتج';

  @override
  String get nameTooShort => 'اسم المنتج يجب ألا يقل عن حرفين';

  @override
  String get enterValidPrice => 'أدخل سعرًا صحيحًا';

  @override
  String get enterValidStock => 'أدخل كمية مخزون صحيحة';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get price => 'السعر';

  @override
  String get quantity => 'الكمية';

  @override
  String get savedDays => 'الأيام المحفوظة';

  @override
  String get cashierWorkHours => 'ساعات عمل الكاشير';

  @override
  String get noWorkHoursForDay => 'لا توجد ساعات عمل لهذا اليوم.';

  @override
  String get noSavedDays => 'لا توجد أيام محفوظة.';

  @override
  String get workHoursSaved => 'تم حفظ ساعات العمل.';

  @override
  String get unableToSaveWorkHours => 'تعذّر حفظ ساعات العمل.';

  @override
  String get unableToLoadWorkHours => 'تعذّر تحميل ساعات العمل.';

  @override
  String get monthlyReport => 'تقرير شهري';

  @override
  String get selectMonth => 'اختر الشهر';

  @override
  String get pick => 'اختيار';

  @override
  String get totalsByUser => 'الإجمالي حسب المستخدم';

  @override
  String get totalsByDay => 'الإجمالي حسب اليوم';

  @override
  String get noUsersYet => 'لا يوجد مستخدمون بعد.';

  @override
  String get noDaysYet => 'لا توجد أيام بعد.';

  @override
  String get reportsTitle => 'التقارير';

  @override
  String get daily => 'يومي';

  @override
  String get monthly => 'شهري';

  @override
  String get dailyReport => 'تقرير يومي';

  @override
  String get monthlyReportTitle => 'تقرير شهري';

  @override
  String get pickDate => 'اختر التاريخ';

  @override
  String get pickMonth => 'اختر الشهر';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get topProducts => 'أفضل المنتجات';

  @override
  String get dailyBreakdown => 'ملخص يومي';

  @override
  String get noReportData => 'لا توجد بيانات للتقرير.';

  @override
  String get unableToLoadReport => 'تعذّر تحميل التقرير.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get accessDeniedOwner => 'غير مصرح. يتطلب دور المالك.';

  @override
  String get inventoryEmpty => 'لا توجد منتجات';

  @override
  String get inventoryLoadFailed => 'تعذّر تحميل المنتجات';

  @override
  String get deleteProductTitle => 'حذف المنتج';

  @override
  String get deleteProductMessage => 'هل أنت متأكد من حذف هذا المنتج؟';

  @override
  String get delete => 'حذف';

  @override
  String get productDeleted => 'تم حذف المنتج';

  @override
  String get printReceipt => 'طباعة الفاتورة';

  @override
  String get deleteSale => 'حذف البيع';

  @override
  String get deleteSaleTitle => 'حذف البيع؟';

  @override
  String get deleteSaleMessage =>
      'سيؤدي ذلك إلى حذف البيع وكل العناصر التابعة له.';

  @override
  String get saleDeleted => 'تم حذف البيع';

  @override
  String get productUpdated => 'تم تحديث المنتج';

  @override
  String get searchProductsHint => 'ابحث عن المنتجات';

  @override
  String get productCode => 'كود المنتج';

  @override
  String get scanBarcodeHint => 'Scan the product QR or barcode to link it.';

  @override
  String get createAccountSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get registrationFailed => 'فشل التسجيل. حاول مرة أخرى.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get missingFields => 'يرجى تعبئة جميع الحقول المطلوبة.';

  @override
  String get invalidEmailOrPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get newSaleTab => 'بيع جديد';

  @override
  String get byCodeTab => 'بالكود';

  @override
  String get addAtLeastOneItem => 'يجب إضافة عنصر واحد على الأقل.';

  @override
  String get unableToCreateSale => 'تعذّر إنشاء البيع.';

  @override
  String get scan => 'مسح';

  @override
  String get search => 'بحث';

  @override
  String get change => 'تغيير';

  @override
  String get saleLabel => 'بيع';

  @override
  String get totalSalesLabel => 'إجمالي المبيعات';

  @override
  String get totalOrders => 'إجمالي الطلبات';

  @override
  String get selectDay => 'اختر اليوم';

  @override
  String get shifts => 'الورديات';

  @override
  String get shift1 => 'الوردية الأولى';

  @override
  String get shift2 => 'الوردية الثانية';

  @override
  String get workedThisShift => 'عملت هذه الوردية';

  @override
  String get start => 'بداية';

  @override
  String get end => 'نهاية';

  @override
  String get endAfterStart => 'وقت النهاية يجب أن يكون بعد وقت البداية.';

  @override
  String get totalWorkedHours => 'إجمالي ساعات العمل';

  @override
  String get monthlyWorkHours => 'ساعات العمل الشهرية';

  @override
  String get saveProduct => 'حفظ المنتج';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get stockCannotBeNegative => 'لا يمكن أن يكون المخزون سالبًا';

  @override
  String get somethingWentWrong => 'حدث خطأ ما.';

  @override
  String inStock(Object quantity) {
    return 'في المخزون: $quantity';
  }

  @override
  String get noMatchingProducts => 'لا توجد منتجات مطابقة';

  @override
  String get stockLabel => 'المخزون';

  @override
  String get lowStock => 'مخزون منخفض';

  @override
  String get noSalesForDay => 'لا توجد مبيعات لهذا اليوم';

  @override
  String get noItemsAvailable => 'لا توجد عناصر متاحة.';

  @override
  String get itemLabel => 'عنصر';

  @override
  String get idLabel => 'المعرف';

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get noTopProductsYet => 'لا توجد منتجات مميزة بعد.';

  @override
  String get noBreakdownDataYet => 'لا توجد بيانات تفصيلية بعد.';

  @override
  String get scanBarcodeTitle => 'مسح الباركود';

  @override
  String get toggleFlashlight => 'تشغيل / إيقاف الفلاش';

  @override
  String get flipCamera => 'تبديل الكاميرا';

  @override
  String get scanOverlayHint => 'ضع الباركود أو رمز QR داخل الإطار';

  @override
  String get salesNotImplemented => 'هذه الميزة لم تُنفّذ بعد.';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String hoursLabel(Object value) {
    return '$value ساعة';
  }

  @override
  String cashierLabel(Object name) {
    return 'الكاشير: $name';
  }

  @override
  String get unknownDate => 'تاريخ غير معروف';

  @override
  String get unknownCashier => 'كاشير غير معروف';

  @override
  String get fixInvalidShiftTimes => 'يرجى تصحيح أوقات الورديات غير الصحيحة.';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صالح.';

  @override
  String get passwordTooShort => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل.';

  @override
  String get sessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get internalServerError => 'خطأ داخلي في الخادم.';

  @override
  String get unauthorized => 'غير مصرح.';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get requestTimedOut => 'انتهت مهلة الطلب.';

  @override
  String get noPermission => 'ليست لديك صلاحية.';

  @override
  String get productHasSalesCannotBeDeleted =>
      'لا يمكن حذف المنتج لوجود مبيعات مرتبطة به.';

  @override
  String get account => 'الحساب';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get updateEmailPassword => 'تحديث البريد الإلكتروني وكلمة المرور';

  @override
  String get changesSavedDemo => 'تم حفظ التغييرات (وضع تجريبي)';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get edit => 'تعديل';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get paymentTitle => 'الدفع';

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get cashPayment => 'نقدًا';

  @override
  String get cardPayment => 'بطاقة';

  @override
  String get mixedPayment => 'مختلط';

  @override
  String get paidAmountLabel => 'المبلغ المدفوع';

  @override
  String get cashAmountLabel => 'مبلغ النقد';

  @override
  String get cardAmountLabel => 'مبلغ البطاقة';

  @override
  String get confirmPayment => 'تأكيد الدفع';

  @override
  String get enterPaidAmount => 'أدخل المبلغ المدفوع.';

  @override
  String get enterCashAmount => 'أدخل مبلغ النقد.';

  @override
  String get enterCardAmount => 'أدخل مبلغ البطاقة.';

  @override
  String get paymentTotalMismatch => 'يجب أن يساوي مجموع المبالغ الإجمالي.';

  @override
  String get paidAmountTooLow => 'المبلغ المدفوع أقل من الإجمالي.';

  @override
  String get paymentTotalTooHigh => 'المبالغ لا يمكن أن تتجاوز الإجمالي.';

  @override
  String get discountLabel => 'الخصم';

  @override
  String get receiptTitle => 'الإيصال';

  @override
  String get receiptNoLabel => 'رقم الإيصال';

  @override
  String get receiptIdLabel => 'معرّف الإيصال';

  @override
  String get currencyLabel => 'العملة';

  @override
  String get taxLabel => 'الضريبة';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get taxNumberLabel => 'الرقم الضريبي';

  @override
  String get subtotalLabel => 'المجموع الفرعي';

  @override
  String get changeLabel => 'الباقي';

  @override
  String get printPos => 'طباعة نقطة البيع';

  @override
  String get printPdf => 'طباعة PDF';

  @override
  String get sharePdf => 'حفظ PDF';

  @override
  String get printFailed => 'تعذّرت الطباعة. حاول مرة أخرى.';

  @override
  String get printerSettings => 'إعدادات الطابعة';

  @override
  String get printerModeLabel => 'وضع الطباعة';

  @override
  String get posPrinter => 'نقطة بيع (بلوتوث)';

  @override
  String get pdfPrinter => 'PDF / النظام';

  @override
  String get bluetoothPrintersLabel => 'طابعات البلوتوث';

  @override
  String get noBluetoothPrinters => 'لا توجد طابعات بلوتوث.';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات.';

  @override
  String get scanning => 'جارٍ المسح...';
}
