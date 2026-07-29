import 'package:flutter/material.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/storage/printer_settings_storage.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/services/printer_device.dart';
import 'package:maktabty/core/services/receipt_printer_service.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  final PrinterSettingsStorage _storage = sl<PrinterSettingsStorage>();
  final ReceiptPrinterService _printerService = sl<ReceiptPrinterService>();

  PrinterSettings _settings = PrinterSettings.defaults();
  List<PrinterDevice> _devices = const [];
  bool _loading = true;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await _storage.load();
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
    });
    final devices = await _printerService.getBluetoothDevices();
    setState(() {
      _devices = devices;
      _scanning = false;
    });
  }

  Future<void> _save() async {
    await _storage.save(_settings);
    if (!mounted) return;
    AppToast.show(context.l10n.settingsSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.printerSettings),
      ),
      body: _loading
          ? const Center(child: AppLoading())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                Text(l10n.printerModeLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s),
                SegmentedButton<PrinterMode>(
                  segments: [
                    ButtonSegment(
                      value: PrinterMode.pdf,
                      label: Text(l10n.pdfPrinter),
                    ),
                    ButtonSegment(
                      value: PrinterMode.bluetooth,
                      label: Text(l10n.posPrinter),
                    ),
                  ],
                  selected: {_settings.mode},
                  onSelectionChanged: (value) {
                    if (value.isEmpty) return;
                    setState(() {
                      _settings = _settings.copyWith(mode: value.first);
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.l),
                if (_settings.mode == PrinterMode.bluetooth) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.bluetoothPrintersLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: _scanning ? null : _scan,
                        child: Text(
                          _scanning ? l10n.scanning : l10n.scan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),
                  if (_devices.isEmpty)
                    Text(
                      l10n.noBluetoothPrinters,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    )
                  else
                    ..._devices.map(
                      (device) => RadioListTile<String>(
                        value: device.address,
                        groupValue: _settings.bluetoothAddress,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _settings = _settings.copyWith(
                              bluetoothAddress: device.address,
                              bluetoothName: device.name,
                            );
                          });
                        },
                        title: Text(device.name),
                        subtitle: Text(device.address),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.l),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
    );
  }
}
