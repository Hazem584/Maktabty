import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/services/barcode_scanner_service_mobile.dart';
import 'package:maktabty/core/services/barcode_scanner_service_windows.dart';
import 'package:maktabty/core/services/receipt_printer_service.dart';
import 'package:maktabty/core/storage/printer_settings_storage.dart';

void registerServicesDependencies(GetIt getIt) {
  if (!getIt.isRegistered<BarcodeScannerService>()) {
    getIt.registerLazySingleton<BarcodeScannerService>(() {
      final isWindows =
          !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
      return isWindows
          ? WindowsBarcodeScannerService()
          : MobileBarcodeScannerService();
    });
  }
  if (!getIt.isRegistered<PrinterSettingsStorage>()) {
    getIt.registerLazySingleton(PrinterSettingsStorage.new);
  }
  if (!getIt.isRegistered<ReceiptPrinterService>()) {
    getIt.registerLazySingleton(
      () => ReceiptPrinterService(settingsStorage: getIt()),
    );
  }
}
