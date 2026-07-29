import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PrinterMode { pdf, bluetooth }

class PrinterSettings {
  final PrinterMode mode;
  final String? bluetoothName;
  final String? bluetoothAddress;

  const PrinterSettings({
    required this.mode,
    this.bluetoothName,
    this.bluetoothAddress,
  });

  factory PrinterSettings.defaults() {
    return const PrinterSettings(mode: PrinterMode.pdf);
  }

  PrinterSettings copyWith({
    PrinterMode? mode,
    String? bluetoothName,
    String? bluetoothAddress,
  }) {
    return PrinterSettings(
      mode: mode ?? this.mode,
      bluetoothName: bluetoothName ?? this.bluetoothName,
      bluetoothAddress: bluetoothAddress ?? this.bluetoothAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'bluetoothName': bluetoothName,
      'bluetoothAddress': bluetoothAddress,
    };
  }

  factory PrinterSettings.fromJson(Map<String, dynamic> json) {
    final rawMode = json['mode']?.toString();
    final mode = PrinterMode.values.firstWhere(
      (item) => item.name == rawMode,
      orElse: () => PrinterMode.pdf,
    );
    return PrinterSettings(
      mode: mode,
      bluetoothName: json['bluetoothName']?.toString(),
      bluetoothAddress: json['bluetoothAddress']?.toString(),
    );
  }
}

class PrinterSettingsStorage {
  static const _key = 'printer_settings';
  final FlutterSecureStorage _storage;

  PrinterSettingsStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<PrinterSettings> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) {
      return PrinterSettings.defaults();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return PrinterSettings.fromJson(decoded);
      }
      if (decoded is Map) {
        return PrinterSettings.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return PrinterSettings.defaults();
  }

  Future<void> save(PrinterSettings settings) {
    return _storage.write(key: _key, value: jsonEncode(settings.toJson()));
  }
}
