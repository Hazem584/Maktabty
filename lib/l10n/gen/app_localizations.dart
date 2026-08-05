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
/// import 'gen/app_localizations.dart';
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

  /// No description provided for @archiveProduct.
  ///
  /// In en, this message translates to:
  /// **'Archive product'**
  String get archiveProduct;

  /// No description provided for @archivedProducts.
  ///
  /// In en, this message translates to:
  /// **'Archived products'**
  String get archivedProducts;

  /// No description provided for @archiveReason.
  ///
  /// In en, this message translates to:
  /// **'Archive reason'**
  String get archiveReason;

  /// No description provided for @enterArchiveReason.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason for archiving this product'**
  String get enterArchiveReason;

  /// No description provided for @archiveReasonTooLong.
  ///
  /// In en, this message translates to:
  /// **'The archive reason must be 1000 characters or fewer'**
  String get archiveReasonTooLong;

  /// No description provided for @productArchivedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product archived successfully'**
  String get productArchivedSuccessfully;

  /// No description provided for @productAlreadyArchived.
  ///
  /// In en, this message translates to:
  /// **'This product is already archived'**
  String get productAlreadyArchived;

  /// No description provided for @productHasRemainingStock.
  ///
  /// In en, this message translates to:
  /// **'This product still has stock'**
  String get productHasRemainingStock;

  /// No description provided for @archiveAndSetStockToZero.
  ///
  /// In en, this message translates to:
  /// **'Archive and set stock to zero'**
  String get archiveAndSetStockToZero;

  /// No description provided for @stockAdjustmentWillBeRecorded.
  ///
  /// In en, this message translates to:
  /// **'A stock adjustment will be recorded in movement history'**
  String get stockAdjustmentWillBeRecorded;

  /// No description provided for @historicalRecordsRemain.
  ///
  /// In en, this message translates to:
  /// **'Existing sales, purchases, payments, and stock history will remain available'**
  String get historicalRecordsRemain;

  /// No description provided for @barcodeRemainsReserved.
  ///
  /// In en, this message translates to:
  /// **'The product code remains reserved while the product is archived'**
  String get barcodeRemainsReserved;

  /// No description provided for @productCanBeRestored.
  ///
  /// In en, this message translates to:
  /// **'The product can be restored later by an owner'**
  String get productCanBeRestored;

  /// No description provided for @archiveProductExplanation.
  ///
  /// In en, this message translates to:
  /// **'Archiving removes the product from active sales, purchasing, and inventory lists without deleting its history.'**
  String get archiveProductExplanation;

  /// No description provided for @currentStockValue.
  ///
  /// In en, this message translates to:
  /// **'Current stock: {quantity}'**
  String currentStockValue(int quantity);

  /// No description provided for @archiveStockAdjustmentWarning.
  ///
  /// In en, this message translates to:
  /// **'Confirm again to set the remaining stock to zero and archive this product. This cannot be retried automatically.'**
  String get archiveStockAdjustmentWarning;

  /// No description provided for @archiveConflictRefreshStatus.
  ///
  /// In en, this message translates to:
  /// **'The product changed on the server. Review its current stock and confirm again.'**
  String get archiveConflictRefreshStatus;

  /// No description provided for @archiveRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'The archive request could not be completed. Refresh the product and try again.'**
  String get archiveRequestRejected;

  /// No description provided for @archiveRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not archive the product. Please try again.'**
  String get archiveRequestFailed;

  /// No description provided for @restoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Restore product'**
  String get restoreProduct;

  /// No description provided for @restoreProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Restore this product to the active catalog? Its previous stock will not be restored; add stock through a purchase or manual adjustment.'**
  String get restoreProductConfirmation;

  /// No description provided for @productRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product restored successfully'**
  String get productRestoredSuccessfully;

  /// No description provided for @productAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'This product is already active'**
  String get productAlreadyActive;

  /// No description provided for @restoreRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore the product. Please try again.'**
  String get restoreRequestFailed;

  /// No description provided for @restoreConflictRefreshStatus.
  ///
  /// In en, this message translates to:
  /// **'The product status changed on the server. Refresh the list and try again.'**
  String get restoreConflictRefreshStatus;

  /// No description provided for @noArchivedProducts.
  ///
  /// In en, this message translates to:
  /// **'No archived products'**
  String get noArchivedProducts;

  /// No description provided for @archivedDate.
  ///
  /// In en, this message translates to:
  /// **'Archived date'**
  String get archivedDate;

  /// No description provided for @activeProducts.
  ///
  /// In en, this message translates to:
  /// **'Active products'**
  String get activeProducts;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All products'**
  String get allProducts;

  /// No description provided for @archivedProductCannotBeSold.
  ///
  /// In en, this message translates to:
  /// **'This product is archived and cannot be sold'**
  String get archivedProductCannotBeSold;

  /// No description provided for @archivedProductCannotBePurchased.
  ///
  /// In en, this message translates to:
  /// **'This product is archived and cannot be purchased'**
  String get archivedProductCannotBePurchased;

  /// No description provided for @refreshProductStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh the product status and try again'**
  String get refreshProductStatus;

  /// No description provided for @pendingOfflineSaleArchivedProduct.
  ///
  /// In en, this message translates to:
  /// **'This offline sale contains an archived product and cannot be synced'**
  String get pendingOfflineSaleArchivedProduct;

  /// No description provided for @archivedProductRemovedFromCart.
  ///
  /// In en, this message translates to:
  /// **'An archived product was removed from the cart'**
  String get archivedProductRemovedFromCart;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Maktabty'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBackTitle;

  /// No description provided for @welcomeBackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage sales and inventory.'**
  String get welcomeBackSubtitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile to start selling.'**
  String get createAccountSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get signInSuccess;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get signInFailed;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password.'**
  String get enterEmailPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @termsNotice.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms.'**
  String get termsNotice;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @sellProduct.
  ///
  /// In en, this message translates to:
  /// **'Sell Product'**
  String get sellProduct;

  /// No description provided for @addWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Add Work Hours'**
  String get addWorkHours;

  /// No description provided for @salesToday.
  ///
  /// In en, this message translates to:
  /// **'Sales Today'**
  String get salesToday;

  /// No description provided for @ordersToday.
  ///
  /// In en, this message translates to:
  /// **'Orders Today'**
  String get ordersToday;

  /// No description provided for @itemsSold.
  ///
  /// In en, this message translates to:
  /// **'Items Sold'**
  String get itemsSold;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @workHours.
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get orders;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @inInventory.
  ///
  /// In en, this message translates to:
  /// **'in inventory'**
  String get inInventory;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @todaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaysSales;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noSalesToday.
  ///
  /// In en, this message translates to:
  /// **'No sales yet today.'**
  String get noSalesToday;

  /// No description provided for @unableToLoadSales.
  ///
  /// In en, this message translates to:
  /// **'Unable to load sales.'**
  String get unableToLoadSales;

  /// No description provided for @unableToLoadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Unable to load receipt.'**
  String get unableToLoadReceipt;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @scanProductCode.
  ///
  /// In en, this message translates to:
  /// **'Scan Product Code'**
  String get scanProductCode;

  /// No description provided for @noCodeScanned.
  ///
  /// In en, this message translates to:
  /// **'No code scanned yet'**
  String get noCodeScanned;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan the product QR or barcode to link it.'**
  String get scanHint;

  /// No description provided for @scanQrBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR / Barcode'**
  String get scanQrBarcode;

  /// No description provided for @selectProducts.
  ///
  /// In en, this message translates to:
  /// **'Select Products'**
  String get selectProducts;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @submitSale.
  ///
  /// In en, this message translates to:
  /// **'Submit Sale'**
  String get submitSale;

  /// No description provided for @saleCreated.
  ///
  /// In en, this message translates to:
  /// **'Sale created successfully.'**
  String get saleCreated;

  /// No description provided for @saleCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sale Created'**
  String get saleCreatedTitle;

  /// No description provided for @enterValidUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid unit price.'**
  String get enterValidUnitPrice;

  /// No description provided for @unitPriceOverrideHint.
  ///
  /// In en, this message translates to:
  /// **'Unit price override (optional)'**
  String get unitPriceOverrideHint;

  /// No description provided for @enterProductCode.
  ///
  /// In en, this message translates to:
  /// **'Enter product code'**
  String get enterProductCode;

  /// No description provided for @enterProductCodeToast.
  ///
  /// In en, this message translates to:
  /// **'Enter a product code.'**
  String get enterProductCodeToast;

  /// No description provided for @createSaleByCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Sale by Code'**
  String get createSaleByCodeTitle;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantityLabel;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// No description provided for @scanModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Product Code'**
  String get scanModeTitle;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @selectProductFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a product first.'**
  String get selectProductFirst;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productSaved;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @enterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get enterValidPrice;

  /// No description provided for @enterValidStock.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid stock amount'**
  String get enterValidStock;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @savedDays.
  ///
  /// In en, this message translates to:
  /// **'Saved Days'**
  String get savedDays;

  /// No description provided for @cashierWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Cashier Work Hours'**
  String get cashierWorkHours;

  /// No description provided for @noWorkHoursForDay.
  ///
  /// In en, this message translates to:
  /// **'No work hours found for this day.'**
  String get noWorkHoursForDay;

  /// No description provided for @noSavedDays.
  ///
  /// In en, this message translates to:
  /// **'No saved days yet'**
  String get noSavedDays;

  /// No description provided for @workHoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Work hours saved.'**
  String get workHoursSaved;

  /// No description provided for @unableToSaveWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Unable to save work hours.'**
  String get unableToSaveWorkHours;

  /// No description provided for @unableToLoadWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Unable to load work hours.'**
  String get unableToLoadWorkHours;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @pick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get pick;

  /// No description provided for @totalsByUser.
  ///
  /// In en, this message translates to:
  /// **'Totals By User'**
  String get totalsByUser;

  /// No description provided for @totalsByDay.
  ///
  /// In en, this message translates to:
  /// **'Totals By Day'**
  String get totalsByDay;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get noUsersYet;

  /// No description provided for @noDaysYet.
  ///
  /// In en, this message translates to:
  /// **'No days yet.'**
  String get noDaysYet;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @dailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily Report'**
  String get dailyReport;

  /// No description provided for @monthlyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReportTitle;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @pickMonth.
  ///
  /// In en, this message translates to:
  /// **'Pick Month'**
  String get pickMonth;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @topProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get topProducts;

  /// No description provided for @dailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily Breakdown'**
  String get dailyBreakdown;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data found.'**
  String get noReportData;

  /// No description provided for @unableToLoadReport.
  ///
  /// In en, this message translates to:
  /// **'Unable to load report.'**
  String get unableToLoadReport;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @accessDeniedOwner.
  ///
  /// In en, this message translates to:
  /// **'Access denied. Owner role required.'**
  String get accessDeniedOwner;

  /// No description provided for @inventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get inventoryEmpty;

  /// No description provided for @inventoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get inventoryLoadFailed;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete product?'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove the product from inventory.'**
  String get deleteProductMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted'**
  String get productDeleted;

  /// No description provided for @printReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get printReceipt;

  /// No description provided for @deleteSale.
  ///
  /// In en, this message translates to:
  /// **'Delete sale'**
  String get deleteSale;

  /// No description provided for @deleteSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete sale?'**
  String get deleteSaleTitle;

  /// No description provided for @deleteSaleMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove the sale and its items.'**
  String get deleteSaleMessage;

  /// No description provided for @saleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Sale deleted'**
  String get saleDeleted;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProductsHint;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product Code'**
  String get productCode;

  /// No description provided for @scanBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Scan the product QR or barcode to link it.'**
  String get scanBarcodeHint;

  /// No description provided for @createAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get createAccountSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @missingFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get missingFields;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @newSaleTab.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSaleTab;

  /// No description provided for @byCodeTab.
  ///
  /// In en, this message translates to:
  /// **'By Code'**
  String get byCodeTab;

  /// No description provided for @addAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item.'**
  String get addAtLeastOneItem;

  /// No description provided for @unableToCreateSale.
  ///
  /// In en, this message translates to:
  /// **'Unable to create sale.'**
  String get unableToCreateSale;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @saleLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get saleLabel;

  /// No description provided for @totalSalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSalesLabel;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectDay;

  /// No description provided for @shifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shifts;

  /// No description provided for @shift1.
  ///
  /// In en, this message translates to:
  /// **'Shift 1'**
  String get shift1;

  /// No description provided for @shift2.
  ///
  /// In en, this message translates to:
  /// **'Shift 2'**
  String get shift2;

  /// No description provided for @workedThisShift.
  ///
  /// In en, this message translates to:
  /// **'Worked this shift'**
  String get workedThisShift;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @endAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get endAfterStart;

  /// No description provided for @totalWorkedHours.
  ///
  /// In en, this message translates to:
  /// **'Total Worked Hours'**
  String get totalWorkedHours;

  /// No description provided for @monthlyWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Monthly Work Hours'**
  String get monthlyWorkHours;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @stockCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Stock cannot be negative'**
  String get stockCannotBeNegative;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In stock: {quantity}'**
  String inStock(Object quantity);

  /// No description provided for @noMatchingProducts.
  ///
  /// In en, this message translates to:
  /// **'No matching products'**
  String get noMatchingProducts;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockLabel;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowStock;

  /// No description provided for @noSalesForDay.
  ///
  /// In en, this message translates to:
  /// **'No sales for this day'**
  String get noSalesForDay;

  /// No description provided for @noItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No items available.'**
  String get noItemsAvailable;

  /// No description provided for @itemLabel.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemLabel;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @noTopProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No top products yet.'**
  String get noTopProductsYet;

  /// No description provided for @noBreakdownDataYet.
  ///
  /// In en, this message translates to:
  /// **'No breakdown data yet.'**
  String get noBreakdownDataYet;

  /// No description provided for @scanBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcodeTitle;

  /// No description provided for @toggleFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashlight'**
  String get toggleFlashlight;

  /// No description provided for @flipCamera.
  ///
  /// In en, this message translates to:
  /// **'Flip camera'**
  String get flipCamera;

  /// No description provided for @scanOverlayHint.
  ///
  /// In en, this message translates to:
  /// **'Align the barcode or QR code inside the frame'**
  String get scanOverlayHint;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'{value} hours'**
  String hoursLabel(Object value);

  /// No description provided for @cashierLabel.
  ///
  /// In en, this message translates to:
  /// **'Cashier: {name}'**
  String cashierLabel(Object name);

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// No description provided for @unknownCashier.
  ///
  /// In en, this message translates to:
  /// **'Unknown cashier'**
  String get unknownCashier;

  /// No description provided for @fixInvalidShiftTimes.
  ///
  /// In en, this message translates to:
  /// **'Please fix invalid shift times.'**
  String get fixInvalidShiftTimes;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @accountDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled. Contact your store owner to reactivate it.'**
  String get accountDisabledMessage;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error.'**
  String get internalServerError;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access.'**
  String get unauthorized;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get noInternet;

  /// No description provided for @requestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requestTimedOut;

  /// No description provided for @apiServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'The API server is unreachable. Please try again later.'**
  String get apiServerUnreachable;

  /// No description provided for @apiConnectionTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Connection to the API server timed out. Please try again.'**
  String get apiConnectionTimedOut;

  /// No description provided for @requestSendTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The request could not be sent in time. Please try again.'**
  String get requestSendTimedOut;

  /// No description provided for @apiResponseTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The API server did not respond in time. Please try again.'**
  String get apiResponseTimedOut;

  /// No description provided for @apiSecureConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not establish a secure connection to the API server.'**
  String get apiSecureConnectionFailed;

  /// No description provided for @backendServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The server is temporarily unavailable. Please try again.'**
  String get backendServerUnavailable;

  /// No description provided for @noPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission.'**
  String get noPermission;

  /// No description provided for @productHasSalesCannotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product has sales and cannot be deleted.'**
  String get productHasSalesCannotBeDeleted;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @updateEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your email and password'**
  String get updateEmailPassword;

  /// No description provided for @changesSavedDemo.
  ///
  /// In en, this message translates to:
  /// **'Changes saved (demo)'**
  String get changesSavedDemo;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @cashPayment.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashPayment;

  /// No description provided for @cardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get cardPayment;

  /// No description provided for @mixedPayment.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get mixedPayment;

  /// No description provided for @paidAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid amount'**
  String get paidAmountLabel;

  /// No description provided for @cashAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash amount'**
  String get cashAmountLabel;

  /// No description provided for @cardAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Card amount'**
  String get cardAmountLabel;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get confirmPayment;

  /// No description provided for @enterPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter paid amount.'**
  String get enterPaidAmount;

  /// No description provided for @enterCashAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter cash amount.'**
  String get enterCashAmount;

  /// No description provided for @enterCardAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter card amount.'**
  String get enterCardAmount;

  /// No description provided for @paymentTotalMismatch.
  ///
  /// In en, this message translates to:
  /// **'Amounts must equal total.'**
  String get paymentTotalMismatch;

  /// No description provided for @paidAmountTooLow.
  ///
  /// In en, this message translates to:
  /// **'Paid amount must be at least total.'**
  String get paidAmountTooLow;

  /// No description provided for @paymentTotalTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Amounts cannot exceed total.'**
  String get paymentTotalTooHigh;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptTitle;

  /// No description provided for @receiptNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt No'**
  String get receiptNoLabel;

  /// No description provided for @receiptIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt ID'**
  String get receiptIdLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @taxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get taxLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @taxNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax No'**
  String get taxNumberLabel;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLabel;

  /// No description provided for @printPos.
  ///
  /// In en, this message translates to:
  /// **'Print POS'**
  String get printPos;

  /// No description provided for @printPdf.
  ///
  /// In en, this message translates to:
  /// **'Print PDF'**
  String get printPdf;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get sharePdf;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to print. Please try again.'**
  String get printFailed;

  /// No description provided for @printerSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer Settings'**
  String get printerSettings;

  /// No description provided for @printerModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Printer mode'**
  String get printerModeLabel;

  /// No description provided for @posPrinter.
  ///
  /// In en, this message translates to:
  /// **'POS (Bluetooth)'**
  String get posPrinter;

  /// No description provided for @pdfPrinter.
  ///
  /// In en, this message translates to:
  /// **'PDF / System'**
  String get pdfPrinter;

  /// No description provided for @bluetoothPrintersLabel.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth printers'**
  String get bluetoothPrintersLabel;

  /// No description provided for @noBluetoothPrinters.
  ///
  /// In en, this message translates to:
  /// **'No bluetooth printers found.'**
  String get noBluetoothPrinters;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved.'**
  String get settingsSaved;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @unableToVerifySession.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify your saved session. Check your connection and try again.'**
  String get unableToVerifySession;

  /// No description provided for @unexpectedServerResponse.
  ///
  /// In en, this message translates to:
  /// **'The server returned an unexpected response. Please try again.'**
  String get unexpectedServerResponse;

  /// No description provided for @bluetoothDisabled.
  ///
  /// In en, this message translates to:
  /// **'Turn on Bluetooth and try again.'**
  String get bluetoothDisabled;

  /// No description provided for @bluetoothPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required to find paired printers.'**
  String get bluetoothPermissionRequired;

  /// No description provided for @printerConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the selected printer.'**
  String get printerConnectionFailed;

  /// No description provided for @printerDisconnected.
  ///
  /// In en, this message translates to:
  /// **'The printer disconnected while printing.'**
  String get printerDisconnected;

  /// No description provided for @invalidProductCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid product code.'**
  String get invalidProductCode;

  /// No description provided for @invalidSaleQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid sale quantity.'**
  String get invalidSaleQuantity;

  /// No description provided for @duplicateSaleItem.
  ///
  /// In en, this message translates to:
  /// **'A product cannot appear more than once in a sale.'**
  String get duplicateSaleItem;

  /// No description provided for @overlappingShifts.
  ///
  /// In en, this message translates to:
  /// **'Work shifts cannot overlap.'**
  String get overlappingShifts;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'This page could not be found.'**
  String get routeNotFound;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @offlineSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline sales'**
  String get offlineSalesTitle;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncingSales.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing pending sales...'**
  String get syncingSales;

  /// No description provided for @noOfflineSales.
  ///
  /// In en, this message translates to:
  /// **'No local sales have been saved yet.'**
  String get noOfflineSales;

  /// No description provided for @previousAccountPendingSales.
  ///
  /// In en, this message translates to:
  /// **'{count} unsynchronized sale(s) belong to another account and will not be uploaded with this session.'**
  String previousAccountPendingSales(int count);

  /// No description provided for @temporarySaleReference.
  ///
  /// In en, this message translates to:
  /// **'Local reference: {reference}'**
  String temporarySaleReference(String reference);

  /// No description provided for @localSaleItemsAndTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) · Total {total}'**
  String localSaleItemsAndTotal(int count, String total);

  /// No description provided for @syncAttempts.
  ///
  /// In en, this message translates to:
  /// **'Sync attempts: {count}'**
  String syncAttempts(int count);

  /// No description provided for @stockConflictDetails.
  ///
  /// In en, this message translates to:
  /// **'Stock changed on the server. Requested: {requested}, available: {available}.'**
  String stockConflictDetails(int requested, int available);

  /// No description provided for @idempotencyConflictHelp.
  ///
  /// In en, this message translates to:
  /// **'This sale ID conflicts with different server data. Keep the record and contact an administrator.'**
  String get idempotencyConflictHelp;

  /// No description provided for @saleSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'This sale could not be synchronized. Review it before retrying.'**
  String get saleSyncFailed;

  /// No description provided for @pendingReceiptNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a local sale. A confirmed receipt number is available only after synchronization.'**
  String get pendingReceiptNotice;

  /// No description provided for @saleQueuedForSync.
  ///
  /// In en, this message translates to:
  /// **'Sale queued for synchronization.'**
  String get saleQueuedForSync;

  /// No description provided for @unableToRetrySale.
  ///
  /// In en, this message translates to:
  /// **'This sale cannot be retried right now.'**
  String get unableToRetrySale;

  /// No description provided for @retrySync.
  ///
  /// In en, this message translates to:
  /// **'Retry sync'**
  String get retrySync;

  /// No description provided for @viewConfirmedReceipt.
  ///
  /// In en, this message translates to:
  /// **'View confirmed receipt'**
  String get viewConfirmedReceipt;

  /// No description provided for @syncStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get syncStatusPending;

  /// No description provided for @syncStatusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncStatusSyncing;

  /// No description provided for @syncStatusSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncStatusSynced;

  /// No description provided for @syncStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get syncStatusFailed;

  /// No description provided for @syncStatusStockConflict.
  ///
  /// In en, this message translates to:
  /// **'Stock conflict'**
  String get syncStatusStockConflict;

  /// No description provided for @syncStatusIdempotencyConflict.
  ///
  /// In en, this message translates to:
  /// **'ID conflict'**
  String get syncStatusIdempotencyConflict;

  /// No description provided for @saleSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Sale saved locally and queued for synchronization.'**
  String get saleSavedLocally;

  /// No description provided for @cachedProductsNotice.
  ///
  /// In en, this message translates to:
  /// **'Showing cached products. Stock includes local reservations.'**
  String get cachedProductsNotice;

  /// No description provided for @refreshProducts.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshProducts;

  /// No description provided for @localDatabaseError.
  ///
  /// In en, this message translates to:
  /// **'Local storage is unavailable. The sale was not cleared; please try again.'**
  String get localDatabaseError;

  /// No description provided for @insufficientLocalStock.
  ///
  /// In en, this message translates to:
  /// **'There is not enough locally available stock for this sale.'**
  String get insufficientLocalStock;

  /// No description provided for @idempotencyConflict.
  ///
  /// In en, this message translates to:
  /// **'This sale has an identifier conflict and needs administrator review.'**
  String get idempotencyConflict;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get addSupplier;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit supplier'**
  String get editSupplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplierName;

  /// No description provided for @supplierDetails.
  ///
  /// In en, this message translates to:
  /// **'Supplier details'**
  String get supplierDetails;

  /// No description provided for @supplierInformation.
  ///
  /// In en, this message translates to:
  /// **'Supplier information'**
  String get supplierInformation;

  /// No description provided for @activeSupplier.
  ///
  /// In en, this message translates to:
  /// **'Active supplier'**
  String get activeSupplier;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @searchSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Search suppliers'**
  String get searchSuppliers;

  /// No description provided for @noSuppliers.
  ///
  /// In en, this message translates to:
  /// **'No suppliers found.'**
  String get noSuppliers;

  /// No description provided for @noSupplierData.
  ///
  /// In en, this message translates to:
  /// **'Supplier data is unavailable.'**
  String get noSupplierData;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @outstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance'**
  String get outstandingBalance;

  /// No description provided for @purchaseInvoices.
  ///
  /// In en, this message translates to:
  /// **'Purchase invoices'**
  String get purchaseInvoices;

  /// No description provided for @purchaseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Purchase invoice'**
  String get purchaseInvoice;

  /// No description provided for @noPurchaseInvoices.
  ///
  /// In en, this message translates to:
  /// **'No purchase invoices.'**
  String get noPurchaseInvoices;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @noPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments.'**
  String get noPayments;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @noStatementEntries.
  ///
  /// In en, this message translates to:
  /// **'No statement entries.'**
  String get noStatementEntries;

  /// No description provided for @totalPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total purchases'**
  String get totalPurchases;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get recordPayment;

  /// No description provided for @recordSupplierPayment.
  ///
  /// In en, this message translates to:
  /// **'Record supplier payment'**
  String get recordSupplierPayment;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get paymentRecorded;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @paidDate.
  ///
  /// In en, this message translates to:
  /// **'Paid date'**
  String get paidDate;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get bankTransfer;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @invalidPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount that does not exceed the invoice remainder.'**
  String get invalidPaymentAmount;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String remainingAmount(String amount);

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @createPurchase.
  ///
  /// In en, this message translates to:
  /// **'Create purchase'**
  String get createPurchase;

  /// No description provided for @createPurchaseDraft.
  ///
  /// In en, this message translates to:
  /// **'Create purchase draft'**
  String get createPurchaseDraft;

  /// No description provided for @editPurchaseDraft.
  ///
  /// In en, this message translates to:
  /// **'Edit purchase draft'**
  String get editPurchaseDraft;

  /// No description provided for @purchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase details'**
  String get purchaseDetails;

  /// No description provided for @searchPurchases.
  ///
  /// In en, this message translates to:
  /// **'Search purchases'**
  String get searchPurchases;

  /// No description provided for @noPurchases.
  ///
  /// In en, this message translates to:
  /// **'No purchases found.'**
  String get noPurchases;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownStatus;

  /// No description provided for @purchaseNumber.
  ///
  /// In en, this message translates to:
  /// **'Purchase #{number}'**
  String purchaseNumber(int number);

  /// No description provided for @unknownSupplier.
  ///
  /// In en, this message translates to:
  /// **'Unknown supplier'**
  String get unknownSupplier;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @supplierInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Supplier invoice number'**
  String get supplierInvoiceNumber;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @postingDate.
  ///
  /// In en, this message translates to:
  /// **'Posting date'**
  String get postingDate;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// No description provided for @initialPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Initial paid amount'**
  String get initialPaidAmount;

  /// No description provided for @purchaseItems.
  ///
  /// In en, this message translates to:
  /// **'Purchase items'**
  String get purchaseItems;

  /// No description provided for @unitCost.
  ///
  /// In en, this message translates to:
  /// **'Unit cost'**
  String get unitCost;

  /// No description provided for @lastPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Last purchase price'**
  String get lastPurchasePrice;

  /// No description provided for @averageCost.
  ///
  /// In en, this message translates to:
  /// **'Average cost'**
  String get averageCost;

  /// No description provided for @inStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get inStockLabel;

  /// No description provided for @subtotalPreview.
  ///
  /// In en, this message translates to:
  /// **'Subtotal preview'**
  String get subtotalPreview;

  /// No description provided for @backendTotalsAuthoritative.
  ///
  /// In en, this message translates to:
  /// **'Final totals are confirmed by the server.'**
  String get backendTotalsAuthoritative;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get saveDraft;

  /// No description provided for @selectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier.'**
  String get selectSupplier;

  /// No description provided for @invalidNonNegativeAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative amount.'**
  String get invalidNonNegativeAmount;

  /// No description provided for @addAtLeastOnePurchaseItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one purchase item.'**
  String get addAtLeastOnePurchaseItem;

  /// No description provided for @duplicatePurchaseProduct.
  ///
  /// In en, this message translates to:
  /// **'A product cannot appear more than once in a purchase.'**
  String get duplicatePurchaseProduct;

  /// No description provided for @invalidPurchaseItem.
  ///
  /// In en, this message translates to:
  /// **'Each item needs a positive whole quantity and positive unit cost.'**
  String get invalidPurchaseItem;

  /// No description provided for @draftSavedNoStockChange.
  ///
  /// In en, this message translates to:
  /// **'Draft saved. Product stock was not changed.'**
  String get draftSavedNoStockChange;

  /// No description provided for @purchasesRequireInternet.
  ///
  /// In en, this message translates to:
  /// **'Purchases require an internet connection.'**
  String get purchasesRequireInternet;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @postInvoice.
  ///
  /// In en, this message translates to:
  /// **'Post invoice'**
  String get postInvoice;

  /// No description provided for @postPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Post purchase invoice?'**
  String get postPurchaseTitle;

  /// No description provided for @postPurchaseWarning.
  ///
  /// In en, this message translates to:
  /// **'Stock will increase, product costs will update, and this invoice will become immutable. This action cannot currently be reversed in the application.'**
  String get postPurchaseWarning;

  /// No description provided for @purchasePosted.
  ///
  /// In en, this message translates to:
  /// **'Purchase invoice posted.'**
  String get purchasePosted;

  /// No description provided for @postTimeoutRetryHelp.
  ///
  /// In en, this message translates to:
  /// **'Posting could not be confirmed. The invoice was checked again; retry only if it is still a draft.'**
  String get postTimeoutRetryHelp;

  /// No description provided for @deleteDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete purchase draft?'**
  String get deleteDraftTitle;

  /// No description provided for @deleteDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes the draft. No stock has been changed.'**
  String get deleteDraftMessage;

  /// No description provided for @stockMovements.
  ///
  /// In en, this message translates to:
  /// **'Stock movements'**
  String get stockMovements;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @movementType.
  ///
  /// In en, this message translates to:
  /// **'Movement type'**
  String get movementType;

  /// No description provided for @purchaseInvoiceId.
  ///
  /// In en, this message translates to:
  /// **'Purchase invoice ID'**
  String get purchaseInvoiceId;

  /// No description provided for @saleId.
  ///
  /// In en, this message translates to:
  /// **'Sale ID'**
  String get saleId;

  /// No description provided for @movementHistoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Movement history is available for transactions recorded after inventory tracking was enabled.'**
  String get movementHistoryNotice;

  /// No description provided for @noStockMovements.
  ///
  /// In en, this message translates to:
  /// **'No stock movements found.'**
  String get noStockMovements;

  /// No description provided for @openingStock.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get openingStock;

  /// No description provided for @purchaseMovement.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchaseMovement;

  /// No description provided for @purchaseReversal.
  ///
  /// In en, this message translates to:
  /// **'Purchase reversal'**
  String get purchaseReversal;

  /// No description provided for @saleMovement.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get saleMovement;

  /// No description provided for @saleReversal.
  ///
  /// In en, this message translates to:
  /// **'Sale reversal'**
  String get saleReversal;

  /// No description provided for @manualAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Manual adjustment'**
  String get manualAdjustment;

  /// No description provided for @stockBeforeAfter.
  ///
  /// In en, this message translates to:
  /// **'{before} → {after}'**
  String stockBeforeAfter(int before, int after);

  /// No description provided for @adjustmentReason.
  ///
  /// In en, this message translates to:
  /// **'Adjustment reason'**
  String get adjustmentReason;

  /// No description provided for @adjustmentReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason for the stock adjustment.'**
  String get adjustmentReasonRequired;

  /// No description provided for @stockMovementWillBeRecorded.
  ///
  /// In en, this message translates to:
  /// **'A stock movement will be recorded.'**
  String get stockMovementWillBeRecorded;

  /// No description provided for @stockAdjustmentSummary.
  ///
  /// In en, this message translates to:
  /// **'Current: {current} · New: {next} · Difference: {difference}'**
  String stockAdjustmentSummary(int current, int next, String difference);

  /// No description provided for @procurementAndStock.
  ///
  /// In en, this message translates to:
  /// **'Procurement and stock'**
  String get procurementAndStock;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivateSupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate supplier?'**
  String get deactivateSupplierTitle;

  /// No description provided for @deactivateSupplierMessage.
  ///
  /// In en, this message translates to:
  /// **'The supplier will be hidden from active selections. Existing purchase history remains available.'**
  String get deactivateSupplierMessage;

  /// No description provided for @supplierInactive.
  ///
  /// In en, this message translates to:
  /// **'This supplier is inactive.'**
  String get supplierInactive;

  /// No description provided for @invoiceAlreadyPosted.
  ///
  /// In en, this message translates to:
  /// **'This invoice has already been posted.'**
  String get invoiceAlreadyPosted;

  /// No description provided for @invoiceNotEditable.
  ///
  /// In en, this message translates to:
  /// **'This invoice can no longer be edited.'**
  String get invoiceNotEditable;

  /// No description provided for @paymentExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'The payment exceeds the invoice\'s remaining amount. Refresh and try again.'**
  String get paymentExceedsRemaining;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store or business name'**
  String get storeName;

  /// No description provided for @storeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your store or business name.'**
  String get storeNameRequired;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose the application language'**
  String get chooseLanguage;

  /// No description provided for @cashiers.
  ///
  /// In en, this message translates to:
  /// **'Cashiers'**
  String get cashiers;

  /// No description provided for @manageCashiers.
  ///
  /// In en, this message translates to:
  /// **'Manage cashiers'**
  String get manageCashiers;

  /// No description provided for @ownerAdministration.
  ///
  /// In en, this message translates to:
  /// **'Owner administration'**
  String get ownerAdministration;

  /// No description provided for @addCashier.
  ///
  /// In en, this message translates to:
  /// **'Add cashier'**
  String get addCashier;

  /// No description provided for @editCashier.
  ///
  /// In en, this message translates to:
  /// **'Edit cashier'**
  String get editCashier;

  /// No description provided for @cashierDetails.
  ///
  /// In en, this message translates to:
  /// **'Cashier details'**
  String get cashierDetails;

  /// No description provided for @searchCashiers.
  ///
  /// In en, this message translates to:
  /// **'Search cashiers'**
  String get searchCashiers;

  /// No description provided for @noCashiers.
  ///
  /// In en, this message translates to:
  /// **'No cashiers found.'**
  String get noCashiers;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @enableCashier.
  ///
  /// In en, this message translates to:
  /// **'Enable cashier'**
  String get enableCashier;

  /// No description provided for @disableCashier.
  ///
  /// In en, this message translates to:
  /// **'Disable cashier'**
  String get disableCashier;

  /// No description provided for @enableCashierConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Enable this cashier? They will be able to sign in again.'**
  String get enableCashierConfirmation;

  /// No description provided for @disableCashierConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Disable this cashier? Their sessions will be revoked, and they must sign in again after you re-enable the account.'**
  String get disableCashierConfirmation;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordResetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Reset this cashier\'s password? Existing sessions will be revoked.'**
  String get passwordResetConfirmation;

  /// No description provided for @passwordResetSessionNotice.
  ///
  /// In en, this message translates to:
  /// **'Resetting the password revokes existing sessions. The cashier must sign in again with the new password.'**
  String get passwordResetSessionNotice;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cashier password reset successfully.'**
  String get passwordResetSuccess;

  /// No description provided for @cashierCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cashier created successfully.'**
  String get cashierCreatedSuccess;

  /// No description provided for @cashierUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cashier updated successfully.'**
  String get cashierUpdatedSuccess;

  /// No description provided for @cashierEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cashier enabled successfully.'**
  String get cashierEnabledSuccess;

  /// No description provided for @cashierDisabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cashier disabled successfully.'**
  String get cashierDisabledSuccess;

  /// No description provided for @cashierSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the cashier. Please try again.'**
  String get cashierSaveFailed;

  /// No description provided for @cashierUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This cashier is unavailable.'**
  String get cashierUnavailable;

  /// No description provided for @duplicateCashierEmail.
  ///
  /// In en, this message translates to:
  /// **'A cashier with this email already exists.'**
  String get duplicateCashierEmail;

  /// No description provided for @offlineDataOwnershipWarning.
  ///
  /// In en, this message translates to:
  /// **'Some older offline sales have no verified store ownership. They are quarantined and will not be synchronized or assigned to this account.'**
  String get offlineDataOwnershipWarning;
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
