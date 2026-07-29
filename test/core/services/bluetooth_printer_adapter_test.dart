import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/services/bluetooth_printer_adapter.dart';
import 'package:maktabty/core/services/bluetooth_printer_adapter_io.dart';
import 'package:maktabty/core/services/printer_device.dart';

class FakeBluetoothPrinterPlatform implements BluetoothPrinterPlatform {
  bool permission = true;
  bool enabled = true;
  bool connected = false;
  bool connectResult = true;
  bool writeResult = true;
  List<PrinterDevice> devices = const [];
  List<int>? writtenBytes;

  @override
  Future<bool> get hasPermission async => permission;

  @override
  Future<bool> get isBluetoothEnabled async => enabled;

  @override
  Future<List<PrinterDevice>> getBondedDevices() async => devices;

  @override
  Future<bool> get isConnected async => connected;

  @override
  Future<bool> connect(String address) async {
    connected = connectResult;
    return connectResult;
  }

  @override
  Future<bool> writeBytes(List<int> bytes) async {
    writtenBytes = bytes;
    return writeResult;
  }
}

void main() {
  const printer = PrinterDevice(
    name: 'Thermal Printer',
    address: '00:11:22:33:44:55',
  );

  test('unsupported platforms fail with a typed printer error', () async {
    final adapter = BluetoothPrinterAdapterIo(
      platform: FakeBluetoothPrinterPlatform(),
      isAndroidOverride: false,
    );

    expect(
      adapter.connect(printer),
      throwsA(
        isA<BluetoothPrinterException>().having(
          (error) => error.error,
          'error',
          BluetoothPrinterError.unsupportedPlatform,
        ),
      ),
    );
  });

  test('permission denial is represented clearly', () async {
    final platform = FakeBluetoothPrinterPlatform()..permission = false;
    final adapter = BluetoothPrinterAdapterIo(
      platform: platform,
      isAndroidOverride: true,
    );

    expect(
      adapter.getBondedDevices(),
      throwsA(
        isA<BluetoothPrinterException>().having(
          (error) => error.error,
          'error',
          BluetoothPrinterError.permissionDenied,
        ),
      ),
    );
  });

  test('disabled Bluetooth is represented clearly', () async {
    final platform = FakeBluetoothPrinterPlatform()..enabled = false;
    final adapter = BluetoothPrinterAdapterIo(
      platform: platform,
      isAndroidOverride: true,
    );

    expect(
      adapter.getBondedDevices(),
      throwsA(
        isA<BluetoothPrinterException>().having(
          (error) => error.error,
          'error',
          BluetoothPrinterError.bluetoothDisabled,
        ),
      ),
    );
  });

  test('no paired printer is a valid empty result', () async {
    final adapter = BluetoothPrinterAdapterIo(
      platform: FakeBluetoothPrinterPlatform(),
      isAndroidOverride: true,
    );
    expect(await adapter.getBondedDevices(), isEmpty);
  });

  test(
    'connect and raw ESC/POS byte write succeed through abstraction',
    () async {
      final platform = FakeBluetoothPrinterPlatform();
      final adapter = BluetoothPrinterAdapterIo(
        platform: platform,
        isAndroidOverride: true,
      );

      await adapter.connect(printer);
      await adapter.writeBytes(const [0x1b, 0x40, 0x0a]);

      expect(platform.writtenBytes, const [0x1b, 0x40, 0x0a]);
    },
  );

  test('failed connection and disconnection during write are typed', () async {
    final failedPlatform = FakeBluetoothPrinterPlatform()
      ..connectResult = false;
    final failedAdapter = BluetoothPrinterAdapterIo(
      platform: failedPlatform,
      isAndroidOverride: true,
    );
    expect(
      failedAdapter.connect(printer),
      throwsA(
        isA<BluetoothPrinterException>().having(
          (error) => error.error,
          'error',
          BluetoothPrinterError.connectionFailed,
        ),
      ),
    );

    final disconnectedAdapter = BluetoothPrinterAdapterIo(
      platform: FakeBluetoothPrinterPlatform(),
      isAndroidOverride: true,
    );
    expect(
      disconnectedAdapter.writeBytes(const [1, 2, 3]),
      throwsA(
        isA<BluetoothPrinterException>().having(
          (error) => error.error,
          'error',
          BluetoothPrinterError.disconnected,
        ),
      ),
    );
  });
}
