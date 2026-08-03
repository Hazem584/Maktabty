// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get archiveProduct => 'Archive product';

  @override
  String get archivedProducts => 'Archived products';

  @override
  String get archiveReason => 'Archive reason';

  @override
  String get enterArchiveReason => 'Enter a reason for archiving this product';

  @override
  String get archiveReasonTooLong =>
      'The archive reason must be 1000 characters or fewer';

  @override
  String get productArchivedSuccessfully => 'Product archived successfully';

  @override
  String get productAlreadyArchived => 'This product is already archived';

  @override
  String get productHasRemainingStock => 'This product still has stock';

  @override
  String get archiveAndSetStockToZero => 'Archive and set stock to zero';

  @override
  String get stockAdjustmentWillBeRecorded =>
      'A stock adjustment will be recorded in movement history';

  @override
  String get historicalRecordsRemain =>
      'Existing sales, purchases, payments, and stock history will remain available';

  @override
  String get barcodeRemainsReserved =>
      'The product code remains reserved while the product is archived';

  @override
  String get productCanBeRestored =>
      'The product can be restored later by an owner';

  @override
  String get archiveProductExplanation =>
      'Archiving removes the product from active sales, purchasing, and inventory lists without deleting its history.';

  @override
  String currentStockValue(int quantity) {
    return 'Current stock: $quantity';
  }

  @override
  String get archiveStockAdjustmentWarning =>
      'Confirm again to set the remaining stock to zero and archive this product. This cannot be retried automatically.';

  @override
  String get archiveConflictRefreshStatus =>
      'The product changed on the server. Review its current stock and confirm again.';

  @override
  String get archiveRequestRejected =>
      'The archive request could not be completed. Refresh the product and try again.';

  @override
  String get archiveRequestFailed =>
      'Could not archive the product. Please try again.';

  @override
  String get restoreProduct => 'Restore product';

  @override
  String get restoreProductConfirmation =>
      'Restore this product to the active catalog? Its previous stock will not be restored; add stock through a purchase or manual adjustment.';

  @override
  String get productRestoredSuccessfully => 'Product restored successfully';

  @override
  String get productAlreadyActive => 'This product is already active';

  @override
  String get restoreRequestFailed =>
      'Could not restore the product. Please try again.';

  @override
  String get restoreConflictRefreshStatus =>
      'The product status changed on the server. Refresh the list and try again.';

  @override
  String get noArchivedProducts => 'No archived products';

  @override
  String get archivedDate => 'Archived date';

  @override
  String get activeProducts => 'Active products';

  @override
  String get allProducts => 'All products';

  @override
  String get archivedProductCannotBeSold =>
      'This product is archived and cannot be sold';

  @override
  String get archivedProductCannotBePurchased =>
      'This product is archived and cannot be purchased';

  @override
  String get refreshProductStatus => 'Refresh the product status and try again';

  @override
  String get pendingOfflineSaleArchivedProduct =>
      'This offline sale contains an archived product and cannot be synced';

  @override
  String get archivedProductRemovedFromCart =>
      'An archived product was removed from the cart';

  @override
  String get appTitle => 'Maktabty';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get welcomeBackTitle => 'Welcome back';

  @override
  String get welcomeBackSubtitle => 'Sign in to manage sales and inventory.';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountSubtitle => 'Set up your profile to start selling.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSuccess => 'Login successful';

  @override
  String get signInFailed => 'Login failed. Please try again.';

  @override
  String get enterEmailPassword => 'Please enter email and password.';

  @override
  String get createAccount => 'Create account';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get fullName => 'Full name';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get termsNotice => 'By creating an account, you agree to our Terms.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get logout => 'Log out';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get addProduct => 'Add Product';

  @override
  String get sellProduct => 'Sell Product';

  @override
  String get addWorkHours => 'Add Work Hours';

  @override
  String get salesToday => 'Sales Today';

  @override
  String get ordersToday => 'Orders Today';

  @override
  String get itemsSold => 'Items Sold';

  @override
  String get products => 'Products';

  @override
  String get workHours => 'Work Hours';

  @override
  String get total => 'total';

  @override
  String get orders => 'orders';

  @override
  String get items => 'items';

  @override
  String get inInventory => 'in inventory';

  @override
  String get today => 'today';

  @override
  String get todaysSales => 'Today\'s Sales';

  @override
  String get refresh => 'Refresh';

  @override
  String get noSalesToday => 'No sales yet today.';

  @override
  String get unableToLoadSales => 'Unable to load sales.';

  @override
  String get unableToLoadReceipt => 'Unable to load receipt.';

  @override
  String get home => 'Home';

  @override
  String get inventory => 'Inventory';

  @override
  String get sales => 'Sales';

  @override
  String get reports => 'Reports';

  @override
  String get scanProductCode => 'Scan Product Code';

  @override
  String get noCodeScanned => 'No code scanned yet';

  @override
  String get scanHint => 'Scan the product QR or barcode to link it.';

  @override
  String get scanQrBarcode => 'Scan QR / Barcode';

  @override
  String get selectProducts => 'Select Products';

  @override
  String get addItem => 'Add Item';

  @override
  String get itemsLabel => 'Items';

  @override
  String get submitSale => 'Submit Sale';

  @override
  String get saleCreated => 'Sale created successfully.';

  @override
  String get saleCreatedTitle => 'Sale Created';

  @override
  String get enterValidUnitPrice => 'Enter a valid unit price.';

  @override
  String get unitPriceOverrideHint => 'Unit price override (optional)';

  @override
  String get enterProductCode => 'Enter product code';

  @override
  String get enterProductCodeToast => 'Enter a product code.';

  @override
  String get createSaleByCodeTitle => 'Create Sale by Code';

  @override
  String get quantityLabel => 'Qty';

  @override
  String get unitLabel => 'Unit';

  @override
  String get removeItem => 'Remove item';

  @override
  String get scanModeTitle => 'Scan Product Code';

  @override
  String get sell => 'Sell';

  @override
  String get selectProductFirst => 'Select a product first.';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get productSaved => 'Product saved';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get enterValidPrice => 'Enter a valid price';

  @override
  String get enterValidStock => 'Enter a valid stock amount';

  @override
  String get productName => 'Product Name';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get savedDays => 'Saved Days';

  @override
  String get cashierWorkHours => 'Cashier Work Hours';

  @override
  String get noWorkHoursForDay => 'No work hours found for this day.';

  @override
  String get noSavedDays => 'No saved days yet';

  @override
  String get workHoursSaved => 'Work hours saved.';

  @override
  String get unableToSaveWorkHours => 'Unable to save work hours.';

  @override
  String get unableToLoadWorkHours => 'Unable to load work hours.';

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get pick => 'Pick';

  @override
  String get totalsByUser => 'Totals By User';

  @override
  String get totalsByDay => 'Totals By Day';

  @override
  String get noUsersYet => 'No users yet.';

  @override
  String get noDaysYet => 'No days yet.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get daily => 'Daily';

  @override
  String get monthly => 'Monthly';

  @override
  String get dailyReport => 'Daily Report';

  @override
  String get monthlyReportTitle => 'Monthly Report';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get pickMonth => 'Pick Month';

  @override
  String get todayLabel => 'Today';

  @override
  String get thisMonth => 'This Month';

  @override
  String get topProducts => 'Top Products';

  @override
  String get dailyBreakdown => 'Daily Breakdown';

  @override
  String get noReportData => 'No report data found.';

  @override
  String get unableToLoadReport => 'Unable to load report.';

  @override
  String get retry => 'Retry';

  @override
  String get accessDeniedOwner => 'Access denied. Owner role required.';

  @override
  String get inventoryEmpty => 'No products found';

  @override
  String get inventoryLoadFailed => 'Failed to load products';

  @override
  String get deleteProductTitle => 'Delete product?';

  @override
  String get deleteProductMessage =>
      'This will remove the product from inventory.';

  @override
  String get delete => 'Delete';

  @override
  String get productDeleted => 'Product deleted';

  @override
  String get printReceipt => 'Print receipt';

  @override
  String get deleteSale => 'Delete sale';

  @override
  String get deleteSaleTitle => 'Delete sale?';

  @override
  String get deleteSaleMessage => 'This will remove the sale and its items.';

  @override
  String get saleDeleted => 'Sale deleted';

  @override
  String get productUpdated => 'Product updated';

  @override
  String get searchProductsHint => 'Search products';

  @override
  String get productCode => 'Product Code';

  @override
  String get scanBarcodeHint => 'Scan the product QR or barcode to link it.';

  @override
  String get createAccountSuccess => 'Account created successfully';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get missingFields => 'Please fill all required fields.';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get newSaleTab => 'New Sale';

  @override
  String get byCodeTab => 'By Code';

  @override
  String get addAtLeastOneItem => 'Add at least one item.';

  @override
  String get unableToCreateSale => 'Unable to create sale.';

  @override
  String get scan => 'Scan';

  @override
  String get search => 'Search';

  @override
  String get change => 'Change';

  @override
  String get saleLabel => 'Sale';

  @override
  String get totalSalesLabel => 'Total Sales';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get selectDay => 'Select Day';

  @override
  String get shifts => 'Shifts';

  @override
  String get shift1 => 'Shift 1';

  @override
  String get shift2 => 'Shift 2';

  @override
  String get workedThisShift => 'Worked this shift';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get endAfterStart => 'End time must be after start time.';

  @override
  String get totalWorkedHours => 'Total Worked Hours';

  @override
  String get monthlyWorkHours => 'Monthly Work Hours';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get stockCannotBeNegative => 'Stock cannot be negative';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String inStock(Object quantity) {
    return 'In stock: $quantity';
  }

  @override
  String get noMatchingProducts => 'No matching products';

  @override
  String get stockLabel => 'Stock';

  @override
  String get lowStock => 'Low';

  @override
  String get noSalesForDay => 'No sales for this day';

  @override
  String get noItemsAvailable => 'No items available.';

  @override
  String get itemLabel => 'Item';

  @override
  String get idLabel => 'ID';

  @override
  String get totalLabel => 'Total';

  @override
  String get noTopProductsYet => 'No top products yet.';

  @override
  String get noBreakdownDataYet => 'No breakdown data yet.';

  @override
  String get scanBarcodeTitle => 'Scan Barcode';

  @override
  String get toggleFlashlight => 'Toggle flashlight';

  @override
  String get flipCamera => 'Flip camera';

  @override
  String get scanOverlayHint => 'Align the barcode or QR code inside the frame';

  @override
  String get selectDate => 'Select Date';

  @override
  String hoursLabel(Object value) {
    return '$value hours';
  }

  @override
  String cashierLabel(Object name) {
    return 'Cashier: $name';
  }

  @override
  String get unknownDate => 'Unknown date';

  @override
  String get unknownCashier => 'Unknown cashier';

  @override
  String get fixInvalidShiftTimes => 'Please fix invalid shift times.';

  @override
  String get invalidEmail => 'Please enter a valid email.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get sessionExpired => 'Session expired. Please sign in again.';

  @override
  String get internalServerError => 'Internal server error.';

  @override
  String get unauthorized => 'Unauthorized access.';

  @override
  String get noInternet => 'No internet connection. Please try again.';

  @override
  String get requestTimedOut => 'Request timed out. Please try again.';

  @override
  String get apiServerUnreachable =>
      'The API server is unreachable. Please try again later.';

  @override
  String get apiConnectionTimedOut =>
      'Connection to the API server timed out. Please try again.';

  @override
  String get requestSendTimedOut =>
      'The request could not be sent in time. Please try again.';

  @override
  String get apiResponseTimedOut =>
      'The API server did not respond in time. Please try again.';

  @override
  String get apiSecureConnectionFailed =>
      'Could not establish a secure connection to the API server.';

  @override
  String get backendServerUnavailable =>
      'The server is temporarily unavailable. Please try again.';

  @override
  String get noPermission => 'You don\'t have permission.';

  @override
  String get productHasSalesCannotBeDeleted =>
      'Product has sales and cannot be deleted.';

  @override
  String get account => 'Account';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get updateEmailPassword => 'Update your email and password';

  @override
  String get changesSavedDemo => 'Changes saved (demo)';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get edit => 'Edit';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get cashPayment => 'Cash';

  @override
  String get cardPayment => 'Card';

  @override
  String get mixedPayment => 'Mixed';

  @override
  String get paidAmountLabel => 'Paid amount';

  @override
  String get cashAmountLabel => 'Cash amount';

  @override
  String get cardAmountLabel => 'Card amount';

  @override
  String get confirmPayment => 'Confirm payment';

  @override
  String get enterPaidAmount => 'Enter paid amount.';

  @override
  String get enterCashAmount => 'Enter cash amount.';

  @override
  String get enterCardAmount => 'Enter card amount.';

  @override
  String get paymentTotalMismatch => 'Amounts must equal total.';

  @override
  String get paidAmountTooLow => 'Paid amount must be at least total.';

  @override
  String get paymentTotalTooHigh => 'Amounts cannot exceed total.';

  @override
  String get discountLabel => 'Discount';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String get receiptNoLabel => 'Receipt No';

  @override
  String get receiptIdLabel => 'Receipt ID';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get taxLabel => 'Tax';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get taxNumberLabel => 'Tax No';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get changeLabel => 'Change';

  @override
  String get printPos => 'Print POS';

  @override
  String get printPdf => 'Print PDF';

  @override
  String get sharePdf => 'Save PDF';

  @override
  String get printFailed => 'Unable to print. Please try again.';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get printerModeLabel => 'Printer mode';

  @override
  String get posPrinter => 'POS (Bluetooth)';

  @override
  String get pdfPrinter => 'PDF / System';

  @override
  String get bluetoothPrintersLabel => 'Bluetooth printers';

  @override
  String get noBluetoothPrinters => 'No bluetooth printers found.';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get scanning => 'Scanning...';

  @override
  String get unableToVerifySession =>
      'Unable to verify your saved session. Check your connection and try again.';

  @override
  String get unexpectedServerResponse =>
      'The server returned an unexpected response. Please try again.';

  @override
  String get bluetoothDisabled => 'Turn on Bluetooth and try again.';

  @override
  String get bluetoothPermissionRequired =>
      'Bluetooth permission is required to find paired printers.';

  @override
  String get printerConnectionFailed =>
      'Could not connect to the selected printer.';

  @override
  String get printerDisconnected => 'The printer disconnected while printing.';

  @override
  String get invalidProductCode => 'Enter a valid product code.';

  @override
  String get invalidSaleQuantity => 'Enter a valid sale quantity.';

  @override
  String get duplicateSaleItem =>
      'A product cannot appear more than once in a sale.';

  @override
  String get overlappingShifts => 'Work shifts cannot overlap.';

  @override
  String get routeNotFound => 'This page could not be found.';

  @override
  String get backToHome => 'Back to home';

  @override
  String get offlineSalesTitle => 'Offline sales';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncingSales => 'Synchronizing pending sales...';

  @override
  String get noOfflineSales => 'No local sales have been saved yet.';

  @override
  String previousAccountPendingSales(int count) {
    return '$count unsynchronized sale(s) belong to another account and will not be uploaded with this session.';
  }

  @override
  String temporarySaleReference(String reference) {
    return 'Local reference: $reference';
  }

  @override
  String localSaleItemsAndTotal(int count, String total) {
    return '$count item(s) · Total $total';
  }

  @override
  String syncAttempts(int count) {
    return 'Sync attempts: $count';
  }

  @override
  String stockConflictDetails(int requested, int available) {
    return 'Stock changed on the server. Requested: $requested, available: $available.';
  }

  @override
  String get idempotencyConflictHelp =>
      'This sale ID conflicts with different server data. Keep the record and contact an administrator.';

  @override
  String get saleSyncFailed =>
      'This sale could not be synchronized. Review it before retrying.';

  @override
  String get pendingReceiptNotice =>
      'This is a local sale. A confirmed receipt number is available only after synchronization.';

  @override
  String get saleQueuedForSync => 'Sale queued for synchronization.';

  @override
  String get unableToRetrySale => 'This sale cannot be retried right now.';

  @override
  String get retrySync => 'Retry sync';

  @override
  String get viewConfirmedReceipt => 'View confirmed receipt';

  @override
  String get syncStatusPending => 'Pending';

  @override
  String get syncStatusSyncing => 'Syncing';

  @override
  String get syncStatusSynced => 'Synced';

  @override
  String get syncStatusFailed => 'Failed';

  @override
  String get syncStatusStockConflict => 'Stock conflict';

  @override
  String get syncStatusIdempotencyConflict => 'ID conflict';

  @override
  String get saleSavedLocally =>
      'Sale saved locally and queued for synchronization.';

  @override
  String get cachedProductsNotice =>
      'Showing cached products. Stock includes local reservations.';

  @override
  String get refreshProducts => 'Refresh';

  @override
  String get localDatabaseError =>
      'Local storage is unavailable. The sale was not cleared; please try again.';

  @override
  String get insufficientLocalStock =>
      'There is not enough locally available stock for this sale.';

  @override
  String get idempotencyConflict =>
      'This sale has an identifier conflict and needs administrator review.';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get supplier => 'Supplier';

  @override
  String get addSupplier => 'Add supplier';

  @override
  String get editSupplier => 'Edit supplier';

  @override
  String get supplierName => 'Supplier name';

  @override
  String get supplierDetails => 'Supplier details';

  @override
  String get supplierInformation => 'Supplier information';

  @override
  String get activeSupplier => 'Active supplier';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get all => 'All';

  @override
  String get address => 'Address';

  @override
  String get notes => 'Notes';

  @override
  String get searchSuppliers => 'Search suppliers';

  @override
  String get noSuppliers => 'No suppliers found.';

  @override
  String get noSupplierData => 'Supplier data is unavailable.';

  @override
  String get notAvailable => 'Not available';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get outstandingBalance => 'Outstanding balance';

  @override
  String get purchaseInvoices => 'Purchase invoices';

  @override
  String get purchaseInvoice => 'Purchase invoice';

  @override
  String get noPurchaseInvoices => 'No purchase invoices.';

  @override
  String get payments => 'Payments';

  @override
  String get noPayments => 'No payments.';

  @override
  String get statement => 'Statement';

  @override
  String get noStatementEntries => 'No statement entries.';

  @override
  String get totalPurchases => 'Total purchases';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get debit => 'Debit';

  @override
  String get credit => 'Credit';

  @override
  String get recordPayment => 'Record payment';

  @override
  String get recordSupplierPayment => 'Record supplier payment';

  @override
  String get paymentRecorded => 'Payment recorded.';

  @override
  String get amount => 'Amount';

  @override
  String get paidDate => 'Paid date';

  @override
  String get reference => 'Reference';

  @override
  String get bankTransfer => 'Bank transfer';

  @override
  String get other => 'Other';

  @override
  String get invalidPaymentAmount =>
      'Enter a positive amount that does not exceed the invoice remainder.';

  @override
  String remainingAmount(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String get purchases => 'Purchases';

  @override
  String get createPurchase => 'Create purchase';

  @override
  String get createPurchaseDraft => 'Create purchase draft';

  @override
  String get editPurchaseDraft => 'Edit purchase draft';

  @override
  String get purchaseDetails => 'Purchase details';

  @override
  String get searchPurchases => 'Search purchases';

  @override
  String get noPurchases => 'No purchases found.';

  @override
  String get draft => 'Draft';

  @override
  String get posted => 'Posted';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get unknownStatus => 'Unknown';

  @override
  String purchaseNumber(int number) {
    return 'Purchase #$number';
  }

  @override
  String get unknownSupplier => 'Unknown supplier';

  @override
  String get dateRange => 'Date range';

  @override
  String get supplierInvoiceNumber => 'Supplier invoice number';

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get postingDate => 'Posting date';

  @override
  String get createdBy => 'Created by';

  @override
  String get initialPaidAmount => 'Initial paid amount';

  @override
  String get purchaseItems => 'Purchase items';

  @override
  String get unitCost => 'Unit cost';

  @override
  String get lastPurchasePrice => 'Last purchase price';

  @override
  String get averageCost => 'Average cost';

  @override
  String get inStockLabel => 'Current stock';

  @override
  String get subtotalPreview => 'Subtotal preview';

  @override
  String get backendTotalsAuthoritative =>
      'Final totals are confirmed by the server.';

  @override
  String get saveDraft => 'Save draft';

  @override
  String get selectSupplier => 'Select a supplier.';

  @override
  String get invalidNonNegativeAmount => 'Enter a valid non-negative amount.';

  @override
  String get addAtLeastOnePurchaseItem => 'Add at least one purchase item.';

  @override
  String get duplicatePurchaseProduct =>
      'A product cannot appear more than once in a purchase.';

  @override
  String get invalidPurchaseItem =>
      'Each item needs a positive whole quantity and positive unit cost.';

  @override
  String get draftSavedNoStockChange =>
      'Draft saved. Product stock was not changed.';

  @override
  String get purchasesRequireInternet =>
      'Purchases require an internet connection.';

  @override
  String get remaining => 'Remaining';

  @override
  String get postInvoice => 'Post invoice';

  @override
  String get postPurchaseTitle => 'Post purchase invoice?';

  @override
  String get postPurchaseWarning =>
      'Stock will increase, product costs will update, and this invoice will become immutable. This action cannot currently be reversed in the application.';

  @override
  String get purchasePosted => 'Purchase invoice posted.';

  @override
  String get postTimeoutRetryHelp =>
      'Posting could not be confirmed. The invoice was checked again; retry only if it is still a draft.';

  @override
  String get deleteDraftTitle => 'Delete purchase draft?';

  @override
  String get deleteDraftMessage =>
      'This removes the draft. No stock has been changed.';

  @override
  String get stockMovements => 'Stock movements';

  @override
  String get filters => 'Filters';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get movementType => 'Movement type';

  @override
  String get purchaseInvoiceId => 'Purchase invoice ID';

  @override
  String get saleId => 'Sale ID';

  @override
  String get movementHistoryNotice =>
      'Movement history is available for transactions recorded after inventory tracking was enabled.';

  @override
  String get noStockMovements => 'No stock movements found.';

  @override
  String get openingStock => 'Opening stock';

  @override
  String get purchaseMovement => 'Purchase';

  @override
  String get purchaseReversal => 'Purchase reversal';

  @override
  String get saleMovement => 'Sale';

  @override
  String get saleReversal => 'Sale reversal';

  @override
  String get manualAdjustment => 'Manual adjustment';

  @override
  String stockBeforeAfter(int before, int after) {
    return '$before → $after';
  }

  @override
  String get adjustmentReason => 'Adjustment reason';

  @override
  String get adjustmentReasonRequired =>
      'Enter a reason for the stock adjustment.';

  @override
  String get stockMovementWillBeRecorded =>
      'A stock movement will be recorded.';

  @override
  String stockAdjustmentSummary(int current, int next, String difference) {
    return 'Current: $current · New: $next · Difference: $difference';
  }

  @override
  String get procurementAndStock => 'Procurement and stock';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivateSupplierTitle => 'Deactivate supplier?';

  @override
  String get deactivateSupplierMessage =>
      'The supplier will be hidden from active selections. Existing purchase history remains available.';

  @override
  String get supplierInactive => 'This supplier is inactive.';

  @override
  String get invoiceAlreadyPosted => 'This invoice has already been posted.';

  @override
  String get invoiceNotEditable => 'This invoice can no longer be edited.';

  @override
  String get paymentExceedsRemaining =>
      'The payment exceeds the invoice\'s remaining amount. Refresh and try again.';
}
