import 'package:maktabty/core/services/printer_device.dart';

import 'bluetooth_printer_adapter.dart';

class _StubBluetoothPrinterAdapter implements BluetoothPrinterAdapter {
  @override
  Future<void> connect(PrinterDevice device) async {
    throw const BluetoothPrinterException(
      BluetoothPrinterError.unsupportedPlatform,
      'Bluetooth receipt printing is not supported on this platform.',
    );
  }

  @override
  Future<List<PrinterDevice>> getBondedDevices() async {
    return const [];
  }

  @override
  Future<bool> isConnected() async {
    return false;
  }

  @override
  Future<void> writeBytes(List<int> bytes) async {
    throw const BluetoothPrinterException(
      BluetoothPrinterError.unsupportedPlatform,
      'Bluetooth receipt printing is not supported on this platform.',
    );
  }
}

BluetoothPrinterAdapter createBluetoothPrinterAdapter() {
  return _StubBluetoothPrinterAdapter();
}
