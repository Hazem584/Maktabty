import 'package:flutter/material.dart';

abstract class BarcodeScannerService {
  Future<String?> scan(BuildContext context, {String? title});
}
