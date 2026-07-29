import 'package:maktabty/core/services/printer_device.dart';

import 'bluetooth_printer_adapter.dart';

class _StubBluetoothPrinterAdapter implements BluetoothPrinterAdapter {
  @override
  Future<void> connect(PrinterDevice device) async {
    throw UnsupportedError('Bluetooth printing not supported');
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
    throw UnsupportedError('Bluetooth printing not supported');
  }
}

BluetoothPrinterAdapter createBluetoothPrinterAdapter() {
  return _StubBluetoothPrinterAdapter();
}
