# Maktabty

Cross-platform point-of-sale and inventory client for Android and Windows.

## Requirements

- Flutter 3.44.0 or newer (verified with 3.44.6)
- Dart 3.12.0 or newer
- Android SDK with API 21 or newer
- Visual Studio with Desktop development with C++ for Windows builds
- A running compatible NestJS backend

## Environment and backend URL

Copy `.env.example` to `.env`, then set `API_BASE_URL` to an absolute HTTP or
HTTPS URL. `.env` is ignored by Git and must never contain committed secrets.

```env
API_BASE_URL=http://10.0.2.2:3000
```

The app validates this value before dependency setup. Missing, malformed,
credential-bearing, query-bearing, and `api.example.com` placeholder URLs stop
startup with a configuration error. Trailing slashes are normalized before the
URL reaches Dio.

A production build can inject the same setting without changing source:

```bash
flutter build apk --dart-define=API_BASE_URL=https://api.your-domain.example
```

Platform examples:

- Android emulator: `http://10.0.2.2:3000` reaches the host machine. Debug
  builds permit cleartext traffic for this development workflow.
- Physical Android device: use an HTTPS endpoint or a LAN address reachable
  from the device, for example `http://192.168.1.20:3000`. Check the host
  firewall and do not use `localhost`.
- Windows: use `http://localhost:3000` for a backend on the same PC, a reachable
  LAN URL, or the configured production HTTPS endpoint.

## Bluetooth thermal printing

Android Bluetooth receipt output uses `print_bluetooth_thermal` behind
`BluetoothPrinterAdapter`. Receipts remain 80 mm ESC/POS output, including the
existing Arabic reshaping and bidi handling. Windows and unsupported platforms
continue to use the PDF/system print path.

Only paired classic Bluetooth printers are listed. Android 12 and newer asks
for the Nearby devices / Bluetooth connect permission. Discovery, location,
and Bluetooth scan permissions are not requested by Maktabty.

To pair and test a printer:

1. Pair the thermal printer in Android system Bluetooth settings.
2. Grant Nearby devices when Maktabty requests it.
3. Open Printer Settings, choose POS (Bluetooth), scan, select the paired
   printer, and save.
4. Complete a test sale and print a receipt containing English, Arabic,
   multiple line items, totals, and the cut/feed command.
5. Turn Bluetooth off and repeat to confirm the localized error.
6. Disconnect or power off the printer during a print to confirm one reconnect
   attempt and a clear failure message.
7. Switch to PDF/System and verify the Android print dialog; on Windows verify
   both the print dialog and Save PDF.

Hardware limitations:

- Printer firmware must support classic Bluetooth RFCOMM and raw ESC/POS.
- Character tables, paper cutters, and image support vary by model.
- Arabic is reshaped before byte generation, but exact glyph coverage depends
  on the printer's installed code pages and must be checked on real hardware.
- Pairing is performed by the operating system, not inside Maktabty.

## Development commands

```bash
flutter pub get
flutter gen-l10n
dart format .
flutter analyze
flutter test
flutter build apk --debug
flutter build windows
```

No separate application code generation step is currently required beyond
Flutter localization generation.
