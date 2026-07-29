import 'package:maktabty/core/services/printer_device.dart';

import 'bluetooth_printer_adapter_stub.dart'
    if (dart.library.io) 'bluetooth_printer_adapter_io.dart';

enum BluetoothPrinterError {
  unsupportedPlatform,
  permissionDenied,
  bluetoothDisabled,
  noPairedPrinter,
  connectionFailed,
  disconnected,
  writeFailed,
}

class BluetoothPrinterException implements Exception {
  final BluetoothPrinterError error;
  final String message;

  const BluetoothPrinterException(this.error, this.message);

  @override
  String toString() => 'BluetoothPrinterException($error, $message)';
}

abstract class BluetoothPrinterAdapter {
  Future<List<PrinterDevice>> getBondedDevices();
  Future<bool> isConnected();
  Future<void> connect(PrinterDevice device);
  Future<void> writeBytes(List<int> bytes);
}

BluetoothPrinterAdapter getBluetoothPrinterAdapter() {
  return createBluetoothPrinterAdapter();
}
