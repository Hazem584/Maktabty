import 'dart:io';

import 'package:maktabty/core/services/bluetooth_printer_adapter.dart';
import 'package:maktabty/core/services/printer_device.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

abstract class BluetoothPrinterPlatform {
  Future<bool> get hasPermission;
  Future<bool> get isBluetoothEnabled;
  Future<List<PrinterDevice>> getBondedDevices();
  Future<bool> get isConnected;
  Future<bool> connect(String address);
  Future<bool> writeBytes(List<int> bytes);
}

class PrintBluetoothThermalPlatform implements BluetoothPrinterPlatform {
  const PrintBluetoothThermalPlatform();

  @override
  Future<bool> get hasPermission =>
      PrintBluetoothThermal.isPermissionBluetoothGranted;

  @override
  Future<bool> get isBluetoothEnabled => PrintBluetoothThermal.bluetoothEnabled;

  @override
  Future<List<PrinterDevice>> getBondedDevices() async {
    final devices = await PrintBluetoothThermal.pairedBluetooths;
    return devices
        .map(
          (device) => PrinterDevice(
            name: device.name.trim().isEmpty ? 'Unknown printer' : device.name,
            address: device.macAdress,
          ),
        )
        .where((device) => device.address.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  @override
  Future<bool> connect(String address) {
    return PrintBluetoothThermal.connect(macPrinterAddress: address);
  }

  @override
  Future<bool> writeBytes(List<int> bytes) {
    return PrintBluetoothThermal.writeBytes(bytes);
  }
}

class BluetoothPrinterAdapterIo implements BluetoothPrinterAdapter {
  final BluetoothPrinterPlatform _platform;
  final bool _isAndroid;

  BluetoothPrinterAdapterIo({
    this._platform = const PrintBluetoothThermalPlatform(),
    bool? isAndroidOverride,
  }) : _isAndroid = isAndroidOverride ?? Platform.isAndroid;

  @override
  Future<void> connect(PrinterDevice device) async {
    await _ensureAvailable();
    if (device.address.trim().isEmpty) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.connectionFailed,
        'The selected printer has no Bluetooth address.',
      );
    }

    try {
      final connected = await _platform.connect(device.address);
      if (!connected) {
        throw const BluetoothPrinterException(
          BluetoothPrinterError.connectionFailed,
          'Could not connect to the selected printer.',
        );
      }
    } on BluetoothPrinterException {
      rethrow;
    } catch (_) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.connectionFailed,
        'Could not connect to the selected printer.',
      );
    }
  }

  @override
  Future<List<PrinterDevice>> getBondedDevices() async {
    await _ensureAvailable();
    try {
      return await _platform.getBondedDevices();
    } catch (_) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.noPairedPrinter,
        'Unable to read paired Bluetooth printers.',
      );
    }
  }

  @override
  Future<bool> isConnected() async {
    _ensureSupported();
    try {
      return await _platform.isConnected;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> writeBytes(List<int> bytes) async {
    _ensureSupported();
    if (!await isConnected()) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.disconnected,
        'The printer disconnected before printing completed.',
      );
    }

    try {
      final written = await _platform.writeBytes(bytes);
      if (!written) {
        throw const BluetoothPrinterException(
          BluetoothPrinterError.writeFailed,
          'The printer did not accept the receipt data.',
        );
      }
    } on BluetoothPrinterException {
      rethrow;
    } catch (_) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.disconnected,
        'The printer disconnected while printing.',
      );
    }
  }

  Future<void> _ensureAvailable() async {
    _ensureSupported();

    final permitted = await _platform.hasPermission;
    if (!permitted) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.permissionDenied,
        'Bluetooth permission is required to use the printer.',
      );
    }

    final enabled = await _platform.isBluetoothEnabled;
    if (!enabled) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.bluetoothDisabled,
        'Turn on Bluetooth before selecting a printer.',
      );
    }
  }

  void _ensureSupported() {
    if (!_isAndroid) {
      throw const BluetoothPrinterException(
        BluetoothPrinterError.unsupportedPlatform,
        'Bluetooth receipt printing is supported on Android only.',
      );
    }
  }
}

BluetoothPrinterAdapter createBluetoothPrinterAdapter() {
  return BluetoothPrinterAdapterIo();
}
