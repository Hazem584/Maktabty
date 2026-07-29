import 'package:flutter/material.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/widgets/barcode_scanner_page.dart';

class MobileBarcodeScannerService implements BarcodeScannerService {
  @override
  Future<String?> scan(BuildContext context, {String? title}) {
    return BarcodeScannerPage.scan(context, title: title);
  }
}
