import 'package:maktabty/core/services/printer_device.dart';

import 'bluetooth_printer_adapter_stub.dart'
    if (dart.library.io) 'bluetooth_printer_adapter_io.dart';

abstract class BluetoothPrinterAdapter {
  Future<List<PrinterDevice>> getBondedDevices();
  Future<bool> isConnected();
  Future<void> connect(PrinterDevice device);
  Future<void> writeBytes(List<int> bytes);
}

BluetoothPrinterAdapter getBluetoothPrinterAdapter() {
  return createBluetoothPrinterAdapter();
}
