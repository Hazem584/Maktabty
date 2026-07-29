import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:maktabty/core/services/bluetooth_printer_adapter.dart';
import 'package:maktabty/core/services/printer_device.dart';

class _IoBluetoothPrinterAdapter implements BluetoothPrinterAdapter {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  @override
  Future<void> connect(PrinterDevice device) async {
    await _printer.connect(
      BluetoothDevice(device.name, device.address),
    );
  }

  @override
  Future<List<PrinterDevice>> getBondedDevices() async {
    final devices = await _printer.getBondedDevices();
    return devices
        .whereType<BluetoothDevice>()
        .map(
          (device) => PrinterDevice(
            name: device.name ?? 'Unknown',
            address: device.address ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<bool> isConnected() async {
    return await _printer.isConnected ?? false;
  }

  @override
  Future<void> writeBytes(List<int> bytes) async {
    await _printer.writeBytes(Uint8List.fromList(bytes));
  }
}

BluetoothPrinterAdapter createBluetoothPrinterAdapter() {
  return _IoBluetoothPrinterAdapter();
}
